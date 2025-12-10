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
  
  // Helper to create flexible statements
  const makeStmt = (returnData: any = {}) => {
    const stmt: any = {}
    stmt.bind = vi.fn().mockReturnValue(stmt)
    stmt.first = vi.fn().mockResolvedValue(returnData.first || null) // Default null if not specified
    stmt.all = vi.fn().mockResolvedValue(returnData.all || { results: [] })
    stmt.run = vi.fn().mockResolvedValue({ success: true })
    return stmt
  }

  it('should update mastery when KC exists', async () => {
    const userId = 'test_user'
    const lessonId = 'lesson_123'
    const kcId = 'kc_subjunctive'
    
    // We mock prepare to always return a working statement.
    // To handle specific return values for specific queries, we can use mockImplementation
    // or just mockReturnValue with a smart chain if order is strict.
    // Since updateStreak adds many calls, let's use mockImplementation to check query string
    // or just return a generic "found" object for SELECTs to keep flow going.
    
    mockD1.prepare.mockImplementation((query: string) => {
      if (query.includes('SELECT kc_id FROM lessons')) {
        return makeStmt({ first: { kc_id: kcId } })
      }
      if (query.includes('SELECT p_know FROM user_kc_state')) {
        return makeStmt({ first: { p_know: 0.5 } })
      }
      // Gamification mocks (Streaks, XP) - Default return success/empty
      return makeStmt({ first: null }) 
    })

    const req = new Request('http://localhost/api/learning/attempt', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ userId, lessonId, isCorrect: true })
    })

    const res = await app.request(req, undefined, mockEnv as any)
    const data = await res.json()

    if (res.status !== 200) {
      console.error(data)
    }

    expect(res.status).toBe(200)
    expect(data.kcId).toBe(kcId)
    expect(data.previous_mastery).toBe(0.5)
    expect(data.new_mastery).toBeGreaterThan(0.5)
  })

  it('should skip BKT if lesson has no KC', async () => {
    mockD1.prepare.mockImplementation((query: string) => {
      if (query.includes('SELECT kc_id FROM lessons')) {
        return makeStmt({ first: { kc_id: null } }) // No KC
      }
      return makeStmt({ first: null })
    })

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
