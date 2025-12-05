-- Update Audio URLs for Lesson 1
UPDATE lessons 
SET content_json = '[
  {"speaker": "A", "es": "Buenos días.", "en": "Good morning.", "audio_ref": "https://www2.cs.uic.edu/~i101/SoundFiles/BabyElephantWalk60.wav"},
  {"speaker": "B", "es": "Buenos días, señor.", "en": "Good morning, sir.", "audio_ref": "https://www2.cs.uic.edu/~i101/SoundFiles/CantinaBand60.wav"},
  {"speaker": "A", "es": "¿Cómo está usted?", "en": "How are you?", "audio_ref": "https://www2.cs.uic.edu/~i101/SoundFiles/StarWars60.wav"}
]'
WHERE id = 'l1';

-- Update Audio URLs for Lesson l_c2_1
UPDATE lessons
SET content_json = '[
  {"speaker": "Foreman", "es": "¿Tienes tu casco?", "en": "Do you have your hard hat?", "audio_ref": "https://www2.cs.uic.edu/~i101/SoundFiles/PinkPanther30.wav"},
  {"speaker": "Worker", "es": "Sí, y mis gafas de seguridad.", "en": "Yes, and my safety glasses.", "audio_ref": "https://www2.cs.uic.edu/~i101/SoundFiles/taunt.wav"}
]'
WHERE id = 'l_c2_1';
