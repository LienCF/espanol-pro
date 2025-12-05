import { Hono } from 'hono'
import { cors } from 'hono/cors'

type Bindings = {
  DB: D1Database
  BUCKET: R2Bucket
  AI: any
}

const app = new Hono<{ Bindings: Bindings }>()

app.use('/*', cors())

app.get('/', (c) => {
  return c.text('Hola, Español Pro API!')
})

// 1. Get all courses
app.get('/api/courses', async (c) => {
  const userId = c.req.query('userId') || 'test_user_1'
  try {
    // Get courses with progress
    const { results } = await c.env.DB.prepare(`
      SELECT c.*, 
             COALESCE(ucp.completed_lessons_count, 0) as completed_count,
             (SELECT COUNT(*) FROM lessons l JOIN units u ON l.unit_id = u.id WHERE u.course_id = c.id) as total_lessons
      FROM courses c
      LEFT JOIN user_course_progress ucp ON c.id = ucp.course_id AND ucp.user_id = ?
      ORDER BY c.level, c.title
    `).bind(userId).all()
    return c.json(results)
  } catch (e) {
    return c.json({ error: e }, 500)
  }
})

// 2. Get course details (including units and completed lesson IDs)
app.get('/api/courses/:id', async (c) => {
  const id = c.req.param('id')
  const userId = c.req.query('userId') || 'test_user_1'
  
  try {
    const course = await c.env.DB.prepare(
      'SELECT * FROM courses WHERE id = ?'
    ).bind(id).first()

    if (!course) return c.json({ error: 'Course not found' }, 404)

    // Fetch units for this course
    const { results: units } = await c.env.DB.prepare(
      'SELECT * FROM units WHERE course_id = ? ORDER BY order_index'
    ).bind(id).all()

    // Fetch completed lesson IDs for this course
    // We get distinct lesson_ids from study_logs where is_correct = 1 (or completed)
    // Efficient query might need a dedicated table later, but logs work for MVP
    const { results: completedLessons } = await c.env.DB.prepare(`
      SELECT DISTINCT lesson_id 
      FROM study_logs 
      WHERE user_id = ? 
      AND is_correct = 1 
      AND lesson_id IN (
        SELECT l.id FROM lessons l
        JOIN units u ON l.unit_id = u.id
        WHERE u.course_id = ?
      )
    `).bind(userId, id).all()

    const completedLessonIds = completedLessons.map((r: any) => r.lesson_id)

    return c.json({ ...course, units, completedLessonIds })
  } catch (e) {
    return c.json({ error: e }, 500)
  }
})

// 3. Get lessons for a unit
app.get('/api/units/:id/lessons', async (c) => {
  const id = c.req.param('id')
  try {
    const { results } = await c.env.DB.prepare(
      'SELECT id, unit_id, title, content_type, order_index FROM lessons WHERE unit_id = ? ORDER BY order_index'
    ).bind(id).all()
    return c.json(results)
  } catch (e) {
    return c.json({ error: e }, 500)
  }
})

// 4. Get single lesson content
app.get('/api/lessons/:id', async (c) => {
  const id = c.req.param('id')
  try {
    const lesson = await c.env.DB.prepare(
      'SELECT * FROM lessons WHERE id = ?'
    ).bind(id).first()
    
    if (!lesson) return c.json({ error: 'Lesson not found' }, 404)
    
    return c.json(lesson)
  } catch (e) {
    return c.json({ error: e }, 500)
  }
})

// 5. Record Progress
app.post('/api/progress', async (c) => {
  try {
    const body = await c.req.json()
    const { userId, lessonId, courseId, isCorrect, interactionType } = body

    // 1. Log the raw interaction
    await c.env.DB.prepare(
      'INSERT INTO study_logs (user_id, lesson_id, interaction_type, is_correct, timestamp) VALUES (?, ?, ?, ?, ?)'
    ).bind(userId, lessonId, interactionType || 'COMPLETION', isCorrect ? 1 : 0, Math.floor(Date.now() / 1000)).run()

    // 2. Update User Course Progress (Upsert Logic)
    // First, check if progress record exists
    const progress = await c.env.DB.prepare(
      'SELECT * FROM user_course_progress WHERE user_id = ? AND course_id = ?'
    ).bind(userId, courseId).first()

    if (progress) {
      // Update existing
      await c.env.DB.prepare(
        'UPDATE user_course_progress SET completed_lessons_count = completed_lessons_count + 1, last_updated = ? WHERE user_id = ? AND course_id = ?'
      ).bind(Math.floor(Date.now() / 1000), userId, courseId).run()
    } else {
      // Insert new
      await c.env.DB.prepare(
        'INSERT INTO user_course_progress (user_id, course_id, completed_lessons_count, last_updated) VALUES (?, ?, 1, ?)'
      ).bind(userId, courseId, Math.floor(Date.now() / 1000)).run()
    }

    return c.json({ success: true })
  } catch (e) {
    console.error(e)
    return c.json({ error: 'Failed to record progress' }, 500)
  }
})

// 6. Auth (Simple Login)
app.post('/api/auth/login', async (c) => {
  try {
    const { email } = await c.req.json()
    if (!email) return c.json({ error: 'Email is required' }, 400)

    // Check if user exists
    const user = await c.env.DB.prepare(
      'SELECT * FROM users WHERE email = ?'
    ).bind(email).first()

    if (user) {
      // Update last login
      await c.env.DB.prepare(
        'UPDATE users SET last_login = ? WHERE id = ?'
      ).bind(Math.floor(Date.now() / 1000), user.id).run()
      return c.json(user)
    } else {
      // Create new user
      const newId = crypto.randomUUID()
      const displayName = email.split('@')[0] // Default display name
      
      await c.env.DB.prepare(
        'INSERT INTO users (id, email, display_name, last_login) VALUES (?, ?, ?, ?)'
      ).bind(newId, email, displayName, Math.floor(Date.now() / 1000)).run()
      
      return c.json({ id: newId, email, display_name: displayName })
    }
  } catch (e) {
    console.error(e)
    return c.json({ error: 'Login failed' }, 500)
  }
})

// 7. AI Speech Evaluation
app.post('/api/ai/evaluate-speech', async (c) => {
  try {
    const body = await c.req.parseBody()
    const audioFile = body['audio']
    const referenceText = body['reference_text'] as string

    if (!audioFile || !(audioFile instanceof File)) {
      return c.json({ error: 'Audio file is required' }, 400)
    }

    if (!referenceText) {
      return c.json({ error: 'Reference text is required' }, 400)
    }

    // Run Whisper on Workers AI
    const arrayBuffer = await audioFile.arrayBuffer()
    // @ts-ignore
    const aiResponse = await c.env.AI.run('@cf/openai/whisper', {
      audio: [...new Uint8Array(arrayBuffer)]
    })

    const transcription = aiResponse.text || ''
    
    // Simple scoring: compare normalized strings
    // In a real app, use Levenshtein distance. Here, simpler word overlap.
    const normalize = (s: string) => s.toLowerCase().replace(/[^\w\s]/g, '')
    const targetWords = normalize(referenceText).split(/\s+/)
    const spokenWords = normalize(transcription).split(/\s+/)
    
    let matchCount = 0
    for (const word of targetWords) {
      if (spokenWords.includes(word)) matchCount++
    }
    
    const score = targetWords.length > 0 
      ? Math.round((matchCount / targetWords.length) * 100) 
      : 0

    return c.json({
      score: score,
      transcription: transcription,
      is_match: score > 80
    })

  } catch (e) {
    console.error(e)
    return c.json({ error: 'AI evaluation failed' }, 500)
  }
})

// 8. AI Chat (Llama 3 Roleplay)
app.post('/api/ai/chat', async (c) => {
  try {
    const { messages } = await c.req.json()
    
    if (!messages || !Array.isArray(messages)) {
      return c.json({ error: 'Messages array is required' }, 400)
    }

    // @ts-ignore
    const aiResponse = await c.env.AI.run('@cf/meta/llama-3-8b-instruct', {
      messages: messages
    })

    return c.json({ response: aiResponse.response })
  } catch (e) {
    console.error(e)
    return c.json({ error: 'AI Chat failed' }, 500)
  }
})

// 9. Serve Audio from R2
app.get('/:filename', async (c) => {
  const filename = c.req.param('filename')
  const object = await c.env.BUCKET.get(filename)

  if (object === null) {
    return c.text('Object Not Found', 404)
  }

  const headers = new Headers()
  object.writeHttpMetadata(headers)
  headers.set('etag', object.httpEtag)

  return new Response(object.body, {
    headers,
  })
})

export default app
