-- Delete legacy lessons from Unit 1 and Unit 2
DELETE FROM lessons WHERE id IN ('l1', 'l2', 'l3');
DELETE FROM lessons WHERE id IN ('l2_1_dialogue', 'l2_2_drill', 'l2_3_quiz', 'l2_4_roleplay');