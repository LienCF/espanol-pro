-- Update Audio URLs for Lesson 1 with more reliable sources (Wikimedia Commons / Archive.org / Test sources)
-- Using reliable test streams or direct MP3s from a stable CDN is better.
-- Let's use: https://actions.google.com/sounds/v1/... (Google Sound Library)

UPDATE lessons 
SET content_json = '[
  {"speaker": "A", "es": "Buenos días.", "en": "Good morning.", "audio_ref": "https://actions.google.com/sounds/v1/crowds/female_crowd_celebration.ogg"},
  {"speaker": "B", "es": "Buenos días, señor.", "en": "Good morning, sir.", "audio_ref": "https://actions.google.com/sounds/v1/crowds/male_crowd_celebration.ogg"},
  {"speaker": "A", "es": "¿Cómo está usted?", "en": "How are you?", "audio_ref": "https://actions.google.com/sounds/v1/ambiences/coffee_shop.ogg"}
]'
WHERE id = 'l1';

-- Update Audio URLs for Lesson l_c2_1
UPDATE lessons
SET content_json = '[
  {"speaker": "Foreman", "es": "¿Tienes tu casco?", "en": "Do you have your hard hat?", "audio_ref": "https://actions.google.com/sounds/v1/tools/chainsaw.ogg"},
  {"speaker": "Worker", "es": "Sí, y mis gafas de seguridad.", "en": "Yes, and my safety glasses.", "audio_ref": "https://actions.google.com/sounds/v1/tools/drill.ogg"}
]'
WHERE id = 'l_c2_1';
