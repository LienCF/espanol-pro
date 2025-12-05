-- Insert Lessons for Unit 2 (which was already seeded in initial seed but empty of lessons, or maybe not? Let's check seed_d1.sql)
-- Checking seed_d1.sql: 'u2' was inserted but no lessons were added for it. Perfect.

INSERT INTO lessons (id, unit_id, title, content_type, order_index, content_json) VALUES
('l2_1_dialogue', 'u2', 'Dialogue: At the Office', 'DIALOGUE', 1, '[
  {
    "speaker": "Sr. Adams",
    "es": "Buenas tardes, señor.",
    "en": "Good afternoon, sir.",
    "audio_ref": "https://actions.google.com/sounds/v1/crowds/female_crowd_celebration.ogg"
  },
  {
    "speaker": "Sr. Molina",
    "es": "Buenas tardes. ¿Es usted el señor Adams?",
    "en": "Good afternoon. Are you Mr. Adams?",
    "audio_ref": "https://actions.google.com/sounds/v1/crowds/male_crowd_celebration.ogg"
  },
  {
    "speaker": "Sr. Adams",
    "es": "Sí, señor. Y usted es el señor Molina, ¿verdad?",
    "en": "Yes, sir. And you are Mr. Molina, right?",
    "audio_ref": "https://actions.google.com/sounds/v1/ambiences/coffee_shop.ogg"
  },
  {
    "speaker": "Sr. Molina",
    "es": "Sí, señor. Mucho gusto.",
    "en": "Yes, sir. Nice to meet you.",
    "audio_ref": "https://actions.google.com/sounds/v1/crowds/female_crowd_celebration.ogg"
  },
  {
    "speaker": "Sr. Adams",
    "es": "El gusto es mío.",
    "en": "The pleasure is mine.",
    "audio_ref": "https://actions.google.com/sounds/v1/crowds/male_crowd_celebration.ogg"
  }
]'),
('l2_2_drill', 'u2', 'Drill: Ser (To be)', 'DRILL', 2, '[
  {"base": "Yo soy norteamericano.", "substitution": "Nosotros", "result": "Nosotros somos norteamericanos."},
  {"base": "Nosotros somos norteamericanos.", "substitution": "Él", "result": "Él es norteamericano."},
  {"base": "Él es norteamericano.", "substitution": "Ellos", "result": "Ellos son norteamericanos."},
  {"base": "Ellos son norteamericanos.", "substitution": "Ella", "result": "Ella es norteamericana."}
]'),
('l2_3_quiz', 'u2', 'Unit 2 Quiz', 'QUIZ', 3, '[
  {
    "question": "How do you say ''Nice to meet you''?",
    "options": ["Por favor", "Mucho gusto", "Buenas tardes", "Perdón"],
    "correctIndex": 1
  },
  {
    "question": "Which verb form is used for ''We are''?",
    "options": ["Soy", "Es", "Somos", "Son"],
    "correctIndex": 2
  },
  {
    "question": "Translate: ''Are you Mr. Adams?''",
    "options": ["¿Es usted el señor Adams?", "¿Soy yo el señor Adams?", "¿Cómo está el señor Adams?", "Hola señor Adams"],
    "correctIndex": 0
  }
]');
