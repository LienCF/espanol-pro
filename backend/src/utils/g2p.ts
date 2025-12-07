/**
 * A lightweight Rule-based Spanish to IPA converter.
 * Spanish orthography is highly phonemic, making this feasible without ML.
 * 
 * Simplified IPA mapping for learning purposes (General/LatAm):
 * - ll -> j (or ʎ)
 * - ch -> tʃ
 * - rr -> r
 * - r (start/end) -> r
 * - r (medial) -> ɾ
 * - j / g(+e/i) -> x
 * - ñ -> ɲ
 * - c(+e/i) / z -> s (LatAm) or θ (Castilian). We'll default to s for broader appeal, or s/θ agnostic.
 */

export function textToIPA(text: string): string {
  let s = text.toLowerCase();

  // 1. Pre-processing cleanup
  s = s.replace(/[^\w\sáéíóúüñ]/g, ''); 

  // 2. Graph to Phoneme Rules (Order matters!)
  
  // Digraphs
  s = s.replace(/ch/g, 'tʃ');
  s = s.replace(/ll/g, 'j'); // Yeísmo is standard in most learning mats
  s = s.replace(/rr/g, 'r'); // Trill
  
  // Context-dependent 'r'
  // 'r' at start is trilled
  s = s.replace(/^r/, 'r');
  s = s.replace(/\sr/g, ' r'); // after space
  // 'r' after n, l, s is trilled
  s = s.replace(/([nls])r/g, '$1r');
  // Single 'r' elsewhere is tap
  s = s.replace(/r/g, 'ɾ');

  // 'c' rules
  s = s.replace(/c([eéií])/g, 's$1'); // ce, ci -> se, si (LatAm)
  s = s.replace(/c/g, 'k'); // ca, co, cu -> ka, ko, ku

  // 'g' rules
  s = s.replace(/g([eéií])/g, 'x$1'); // ge, gi -> xe, xi
  s = s.replace(/gu([eéií])/g, 'g$1'); // gue, gui -> ge, gi
  s = s.replace(/g/g, 'g'); // ga, go, gu

  // 'j'
  s = s.replace(/j/g, 'x');

  // 'h' is silent
  s = s.replace(/h/g, '');

  // 'ñ'
  s = s.replace(/ñ/g, 'ɲ');

  // 'qu'
  s = s.replace(/qu([eéií])/g, 'k$1');

  // 'z'
  s = s.replace(/z/g, 's'); // LatAm

  // 'v' -> 'b' (Spanish b/v are identical /b/ or /β/)
  s = s.replace(/v/g, 'b');

  // 'y' at end of word or alone -> i
  s = s.replace(/y\b/g, 'i');
  s = s.replace(/\by\b/g, 'i');
  // 'y' as consonant -> j
  s = s.replace(/y/g, 'j');

  // Vowels (simple mapping)
  // á -> a, etc. (Stress logic omitted for simplicity, just keeping vowel quality)
  s = s.replace(/[á]/g, 'a');
  s = s.replace(/[é]/g, 'e');
  s = s.replace(/[í]/g, 'i');
  s = s.replace(/[ó]/g, 'o');
  s = s.replace(/[úü]/g, 'u');

  return s;
}
