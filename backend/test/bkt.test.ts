import { describe, it, expect } from 'vitest'
import { calculateNewMastery } from '../src/bkt'

describe('BKT Algorithm', () => {
  it('should increase mastery on correct answer', () => {
    const pKnow = 0.5
    const newP = calculateNewMastery(pKnow, true)
    expect(newP).toBeGreaterThan(pKnow)
  })

  it('should decrease mastery on incorrect answer', () => {
    const pKnow = 0.5
    const newP = calculateNewMastery(pKnow, false)
    expect(newP).toBeLessThan(pKnow)
  })

  it('should respect custom config', () => {
    const pKnow = 0.5
    // If guessing is 100% likely, a correct answer shouldn't increase mastery much (if at all) relative to standard
    const strictConfig = { p_learn: 0.1, p_guess: 0.9, p_slip: 0.1 }
    const result = calculateNewMastery(pKnow, true, strictConfig)
    
    // Standard calculation for comparison
    // correct P(L|Obs) = 0.5*0.9 / (0.5*0.9 + 0.5*0.9) = 0.5
    // next = 0.5 + 0.5*0.1 = 0.55
    
    expect(result).toBeCloseTo(0.55, 2)
  })

  it('should assume minimal knowledge for new skills (boundary check)', () => {
    const pKnow = 0.01 // Very low initial knowledge
    const newP = calculateNewMastery(pKnow, true)
    // Should increase, but not jump to 1.0
    expect(newP).toBeGreaterThan(pKnow)
    expect(newP).toBeLessThan(0.5) // One success shouldn't make you a master
  })

  it('should not exceed 1.0 or go below 0.0', () => {
    expect(calculateNewMastery(0.99, true)).toBeLessThan(1.0)
    expect(calculateNewMastery(0.01, false)).toBeGreaterThan(0.0)
  })
})
