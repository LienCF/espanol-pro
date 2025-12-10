import { Hono } from 'hono'
import { cors } from 'hono/cors'
import { verifyAuth } from './middleware/auth'
import { calculateNewMastery } from './bkt'
import { calculateSimilarity, analyzePronunciation } from './utils/scoring'
import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3'
import { getSignedUrl } from '@aws-sdk/s3-request-presigner'
import Stripe from 'stripe'

type Bindings = {
  DB: D1Database
  BUCKET: R2Bucket
  AI: any
  ACCOUNT_ID: string
  R2_ACCESS_KEY_ID: string
  R2_SECRET_ACCESS_KEY: string
  STRIPE_SECRET_KEY: string
  STRIPE_WEBHOOK_SECRET: string
}

const app = new Hono<{ Bindings: Bindings }>()

app.use('/*', cors())
// ... existing imports ...

// Protect API routes
app.use('/api/*', async (c, next) => {
  const path = c.req.path
  if (path.startsWith('/api/auth') || path.startsWith('/api/payments/webhook')) {
    await next()
  } else if (path.startsWith('/api/admin')) {
    // Strict Admin Check
    return await verifyAuth(c, async () => {
      const user = c.get('user') as any
      if (!user) {
        return c.json({ error: 'Unauthorized' }, 401)
      }
      // Check admin table
      const admin = await c.env.DB.prepare('SELECT role FROM admins WHERE user_id = ?').bind(user.sub).first()
      if (!admin) {
        return c.json({ error: 'Forbidden: Admins only' }, 403)
      }
      await next()
    })
  } else {
    return await verifyAuth(c, next)
  }
})

// ... existing endpoints ...

// 17. Admin: Create Course
app.post('/api/admin/courses', async (c) => {
  try {
    const { id, title, slug, level, track_type, description } = await c.req.json()
    
    if (!id || !title || !slug) {
      return c.json({ error: 'Missing required fields' }, 400)
    }

    await c.env.DB.prepare(`
      INSERT INTO courses (id, slug, title, description, level, track_type, version)
      VALUES (?, ?, ?, ?, ?, ?, 1)
    `).bind(id, slug, title, description, level, track_type).run()

    return c.json({ success: true, id })
  } catch (e: any) {
    return c.json({ error: e.message }, 500)
  }
})

// 18. Admin: Update Course
app.put('/api/admin/courses/:id', async (c) => {
  try {
    const id = c.req.param('id')
    const { title, description, level, track_type, thumbnail_url } = await c.req.json()

    // Simple update logic, could be more dynamic
    await c.env.DB.prepare(`
      UPDATE courses 
      SET title = COALESCE(?, title),
          description = COALESCE(?, description),
          level = COALESCE(?, level),
          track_type = COALESCE(?, track_type),
          thumbnail_url = COALESCE(?, thumbnail_url),
          version = version + 1
      WHERE id = ?
    `).bind(title, description, level, track_type, thumbnail_url, id).run()

    return c.json({ success: true })
  } catch (e: any) {
    return c.json({ error: e.message }, 500)
  }
})

// 19. Admin: Delete Course
app.delete('/api/admin/courses/:id', async (c) => {
  try {
    const id = c.req.param('id')
    
    // Cascade delete manually (if D1 doesn't enforce it automatically via schema)
    // Delete Lessons
    await c.env.DB.prepare(`
      DELETE FROM lessons 
      WHERE unit_id IN (SELECT id FROM units WHERE course_id = ?)
    `).bind(id).run()
    
    // Delete Units
    await c.env.DB.prepare('DELETE FROM units WHERE course_id = ?').bind(id).run()
    
    // Delete Course
    await c.env.DB.prepare('DELETE FROM courses WHERE id = ?').bind(id).run()

    return c.json({ success: true })
  } catch (e: any) {
    return c.json({ error: e.message }, 500)
  }
})

// 20. Admin: Create/Update Lesson (Simplified Upsert for now)
app.post('/api/admin/lessons', async (c) => {
  try {
    const body = await c.req.json()
    const { id, unit_id, title, content_type, content_json, order_index, kc_id } = body;

    await c.env.DB.prepare(`
      INSERT INTO lessons (id, unit_id, title, content_type, content_json, order_index, kc_id)
      VALUES (?, ?, ?, ?, ?, ?, ?)
      ON CONFLICT(id) DO UPDATE SET
        title = excluded.title,
        content_type = excluded.content_type,
        content_json = excluded.content_json,
        order_index = excluded.order_index,
        kc_id = excluded.kc_id
    `).bind(id, unit_id, title, content_type, content_json, order_index, kc_id).run()

    // Trigger Course Version Bump
    const course = await c.env.DB.prepare('SELECT course_id FROM units WHERE id = ?').bind(unit_id).first();
    if (course) {
       await c.env.DB.prepare('UPDATE courses SET version = version + 1 WHERE id = ?').bind(course.course_id).run();
    }

    return c.json({ success: true })
  } catch (e: any) {
    return c.json({ error: e.message }, 500)
  }
})

// ... rest of the app ...


async function updateStreak(db: D1Database, userId: string) {
  const today = new Date().toISOString().split('T')[0];
  
  // Check if activity already logged for today
  const existing = await db.prepare('SELECT * FROM user_streaks WHERE user_id = ? AND activity_date = ?').bind(userId, today).first();
  
  if (existing) {
    // Already counted for today, just increment count
    await db.prepare('UPDATE user_streaks SET activity_count = activity_count + 1 WHERE user_id = ? AND activity_date = ?').bind(userId, today).run();
    return;
  }

  // It's a new day! Check yesterday for streak continuity
  const yesterday = new Date(Date.now() - 86400000).toISOString().split('T')[0];
  const yesterdayStreak = await db.prepare('SELECT * FROM user_streaks WHERE user_id = ? AND activity_date = ?').bind(userId, yesterday).first();

  let newStreakVal = 1;
  
  if (yesterdayStreak) {
    // Get current user streak count from users table to be safe or just increment based on continuity
    const user = await db.prepare('SELECT current_streak FROM users WHERE id = ?').bind(userId).first();
    const current = (user?.current_streak as number) || 0;
    newStreakVal = current + 1;
  } else {
    // Streak broken or new
    newStreakVal = 1;
  }

  // Update User table
  await db.prepare('UPDATE users SET current_streak = ?, last_streak_update = ? WHERE id = ?')
    .bind(newStreakVal, Math.floor(Date.now()/1000), userId).run();

  // Log daily activity
  await db.prepare('INSERT INTO user_streaks (user_id, activity_date, activity_count) VALUES (?, ?, 1)').bind(userId, today).run();
  
  // Bonus XP for keeping streak
  if (newStreakVal > 1) {
    const bonus = Math.min(newStreakVal * 10, 100); // Cap bonus
    await addXP(db, userId, bonus, 'STREAK_BONUS', today);
  }
}

async function addXP(db: D1Database, userId: string, amount: number, type: string, refId: string | null = null) {
  await db.prepare('INSERT INTO xp_logs (user_id, amount, source_type, reference_id, timestamp) VALUES (?, ?, ?, ?, ?)')
    .bind(userId, amount, type, refId, Math.floor(Date.now()/1000)).run();
  
  await db.prepare('UPDATE users SET total_xp = total_xp + ? WHERE id = ?')
    .bind(amount, userId).run();
}

// 12. Stripe Checkout Session
app.post('/api/payments/create-checkout-session', async (c) => {
  try {
    const user = c.get('user') as any
    if (!user) return c.json({ error: 'Unauthorized' }, 401)

    const stripe = new Stripe(c.env.STRIPE_SECRET_KEY, { apiVersion: '2025-01-27.acacia' as any }) // Use latest or compatible version
    
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      line_items: [
        {
          price_data: {
            currency: 'usd',
            product_data: {
              name: 'Español Pro Premium',
              description: 'Unlock all specialized courses and AI features.',
            },
            unit_amount: 999, // $9.99
          },
          quantity: 1,
        },
      ],
      mode: 'payment', // or 'subscription'
      success_url: 'https://espanol-pro.app/success', // In a real app, use deep link or hosted success page
      cancel_url: 'https://espanol-pro.app/cancel',
      client_reference_id: user.sub, // Pass user ID to webhook
      metadata: {
        userId: user.sub
      }
    })

    return c.json({ url: session.url })
  } catch (e: any) {
    console.error('Stripe Error:', e)
    return c.json({ error: e.message }, 500)
  }
})

// 13. Stripe Webhook
app.post('/api/payments/webhook', async (c) => {
  const sig = c.req.header('stripe-signature')
  const body = await c.req.text()

  if (!sig || !c.env.STRIPE_WEBHOOK_SECRET) {
    return c.json({ error: 'Missing signature or config' }, 400)
  }

  const stripe = new Stripe(c.env.STRIPE_SECRET_KEY, { apiVersion: '2025-01-27.acacia' as any })

  let event: Stripe.Event

  try {
    event = await stripe.webhooks.constructEventAsync(
      body,
      sig,
      c.env.STRIPE_WEBHOOK_SECRET
    )
  } catch (err: any) {
    console.error(`Webhook Signature Verification Failed: ${err.message}`)
    return c.json({ error: `Webhook Error: ${err.message}` }, 400)
  }

  // Handle the event
  switch (event.type) {
    case 'checkout.session.completed':
      const session = event.data.object as Stripe.Checkout.Session
      const userId = session.client_reference_id
      
      if (userId) {
        console.log(`Granting premium to user: ${userId}`)
        await c.env.DB.prepare(
          'UPDATE users SET is_premium = 1 WHERE id = ?'
        ).bind(userId).run()
      }
      break;
    default:
      console.log(`Unhandled event type ${event.type}`)
  }

  return c.json({ received: true })
})

// 11. Presigned Upload URL
app.post('/api/upload/presign', async (c) => {
  try {
    const { filename, contentType } = await c.req.json()
    if (!filename) return c.json({ error: 'Filename is required' }, 400)

    const S3 = new S3Client({
      region: 'auto',
      endpoint: `https://${c.env.ACCOUNT_ID}.r2.cloudflarestorage.com`,
      credentials: {
        accessKeyId: c.env.R2_ACCESS_KEY_ID,
        secretAccessKey: c.env.R2_SECRET_ACCESS_KEY,
      },
    })

    const key = `uploads/${crypto.randomUUID()}-${filename}`
    const command = new PutObjectCommand({
      Bucket: 'espanol-pro-content',
      Key: key,
      ContentType: contentType || 'audio/mpeg',
    })

    const uploadUrl = await getSignedUrl(S3, command, { expiresIn: 3600 })

    return c.json({ uploadUrl, key })
  } catch (e) {
    console.error('Presign error:', e)
    return c.json({ error: 'Failed to generate upload URL' }, 500)
  }
})

// 1. Get all courses
app.get('/api/courses', async (c) => {
  const user = c.get('user') as any
  const userId = user?.sub || c.req.query('userId') || 'test_user_1'
  
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

// 2. Get course details (Full structure)
app.get('/api/courses/:id', async (c) => {
  const courseId = c.req.param('id')
  const user = c.get('user') as any
  const userId = user?.sub || c.req.query('userId') || 'test_user_1'

  try {
    // 1. Get Course
    const course = await c.env.DB.prepare('SELECT * FROM courses WHERE id = ?').bind(courseId).first()
    
    if (!course) return c.json({ error: 'Course not found' }, 404)

    // 2. Get Units
    const { results: units } = await c.env.DB.prepare(
      'SELECT * FROM units WHERE course_id = ? ORDER BY order_index'
    ).bind(courseId).all()

    // 3. Get Lessons for these units
    const { results: lessons } = await c.env.DB.prepare(`
      SELECT l.* 
      FROM lessons l
      JOIN units u ON l.unit_id = u.id
      WHERE u.course_id = ?
      ORDER BY l.order_index
    `).bind(courseId).all()

    // Assemble response
    const unitsWithLessons = units.map((unit: any) => ({
      ...unit,
      lessons: lessons.filter((l: any) => l.unit_id === unit.id)
    }))

    return c.json({
      ...course,
      units: unitsWithLessons
    })
  } catch (e: any) {
    console.error(e)
    return c.json({ error: e.message }, 500)
  }
})

// 6. Auth (Login / Exchange Token)
app.post('/api/auth/login', async (c) => {
  try {
    let email: string;
    let userId: string;
    let displayName: string;

    const user = c.get('user') as any
    
    if (user) {
      // Trusted data from Firebase Token
      email = user.email;
      userId = user.sub;
      displayName = user.name || email.split('@')[0];
    } else {
      // Fallback to untrusted body (Dev mode or Legacy)
      const body = await c.req.json();
      email = body.email;
      if (!email) return c.json({ error: 'Email is required' }, 400);
      
      const existingUser = await c.env.DB.prepare('SELECT * FROM users WHERE email = ?').bind(email).first();
      if (existingUser) {
        userId = existingUser.id as string;
        displayName = existingUser.display_name as string;
      } else {
        userId = crypto.randomUUID();
        displayName = email.split('@')[0];
      }
    }

    // Check if user exists (Upsert logic)
    const existingUser = await c.env.DB.prepare(
      'SELECT * FROM users WHERE id = ?'
    ).bind(userId).first()

    if (existingUser) {
      // Update last login
      await c.env.DB.prepare(
        'UPDATE users SET last_login = ? WHERE id = ?'
      ).bind(Math.floor(Date.now() / 1000), userId).run()
      return c.json(existingUser)
    } else {
      // Create new user
      await c.env.DB.prepare(
        'INSERT INTO users (id, email, display_name, last_login) VALUES (?, ?, ?, ?)'
      ).bind(userId, email, displayName, Math.floor(Date.now() / 1000)).run()
      
      return c.json({ id: userId, email, display_name: displayName })
    }
  } catch (e) {
    console.error(e)
    return c.json({ error: 'Login failed' }, 500)
  }
})

// 7. AI Speech Evaluation
app.post('/api/ai/evaluate-speech', async (c) => {
  try {
    const contentType = c.req.header('content-type') || ''
    let audioBuffer: ArrayBuffer | undefined
    let referenceText = ''

    if (contentType.includes('application/json')) {
      const body = await c.req.json()
      referenceText = body['referenceText'] as string
      const fileKey = body['fileKey'] as string

      if (fileKey) {
        const object = await c.env.BUCKET.get(fileKey)
        if (!object) {
          return c.json({ error: 'Audio file not found in storage' }, 404)
        }
        audioBuffer = await object.arrayBuffer()
      }
    } else if (contentType.includes('multipart/form-data')) {
      const body = await c.req.parseBody()
      const audioFile = body['audio']
      referenceText = body['referenceText'] as string
      const userId = body['userId'] as string // Parsed for spec compliance/logging

      if (audioFile && audioFile instanceof File) {
        audioBuffer = await audioFile.arrayBuffer()
      }
    }

    if (!audioBuffer) {
      return c.json({ error: 'Audio input is required (file or fileKey)' }, 400)
    }

    if (!referenceText) {
      return c.json({ error: 'Reference text is required' }, 400)
    }

    // Run Whisper on Workers AI
    // @ts-ignore
    const aiResponse = await c.env.AI.run('@cf/openai/whisper', {
      audio: [...new Uint8Array(audioBuffer)]
    })

    const transcription = aiResponse.text || ''
    
    const score = calculateSimilarity(referenceText, transcription);
    const feedback = analyzePronunciation(referenceText, transcription);

    return c.json({
      score: score,
      transcription: transcription,
      is_match: score > 80,
      feedback: feedback
    })

  } catch (e) {
    console.error(e)
    return c.json({ error: 'AI evaluation failed' }, 500)
  }
})

// 8. AI Chat (Roleplay with History)
app.post('/api/ai/chat', async (c) => {
  try {
    const { message, conversationId: reqConvId, reset } = await c.req.json()
    const user = c.get('user') as any
    // Fallback ID for testing/unauthed if needed, but prefer auth
    const userId = user?.sub || (await c.req.json())['userId'] 

    if (!message) {
      return c.json({ error: 'Message is required' }, 400)
    }

    if (!userId) {
      return c.json({ error: 'User ID is required' }, 400)
    }

    let conversationId = reqConvId || crypto.randomUUID()
    
    // 1. Reset if requested
    if (reset) {
      await c.env.DB.prepare('DELETE FROM chat_history WHERE conversation_id = ?').bind(conversationId).run()
    }

    // 2. Retrieve History (Last 10 messages)
    const { results: history } = await c.env.DB.prepare(`
      SELECT role, content 
      FROM chat_history 
      WHERE conversation_id = ? 
      ORDER BY timestamp ASC 
      LIMIT 10
    `).bind(conversationId).all()

    const messages = history.map((h: any) => ({ role: h.role, content: h.content }))

    // 3. System Prompt Construction
    const systemPrompt = `You are Carlos, a friendly Spanish tutor from Mexico. 
    You are roleplaying a scenario. Keep responses concise (under 50 words) and suitable for A2 level learners. 
    IMPORTANT: If the user makes a grammatical error, reply naturally first, then append a correction at the very end in this specific format: [CORRECTION: <Spanish correction> - <English explanation>].`

    const context = [
      { role: 'system', content: systemPrompt },
      ...messages,
      { role: 'user', content: message }
    ]

    // 4. Inference
    // @ts-ignore
    const aiResponse = await c.env.AI.run('@cf/meta/llama-3-8b-instruct', {
      messages: context
    })

    const responseText = aiResponse.response

    // 5. Persistence
    // Save User Message
    await c.env.DB.prepare(`
      INSERT INTO chat_history (conversation_id, user_id, role, content, timestamp) 
      VALUES (?, ?, ?, ?, ?)
    `).bind(conversationId, userId, 'user', message, Math.floor(Date.now() / 1000)).run()

    // Save AI Response
    await c.env.DB.prepare(`
      INSERT INTO chat_history (conversation_id, user_id, role, content, timestamp) 
      VALUES (?, ?, ?, ?, ?)
    `).bind(conversationId, userId, 'assistant', responseText, Math.floor(Date.now() / 1000)).run()

    return c.json({ 
      response: responseText, 
      conversationId: conversationId 
    })

  } catch (e: any) {
    console.error(e)
    return c.json({ error: 'AI Chat failed: ' + e.message }, 500)
  }
})

// 14. Record Learning Attempt (BKT) + Gamification
app.post('/api/learning/attempt', async (c) => {
  try {
    const { userId: bodyUserId, lessonId, isCorrect } = await c.req.json()
    const user = c.get('user') as any
    const userId = user?.sub || bodyUserId

    if (!userId || !lessonId || isCorrect === undefined) {
      return c.json({ error: 'Missing required fields' }, 400)
    }

    // Update Streak
    await updateStreak(c.env.DB, userId);

    // Award XP
    if (isCorrect) {
      await addXP(c.env.DB, userId, 10, 'LESSON_ATTEMPT', lessonId);
    } else {
      await addXP(c.env.DB, userId, 2, 'LESSON_ATTEMPT_FAIL', lessonId); // Consolation XP
    }

    // 1. Find KC for this lesson
    const lesson = await c.env.DB.prepare(
      'SELECT kc_id FROM lessons WHERE id = ?'
    ).bind(lessonId).first()

    if (!lesson || !lesson.kc_id) {
      return c.json({ skipped: true, reason: 'No KC linked' })
    }

    const kcId = lesson.kc_id as string

    // 2. Get current mastery state
    const state = await c.env.DB.prepare(
      'SELECT p_know FROM user_kc_state WHERE user_id = ? AND kc_id = ?'
    ).bind(userId, kcId).first()

    const p_prev = (state?.p_know as number) || 0.01 // Default prior

    // 3. Calculate new mastery
    const p_new = calculateNewMastery(p_prev, isCorrect)

    // 4. Update State
    await c.env.DB.prepare(`
      INSERT INTO user_kc_state (user_id, kc_id, p_know, last_practice_time)
      VALUES (?, ?, ?, ?)
      ON CONFLICT(user_id, kc_id) DO UPDATE SET
        p_know = excluded.p_know,
        last_practice_time = excluded.last_practice_time
    `).bind(userId, kcId, p_new, Math.floor(Date.now() / 1000)).run()

    // 5. Log interaction
    await c.env.DB.prepare(`
      INSERT INTO study_logs (user_id, lesson_id, interaction_type, is_correct)
      VALUES (?, ?, ?, ?)
    `).bind(userId, lessonId, 'ATTEMPT', isCorrect ? 1 : 0).run()

    return c.json({ 
      kcId,
      previous_mastery: p_prev,
      new_mastery: p_new,
      delta: p_new - p_prev
    })

  } catch (e: any) {
    console.error('BKT Error:', e)
    return c.json({ error: e.message }, 500)
  }
})

// 15. Record Progress (General Completion) + Gamification
app.post('/api/progress', async (c) => {
  try {
    const { userId: bodyUserId, courseId, lessonId, isCorrect, interactionType } = await c.req.json()
    const user = c.get('user') as any
    const userId = user?.sub || bodyUserId

    if (!userId || !courseId || !lessonId) {
      return c.json({ error: 'Missing required fields' }, 400)
    }

    // Update Streak
    await updateStreak(c.env.DB, userId);

    // Award XP for Completion
    await addXP(c.env.DB, userId, 50, 'LESSON_COMPLETE', lessonId);

    // 1. Log interaction
    await c.env.DB.prepare(`
      INSERT INTO study_logs (user_id, lesson_id, interaction_type, is_correct)
      VALUES (?, ?, ?, ?)
    `).bind(userId, lessonId, interactionType || 'COMPLETION', isCorrect ? 1 : 0).run()

    // 2. Update Course Progress
    await c.env.DB.prepare(`
      INSERT INTO user_course_progress (user_id, course_id, completed_lessons_count, last_updated)
      VALUES (?, ?, 1, ?)
      ON CONFLICT(user_id, course_id) DO UPDATE SET
        completed_lessons_count = completed_lessons_count + 1,
        last_updated = excluded.last_updated
    `).bind(userId, courseId, Math.floor(Date.now() / 1000)).run()

    return c.json({ success: true })
  } catch (e: any) {
    console.error('Progress Error:', e)
    return c.json({ error: e.message }, 500)
  }
})

// 16. Leaderboard API
app.get('/api/leaderboard', async (c) => {
  try {
    // Top 10 Global by XP
    const { results: leaderboard } = await c.env.DB.prepare(`
      SELECT id as userId, display_name as displayName, total_xp as xp, current_streak as streak
      FROM users
      ORDER BY total_xp DESC
      LIMIT 10
    `).all();

    const user = c.get('user') as any
    let userRank = null;
    
    if (user) {
      const userId = user.sub;
      // Calculate rank
      const rankResult = await c.env.DB.prepare(`
        SELECT COUNT(*) + 1 as rank FROM users WHERE total_xp > (SELECT total_xp FROM users WHERE id = ?)
      `).bind(userId).first();
      
      const userData = await c.env.DB.prepare('SELECT total_xp, current_streak FROM users WHERE id = ?').bind(userId).first();
      
      if (userData) {
        userRank = {
          rank: rankResult?.rank || 0,
          xp: userData.total_xp,
          streak: userData.current_streak
        };
      }
    }

    return c.json({
      leaderboard,
      userRank
    })
  } catch (e: any) {
    return c.json({ error: e.message }, 500)
  }
})

// 9. Serve Audio from R2
app.get('/audio/:filename', async (c) => {
  const filename = c.req.param('filename')
  const key = filename
  const object = await c.env.BUCKET.get(key)

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

// 10. Get User Skills (BKT Mastery)
app.get('/api/users/:userId/skills', async (c) => {
  const userId = c.req.param('userId')
  try {
    const { results } = await c.env.DB.prepare(`
      SELECT 
        kc.name as skill_name,
        kc.description,
        COALESCE(uks.p_know, 0.01) as mastery_level,
        uks.last_practice_time
      FROM knowledge_components kc
      LEFT JOIN user_kc_state uks ON kc.id = uks.kc_id AND uks.user_id = ?
      ORDER BY mastery_level DESC
    `).bind(userId).all()
    
    return c.json(results)
  } catch (e) {
    return c.json({ error: 'Failed to fetch skills' }, 500)
  }
})

// 21. Analytics: Record Event

app.post('/api/analytics/event', async (c) => {

  try {

    const { eventName, properties, userId: bodyUserId } = await c.req.json()

    const user = c.get('user') as any

    const userId = user?.sub || bodyUserId



    if (!eventName) {

      return c.json({ error: 'Event Name is required' }, 400)

    }



    await c.env.DB.prepare(`

      INSERT INTO analytics_events (user_id, event_name, properties, timestamp)

      VALUES (?, ?, ?, ?)

    `).bind(userId, eventName, JSON.stringify(properties), Math.floor(Date.now() / 1000)).run()



    return c.json({ success: true })

  } catch (e: any) {

    return c.json({ error: e.message }, 500)

  }

})



// 22. Admin: Get Analytics Stats

app.get('/api/admin/analytics/stats', async (c) => {

  try {

    // Simple aggregation: Total events by type

    const { results } = await c.env.DB.prepare(`

      SELECT event_name, COUNT(*) as count 

      FROM analytics_events 

      GROUP BY event_name

      ORDER BY count DESC

    `).all()



    return c.json({ stats: results })

  } catch (e: any) {

    return c.json({ error: e.message }, 500)

  }

})



// 23. AI: Generate Lesson
app.post('/api/ai/generate-lesson', async (c) => {
  try {
    // Auth check if needed (or make public for demo)
    // await verifyAuth(c, async () => { ... }) 
    
    const { topic, level } = await c.req.json()
    if (!topic || !level) return c.json({ error: 'Missing topic or level' }, 400)

    const prompt = `Generate a Spanish lesson for level ${level} about "${topic}".
    Return ONLY a JSON object with this structure:
    {
      "title": "Lesson Title",
      "content_type": "DIALOGUE",
      "content_json": "JSON string of dialogue array like [{'speaker':'A','es':'...','translation':{'en':'...'}}]"
    }
    Do not add markdown formatting.`

    // @ts-ignore
    const aiResponse = await c.env.AI.run('@cf/meta/llama-3-8b-instruct', {
      messages: [{ role: 'user', content: prompt }]
    })

    const raw = aiResponse.response as string;
    // Attempt to parse AI response to ensure it's valid JSON
    // AI might wrap in ```json ... ```
    let jsonStr = raw.replace(/```json/g, '').replace(/```/g, '').trim();
    
    // Validate by parsing
    const lessonData = JSON.parse(jsonStr);

    return c.json(lessonData)
  } catch (e: any) {
    return c.json({ error: e.message }, 500)
  }
})

export default app
