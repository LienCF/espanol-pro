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
// Protect API routes except auth, webhooks, and public assets
app.use('/api/*', async (c, next) => {
  const path = c.req.path
  if (path.startsWith('/api/auth') || path.startsWith('/api/payments/webhook')) {
    await next()
  } else {
    await verifyAuth(c, next)
  }
})

app.get('/', (c) => {
  return c.text('Hola, Español Pro API!')
})

// ... existing endpoints ...

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

// ... rest of the app ...

// 11. Presigned Upload URL
app.post('/api/upload/presign', async (c) => {
  // ... existing code ...
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

// ... existing code ...

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
      // Legacy/Dev: Create a deterministic UUID based on email? Or find existing?
      // For legacy, we might not have a stable ID if we just gen random.
      // But existing code queried by email.
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

// ... remaining code ...

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

// 8. AI Chat (Llama 3 Roleplay)
app.post('/api/ai/chat', async (c) => {
  try {
    const { messages } = await c.req.json()
    
    if (!messages || !Array.isArray(messages)) {
      return c.json({ error: 'Messages array is required' }, 400)
    }

    // Inject Grammar Tutor Instruction
    const grammarInstruction = " IMPORTANT: If the user makes a grammatical error, reply naturally first, then append a correction at the very end in this specific format: [CORRECTION: <Spanish correction> - <English explanation>]."
    
    const processedMessages = messages.map(msg => {
      if (msg.role === 'system') {
        return { ...msg, content: msg.content + grammarInstruction }
      }
      return msg
    })

    // If no system message was found, add one (optional, but good practice)
    if (!processedMessages.some(m => m.role === 'system')) {
      processedMessages.unshift({
        role: 'system',
        content: "You are a helpful Spanish tutor." + grammarInstruction
      })
    }

    // @ts-ignore
    const aiResponse = await c.env.AI.run('@cf/meta/llama-3-8b-instruct', {
      messages: processedMessages
    })

    return c.json({ response: aiResponse.response })
  } catch (e) {
    console.error(e)
    return c.json({ error: 'AI Chat failed' }, 500)
  }
})

// 14. Record Learning Attempt (BKT)
app.post('/api/learning/attempt', async (c) => {
  try {
    const { userId: bodyUserId, lessonId, isCorrect } = await c.req.json()
    const user = c.get('user') as any
    const userId = user?.sub || bodyUserId

    if (!userId || !lessonId || isCorrect === undefined) {
      return c.json({ error: 'Missing required fields' }, 400)
    }

    // 1. Find KC for this lesson
    const lesson = await c.env.DB.prepare(
      'SELECT kc_id FROM lessons WHERE id = ?'
    ).bind(lessonId).first()

    if (!lesson || !lesson.kc_id) {
      // Lesson has no associated knowledge component, skip BKT
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

    // 5. Log interaction (optional but good for analytics)
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

export default app
