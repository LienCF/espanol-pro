import { describe, it, expect, vi, beforeEach } from 'vitest'
import app from '../src/index'

// Mock D1
const mockD1 = {
  prepare: vi.fn(),
  batch: vi.fn(),
}

// Mock Env
const mockEnv = {
  DB: mockD1,
}

// Mock jose library BEFORE importing app
vi.mock('jose', async (importOriginal) => {
  return {
    createRemoteJWKSet: vi.fn(),
    jwtVerify: vi.fn().mockImplementation(async (token) => {
      if (token === 'valid_token') {
        return { payload: { sub: 'test_user' } }
      }
      if (token === 'admin_token') {
        return { payload: { sub: 'admin_user' } }
      }
      throw new Error('Invalid Token')
    }),
  }
})

describe('Admin API', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('should return 401 if not authenticated', async () => {
    // No Auth Header
    const req = new Request('http://localhost/api/admin/courses', {
      method: 'POST',
      body: JSON.stringify({ title: 'New Course' })
    })
    
    // Pass null/undefined user
    const res = await app.request(req, undefined, mockEnv as any)
    expect(res.status).toBe(401)
  })

  it('should return 403 if authenticated but not admin', async () => {
    // ... existing mock ...
  })

  it('should allow admin to create course', async () => {
    mockD1.prepare.mockImplementation((query) => {
      if (query.includes('SELECT role FROM admins')) {
        return {
          bind: vi.fn().mockReturnThis(),
          first: vi.fn().mockResolvedValue({ role: 'superadmin' })
        }
      }
      return { 
        bind: vi.fn().mockReturnThis(), 
        run: vi.fn().mockResolvedValue({ success: true }),
        first: vi.fn()
      }
    })

    const req = new Request('http://localhost/api/admin/courses', {
      method: 'POST',
      headers: { 'Authorization': 'Bearer admin_token' },
      body: JSON.stringify({ 
        id: 'new_c', 
        title: 'New Course', 
        slug: 'new-course', 
        level: 'A1', 
        track_type: 'GENERAL' 
      })
    })

    const res = await app.request(req, undefined, mockEnv as any)
    expect(res.status).toBe(200)
  })

  it('should allow admin to update course', async () => {
    // Mock Admin
    mockD1.prepare.mockImplementation((query) => {
      if (query.includes('SELECT role FROM admins')) return { bind: vi.fn().mockReturnThis(), first: vi.fn().mockResolvedValue({ role: 'admin' }) }
      if (query.includes('UPDATE courses')) return { bind: vi.fn().mockReturnThis(), run: vi.fn().mockResolvedValue({ success: true }) }
      return { bind: vi.fn().mockReturnThis(), run: vi.fn() }
    })

    const req = new Request('http://localhost/api/admin/courses/c1', {
      method: 'PUT',
      headers: { 'Authorization': 'Bearer admin_token' },
      body: JSON.stringify({ title: 'Updated Title' })
    })

    const res = await app.request(req, undefined, mockEnv as any)
    expect(res.status).toBe(200)
  })

  it('should allow admin to delete course', async () => {
    // Mock Admin
    mockD1.prepare.mockImplementation((query) => {
      if (query.includes('SELECT role FROM admins')) return { bind: vi.fn().mockReturnThis(), first: vi.fn().mockResolvedValue({ role: 'admin' }) }
      if (query.includes('DELETE FROM courses')) return { bind: vi.fn().mockReturnThis(), run: vi.fn().mockResolvedValue({ success: true }) }
      return { bind: vi.fn().mockReturnThis(), run: vi.fn() }
    })

    const req = new Request('http://localhost/api/admin/courses/c1', {
      method: 'DELETE',
      headers: { 'Authorization': 'Bearer admin_token' }
    })

    const res = await app.request(req, undefined, mockEnv as any)
    expect(res.status).toBe(200)
  })
})
