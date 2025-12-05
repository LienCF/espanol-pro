-- Seed Knowledge Components
INSERT INTO knowledge_components (id, name, description) VALUES 
('kc_basic_greetings', 'Basic Greetings', 'Common greetings and introductions'),
('kc_subject_pronouns', 'Subject Pronouns', 'Usage of Yo, Tú, Él, Ella, etc.'),
('kc_ser_vs_estar', 'Ser vs Estar', 'Distinguishing between the two "to be" verbs'),
('kc_gender_agreement', 'Gender Agreement', 'Matching nouns and adjectives by gender');

-- Link Lessons to KCs (Mock Data)
-- Lesson 1: Basic Sentences -> Basic Greetings
UPDATE lessons SET kc_id = 'kc_basic_greetings' WHERE id = 'l1';

-- Lesson 2: Substitution Drill (Yo voy...) -> Subject Pronouns
UPDATE lessons SET kc_id = 'kc_subject_pronouns' WHERE id = 'l2';

-- Lesson 3: Unit Quiz -> (Mixed, but let's assign Ser vs Estar for test)
UPDATE lessons SET kc_id = 'kc_ser_vs_estar' WHERE id = 'l3';
