import { describe, it, expect, vi } from 'vitest'
import app from '../src/index'

describe('AI Speech Evaluation API', () => {
  it('should return 400 if reference text is missing', async () => {
    const req = new Request('http://localhost/api/ai/evaluate-speech', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ fileKey: 'audio.mp3' }) // Missing reference_text
    })
    
    const mockBucket = { 
      get: vi.fn().mockResolvedValue({ 
        arrayBuffer: async () => new ArrayBuffer(0) 
      }) 
    }

    const res = await app.request(req, undefined, { BUCKET: mockBucket })
    expect(res.status).toBe(400)
  })

  it('should transcribe and score correctly using Mocked AI & Bucket (JSON Mode)', async () => {
    // Mock AI
    const mockAI = {
      run: vi.fn().mockResolvedValue({ text: 'Hola mundo' })
    }

    // Mock R2 Bucket
    const mockBucket = {
      get: vi.fn().mockResolvedValue({
        arrayBuffer: async () => new ArrayBuffer(10) // Dummy audio data
      })
    }

    const req = new Request('http://localhost/api/ai/evaluate-speech', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ 
        fileKey: 'test/audio.mp3',
        referenceText: 'Hola mundo'
      })
    })

    const res = await app.request(req, undefined, { 
      AI: mockAI,
      BUCKET: mockBucket
    })
    
    const data = await res.json()
    
    expect(res.status).toBe(200)
    expect(mockBucket.get).toHaveBeenCalledWith('test/audio.mp3')
    expect(mockAI.run).toHaveBeenCalledWith('@cf/openai/whisper', expect.anything())
    
    expect(data.transcription).toBe('Hola mundo')
    expect(data.score).toBe(100)
    expect(data.is_match).toBe(true)
  })

  it('should handle multipart/form-data upload correctly', async () => {
    // Mock AI
    const mockAI = {
      run: vi.fn().mockResolvedValue({ text: 'Buenos días' })
    }

    const formData = new FormData();
    // Create a dummy blob for audio
    const audioBlob = new Blob(['fake audio content'], { type: 'audio/wav' });
    formData.append('audio', audioBlob, 'recording.wav');
    formData.append('referenceText', 'Buenos días');

    const req = new Request('http://localhost/api/ai/evaluate-speech', {
      method: 'POST',
      body: formData
    })

    // BUCKET is not needed for direct upload, but we pass empty object to satisfy types if needed
    const res = await app.request(req, undefined, { 
      AI: mockAI,
      BUCKET: {} 
    })
    
    const data = await res.json()
    
    expect(res.status).toBe(200)
    expect(mockAI.run).toHaveBeenCalledWith('@cf/openai/whisper', expect.anything())
    expect(data.transcription).toBe('Buenos días')
    expect(data.score).toBe(100)
  })

  it('should handle mismatch correctly', async () => {
    const mockAI = {
      run: vi.fn().mockResolvedValue({ text: 'Adios' })
    }
    const mockBucket = {
      get: vi.fn().mockResolvedValue({
        arrayBuffer: async () => new ArrayBuffer(10)
      })
    }

    const req = new Request('http://localhost/api/ai/evaluate-speech', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ 
        fileKey: 'test/audio.mp3',
        referenceText: 'Hola'
      })
    })

    const res = await app.request(req, undefined, { 
      AI: mockAI,
      BUCKET: mockBucket
    })
    
    const data = await res.json()
    expect(data.transcription).toBe('Adios')
    expect(data.score).toBeLessThan(50)
    expect(data.is_match).toBe(false)
  })
})

describe('AI Chat API', () => {
  it('should inject grammar instruction into system prompt', async () => {
    const mockAI = {
      run: vi.fn().mockResolvedValue({ response: 'Hola! [CORRECTION: Hola - Hello]' })
    }

    const messages = [
      { role: 'system', content: 'You are a Spanish tutor.' },
      { role: 'user', content: 'Hola' }
    ]

    const req = new Request('http://localhost/api/ai/chat', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ messages })
    })

    const res = await app.request(req, undefined, { AI: mockAI, BUCKET: {} })
    const data = await res.json()

    expect(res.status).toBe(200)
    expect(data.response).toBe('Hola! [CORRECTION: Hola - Hello]')

    // Verify AI was called with modified system prompt
    expect(mockAI.run).toHaveBeenCalledWith('@cf/meta/llama-3-8b-instruct', expect.objectContaining({
      messages: expect.arrayContaining([
        expect.objectContaining({
          role: 'system',
          content: expect.stringContaining('IMPORTANT: If the user makes a grammatical error')
        })
      ])
    }))
  })

  it('should add default system prompt if missing', async () => {
    const mockAI = {
      run: vi.fn().mockResolvedValue({ response: 'Hola' })
    }

    const messages = [
      { role: 'user', content: 'Hola' }
    ]

    const req = new Request('http://localhost/api/ai/chat', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ messages })
    })

    await app.request(req, undefined, { AI: mockAI, BUCKET: {} })

    // Verify AI was called with a system prompt added
    expect(mockAI.run).toHaveBeenCalledWith('@cf/meta/llama-3-8b-instruct', expect.objectContaining({
      messages: expect.arrayContaining([
        expect.objectContaining({
          role: 'system',
          content: expect.stringContaining('You are a helpful Spanish tutor.')
        })
      ])
    }))
  })
})