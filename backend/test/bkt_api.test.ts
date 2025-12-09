import { describe, it, expect, vi } from 'vitest'
import app from '../src/index'

// Mock D1
const mockD1 = {
  prepare: vi.fn(),
  batch: vi.fn(),
}

const mockEnv = {
  DB: mockD1,
}

describe('BKT Integration API', () => {
  it('should update mastery when KC exists', async () => {
    const userId = 'test_user'
    const lessonId = 'lesson_123'
    const kcId = 'kc_subjunctive'
    
    // 1. Lookup Lesson -> KC
    const lessonStmt = {
      bind: vi.fn().mockReturnThis(),
      first: vi.fn().mockResolvedValue({ kc_id: kcId })
    }
    
    // 2. Get Current State
    const stateStmt = {
      bind: vi.fn().mockReturnThis(),
      first: vi.fn().mockResolvedValue({ p_know: 0.5 })
    }
    
    // 3. Update State (Insert/Upsert)
    const updateStmt = {
      bind: vi.fn().mockReturnThis(),
      run: vi.fn().mockResolvedValue({ success: true })
    }
    
    // 4. Log Attempt
    const logStmt = {
      bind: vi.fn().mockReturnThis(),
      run: vi.fn().mockResolvedValue({ success: true })
    }

    mockD1.prepare
      .mockReturnValueOnce(lessonStmt)
      .mockReturnValueOnce(stateStmt)
      .mockReturnValueOnce(updateStmt)
      .mockReturnValueOnce(logStmt)

    const req = new Request('http://localhost/api/learning/attempt', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ userId, lessonId, isCorrect: true })
    })

    const res = await app.request(req, undefined, mockEnv as any)
    const data = await res.json()

    expect(res.status).toBe(200)
    expect(data.kcId).toBe(kcId)
    expect(data.previous_mastery).toBe(0.5)
    expect(data.new_mastery).toBeGreaterThan(0.5)
    
    expect(mockD1.prepare).toHaveBeenCalledTimes(4)
  })

  it('should skip BKT if lesson has no KC', async () => {
    // 1. Lookup Lesson -> No KC
    const lessonStmt = {
      bind: vi.fn().mockReturnThis(),
      first: vi.fn().mockResolvedValue({ kc_id: null })
    }

    mockD1.prepare.mockReturnValueOnce(lessonStmt)

    const req = new Request('http://localhost/api/learning/attempt', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ userId: 'user', lessonId: 'lesson_no_kc', isCorrect: true })
    })

    const res = await app.request(req, undefined, mockEnv as any)
    const data = await res.json()

    expect(res.status).toBe(200)
    expect(data.skipped).toBe(true)
  })
})
