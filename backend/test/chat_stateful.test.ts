import { describe, it, expect, vi, beforeEach } from 'vitest'
import app from '../src/index'

// Mock D1 Database
const mockD1 = {
  prepare: vi.fn(),
  batch: vi.fn(),
}

// Mock AI
const mockAI = {
  run: vi.fn(),
}

// Mock Bindings
const mockEnv = {
  DB: mockD1,
  AI: mockAI,
  // ... other bindings not needed for these tests
}

describe('AI Roleplay Chat API (Stateful)', () => {
  
  beforeEach(() => {
    vi.clearAllMocks()
    
    // Default Mock: Auth fails (return null) if not overridden, 
    // or we just mock successful auth globally for simplicity in this suite
    // Let's use mockImplementation to handle different calls based on query if needed,
    // or just rely on 'mockImplementationOnce' sequence which is brittle but works if flow is deterministic.
  })

  it('should fetch history, infer, and save new messages', async () => {
    // 1. Mock Conversation History Retrieval
    const history = [
      { role: 'system', content: 'System Prompt' },
      { role: 'user', content: 'Hola' },
      { role: 'assistant', content: 'Hola, ¿qué tal?' }
    ]
    
    // Universal Mock Stmt that can handle any call sequence
    // This reduces brittleness if middleware calls change order
    const makeStmt = (name: string, returnData: any = {}) => {
      const stmt: any = {}
      stmt.bind = vi.fn().mockReturnValue(stmt)
      stmt.first = vi.fn().mockResolvedValue(returnData.first || null)
      stmt.all = vi.fn().mockResolvedValue(returnData.all || { results: [] })
      stmt.run = vi.fn().mockResolvedValue({ success: true })
      return stmt
    }

    // NOTE: verifyAuth in soft mode (no header) does NOT call DB.
    // So we start directly with History Fetch.
    
    mockD1.prepare
      //.mockReturnValueOnce(makeStmt('Auth', { first: {sub: 'test_user', id: 'test_user'} })) // verifyAuth skipped
      .mockReturnValueOnce(makeStmt('History', { all: { results: history } })) // select history
      .mockReturnValueOnce(makeStmt('InsertUser')) // insert user
      .mockReturnValueOnce(makeStmt('InsertAI')) // insert ai

    // 2. Mock AI Response
    mockAI.run.mockResolvedValue({ response: 'Muy bien, gracias.' })

    const req = new Request('http://localhost/api/ai/chat', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ 
        message: 'Estoy bien',
        conversationId: 'test-conv-123',
        userId: 'test_user'
      })
    })

    const res = await app.request(req, undefined, mockEnv as any)
    const data = await res.json()

    if (res.status !== 200) {
      console.error('Error Response:', data)
    }

    expect(res.status).toBe(200)
    expect(data.response).toBe('Muy bien, gracias.')
    expect(data.conversationId).toBe('test-conv-123')
    
    expect(mockAI.run).toHaveBeenCalledWith('@cf/meta/llama-3-8b-instruct', expect.objectContaining({
      messages: expect.arrayContaining([
        expect.objectContaining({ role: 'system', content: expect.stringContaining('You are Carlos') }),
        ...history.filter(h => h.role !== 'system'), // We might filter system out or it might be duplicated, but let's check basic flow
        expect.objectContaining({ role: 'user', content: 'Estoy bien' })
      ])
    }))
  })

  it('should start new conversation if conversationId is new/missing', async () => {
     const makeStmt = (name: string, returnData: any = {}) => {
      const stmt: any = {}
      stmt.bind = vi.fn().mockReturnValue(stmt)
      stmt.first = vi.fn().mockResolvedValue(returnData.first || null)
      stmt.all = vi.fn().mockResolvedValue(returnData.all || { results: [] })
      stmt.run = vi.fn().mockResolvedValue({ success: true })
      return stmt
    }

    mockD1.prepare
      // .mockReturnValueOnce(makeStmt('Auth', { first: {sub: 'test_user', id: 'test_user'} }))
      .mockReturnValueOnce(makeStmt('EmptyHistory', { all: { results: [] } }))
      .mockReturnValueOnce(makeStmt('InsertUser'))
      .mockReturnValueOnce(makeStmt('InsertAI'))
    
    // Mock AI Response
    mockAI.run.mockResolvedValue({ response: 'Hola!' })

    const req = new Request('http://localhost/api/ai/chat', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ 
        message: 'Hola',
        userId: 'test_user'
        // No conversationId
      })
    })

    const res = await app.request(req, undefined, mockEnv as any)
    const data = await res.json()

    expect(data.conversationId).toBeDefined()
    expect(mockAI.run).toHaveBeenCalledWith('@cf/meta/llama-3-8b-instruct', expect.objectContaining({
      messages: expect.arrayContaining([
        { role: 'user', content: 'Hola' }
      ])
    }))
    // Should have added system prompt
    expect(mockAI.run.mock.calls[0][1].messages[0].role).toBe('system')
  })
})
