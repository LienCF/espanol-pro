-- Seed Courses
INSERT INTO courses (id, slug, title, description, level, track_type, thumbnail_url) VALUES 
('c1', 'spanish-foundations-1', 'Spanish Foundations I', 'Based on FSI Vol 1. Master the basics of sentence structure and pronunciation.', 'A1', 'GENERAL', 'assets/images/course_a1.png'),
('c2', 'construction-safety', 'Construction Site Safety', 'Essential commands and safety protocols for job sites (OSHA aligned).', 'B1', 'SPECIALIZED', 'assets/images/course_construction.png'),
('c3', 'medical-triage', 'Medical Triage Spanish', 'Rapid assessment vocabulary for nurses and EMTs.', 'A2', 'SPECIALIZED', 'assets/images/course_medical.png');

-- Seed Units for Course c1
INSERT INTO units (id, course_id, title, order_index) VALUES
('u1', 'c1', 'Unit 1: The Basics', 1),
('u2', 'c1', 'Unit 2: Greetings', 2);

-- Seed Unit for Course c2
INSERT INTO units (id, course_id, title, order_index) VALUES
('u_c2_1', 'c2', 'Site Safety Basics', 1);

-- Seed Lessons for Unit u1
INSERT INTO lessons (id, unit_id, title, content_type, order_index, content_json) VALUES
('l1', 'u1', 'Basic Sentences', 'DIALOGUE', 1, '[
  {"speaker": "A", "es": "Buenos días.", "en": "Good morning.", "audio_ref": "https://www2.cs.uic.edu/~i101/SoundFiles/BabyElephantWalk60.wav"},
  {"speaker": "B", "es": "Buenos días, señor.", "en": "Good morning, sir.", "audio_ref": "https://www2.cs.uic.edu/~i101/SoundFiles/CantinaBand60.wav"},
  {"speaker": "A", "es": "¿Cómo está usted?", "en": "How are you?", "audio_ref": "https://www2.cs.uic.edu/~i101/SoundFiles/StarWars60.wav"}
]'),
('l2', 'u1', 'Substitution Drill', 'DRILL', 2, '[
  {"base": "Yo voy al banco.", "substitution": "la tienda", "result": "Yo voy a la tienda."},
  {"base": "Yo voy a la tienda.", "substitution": "el hotel", "result": "Yo voy al hotel."}
]'),
('l3', 'u1', 'Unit Quiz', 'QUIZ', 3, '[
  {
    "question": "How do you say ''Good morning''?",
    "options": ["Buenas noches", "Buenos días", "Hola", "Adiós"],
    "correctIndex": 1
  },
  {
    "question": "Translate: ''I go to the store.''",
    "options": ["Yo voy al banco", "Yo voy al hotel", "Yo voy a la tienda", "Yo soy la tienda"],
    "correctIndex": 2
  },
  {
    "question": "What is the correct response to ''¿Cómo está usted?''",
    "options": ["Bien, gracias", "Buenos días", "Yo voy", "El señor"],
    "correctIndex": 0
  }
]');

-- Seed Lesson for Unit u_c2_1
INSERT INTO lessons (id, unit_id, title, content_type, order_index, content_json) VALUES
('l_c2_1', 'u_c2_1', 'PPE Vocabulary', 'DIALOGUE', 1, '[
  {"speaker": "Foreman", "es": "¿Tienes tu casco?", "en": "Do you have your hard hat?", "audio_ref": "https://www2.cs.uic.edu/~i101/SoundFiles/PinkPanther30.wav"},
  {"speaker": "Worker", "es": "Sí, y mis gafas de seguridad.", "en": "Yes, and my safety glasses.", "audio_ref": "https://www2.cs.uic.edu/~i101/SoundFiles/taunt.wav"}
]');
