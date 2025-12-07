import { textToIPA } from './g2p';

export function levenshteinDistance(a: string, b: string): number {
  if (a.length === 0) return b.length;
  if (b.length === 0) return a.length;

  const matrix = [];

  // increment along the first column of each row
  for (let i = 0; i <= b.length; i++) {
    matrix[i] = [i];
  }

  // increment each column in the first row
  for (let j = 0; j <= a.length; j++) {
    matrix[0][j] = j;
  }

  // Fill in the rest of the matrix
  for (let i = 1; i <= b.length; i++) {
    for (let j = 1; j <= a.length; j++) {
      if (b.charAt(i - 1) == a.charAt(j - 1)) {
        matrix[i][j] = matrix[i - 1][j - 1];
      } else {
        matrix[i][j] = Math.min(
          matrix[i - 1][j - 1] + 1, // substitution
          Math.min(
            matrix[i][j - 1] + 1, // insertion
            matrix[i - 1][j] + 1 // deletion
          )
        );
      }
    }
  }

  return matrix[b.length][a.length];
}

export function calculateSimilarity(target: string, actual: string): number {
  const normalize = (s: string) => s.toLowerCase().replace(/[^\w\s]/g, '').trim();
  
  const s1 = normalize(target);
  const s2 = normalize(actual);

  if (!s1 && !s2) return 100;
  if (!s1 || !s2) return 0;

  const distance = levenshteinDistance(s1, s2);
  const maxLength = Math.max(s1.length, s2.length);
  
  const similarity = (1 - distance / maxLength) * 100;
  return Math.max(0, Math.round(similarity));
}

export function analyzePronunciation(target: string, actual: string): string[] {
  const feedback: string[] = [];
  const ipaTarget = textToIPA(target);
  const ipaActual = textToIPA(actual);

  // Check for Trilled R issues
  if (ipaTarget.includes('r') && !ipaActual.includes('r')) {
    feedback.push("Practice your trilled 'rr' (erre) sound. It should be strong and rolling.");
  }

  // Check for J/G (Kh) sound
  if (ipaTarget.includes('x') && !ipaActual.includes('x')) {
    feedback.push("Watch the 'j' or 'g' sound. It comes from the back of the throat.");
  }

  // Check for missing syllables/speed
  if (Math.abs(ipaTarget.length - ipaActual.length) > ipaTarget.length * 0.3) {
    feedback.push("Try to match the speed and rhythm. You might be skipping or adding syllables.");
  }

  // Fallback if score is low but no specific error found
  if (feedback.length === 0 && calculateSimilarity(target, actual) < 80) {
    feedback.push("Listen closely to the vowels. Spanish vowels are short and clear.");
  }

  return feedback;
}
