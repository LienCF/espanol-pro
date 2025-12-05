export interface BKTConfig {
  p_learn: number; // P(T) - Probability of transition from unlearned to learned
  p_guess: number; // P(G) - Probability of guessing correctly if unlearned
  p_slip: number;  // P(S) - Probability of slipping (incorrect) if learned
}

const DEFAULT_CONFIG: BKTConfig = {
  p_learn: 0.15,
  p_guess: 0.20,
  p_slip: 0.10
};

/**
 * Updates the probability of knowing a skill based on a new observation.
 * 
 * @param p_know Prior probability P(L_{t-1})
 * @param is_correct Whether the user answered correctly
 * @param config BKT parameters (optional)
 * @returns New probability P(L_t)
 */
export function calculateNewMastery(
  p_know: number, 
  is_correct: boolean, 
  config: BKTConfig = DEFAULT_CONFIG
): number {
  let p_posterior = 0;

  if (is_correct) {
    // P(L|Obs) = (P(L) * (1-P(S))) / (P(L)*(1-P(S)) + (1-P(L))*P(G))
    const num = p_know * (1 - config.p_slip);
    const den = p_know * (1 - config.p_slip) + (1 - p_know) * config.p_guess;
    p_posterior = num / den;
  } else {
    // P(L|Obs) = (P(L) * P(S)) / (P(L)*P(S) + (1-P(L))*(1-P(G)))
    const num = p_know * config.p_slip;
    const den = p_know * config.p_slip + (1 - p_know) * (1 - config.p_guess);
    p_posterior = num / den;
  }

  // P(L_t) = P(L|Obs) + (1 - P(L|Obs)) * P(T)
  const p_next = p_posterior + (1 - p_posterior) * config.p_learn;

  // Clamp to avoid floating point drift extremes
  return Math.min(0.9999, Math.max(0.0001, p_next));
}
