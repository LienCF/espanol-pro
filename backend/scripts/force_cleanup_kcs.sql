-- Temporary Cleanup Script to Fix Foreign Keys
PRAGMA foreign_keys=OFF;

-- 1. Delete User Progress that references KCs
DELETE FROM user_kc_state;

-- 2. Nullify KC references in Lessons (optional, or keep if we re-seed with same IDs)
-- UPDATE lessons SET kc_id = NULL;

-- 3. Now delete KCs
DELETE FROM knowledge_components;

PRAGMA foreign_keys=ON;
