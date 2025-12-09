-- Users Table
CREATE TABLE IF NOT EXISTS users (
    id TEXT PRIMARY KEY, -- UUID or Auth Provider ID
    email TEXT UNIQUE NOT NULL,
    display_name TEXT,
    created_at INTEGER DEFAULT (unixepoch()),
    last_login INTEGER,
    is_premium BOOLEAN DEFAULT 0,
    total_xp INTEGER DEFAULT 0,
    current_streak INTEGER DEFAULT 0,
    last_streak_update INTEGER -- Timestamp of last streak activity
);

-- Courses Table (Tracks & Modules)
CREATE TABLE IF NOT EXISTS courses (
    id TEXT PRIMARY KEY,
    slug TEXT UNIQUE NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    level TEXT NOT NULL, -- A1, A2, B1, B2, C1, C2
    track_type TEXT NOT NULL, -- 'GENERAL' or 'SPECIALIZED'
    thumbnail_url TEXT,
    version INTEGER DEFAULT 1
);

-- Units/Chapters within a Course
CREATE TABLE IF NOT EXISTS units (
    id TEXT PRIMARY KEY,
    course_id TEXT NOT NULL,
    title TEXT NOT NULL,
    order_index INTEGER NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

-- Individual Lessons
CREATE TABLE IF NOT EXISTS lessons (
    id TEXT PRIMARY KEY,
    unit_id TEXT NOT NULL,
    title TEXT NOT NULL,
    content_type TEXT NOT NULL, -- 'AUDIO_DRILL', 'QUIZ', 'DIALOGUE', 'CONSTRUCTION_SCENARIO'
    content_json TEXT, -- Structure varies by content_type
    kc_id TEXT, -- Main Knowledge Component tested by this lesson
    order_index INTEGER NOT NULL,
    FOREIGN KEY (unit_id) REFERENCES units(id),
    FOREIGN KEY (kc_id) REFERENCES knowledge_components(id)
);

-- Knowledge Components (For BKT Algorithm)
CREATE TABLE IF NOT EXISTS knowledge_components (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL, -- e.g., 'Subjunctive_Present', 'Direct_Object_Pronouns'
    description TEXT
);

-- User Progress (High level completion)
CREATE TABLE IF NOT EXISTS user_course_progress (
    user_id TEXT NOT NULL,
    course_id TEXT NOT NULL,
    current_unit_id TEXT,
    completed_lessons_count INTEGER DEFAULT 0,
    is_completed BOOLEAN DEFAULT 0,
    last_updated INTEGER DEFAULT (unixepoch()),
    PRIMARY KEY (user_id, course_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

-- BKT State Tracking (Per User, Per Knowledge Component)
CREATE TABLE IF NOT EXISTS user_kc_state (
    user_id TEXT NOT NULL,
    kc_id TEXT NOT NULL,
    p_know REAL DEFAULT 0.01, -- Probability the user knows the KC (0.0 to 1.0)
    last_practice_time INTEGER,
    PRIMARY KEY (user_id, kc_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (kc_id) REFERENCES knowledge_components(id)
);

-- Raw Interaction Log (For training BKT or debugging)
-- Note: This might get large, often better suited for Analytics Engine or R2 logs, 
-- but keeping a recent buffer in D1 is useful.
CREATE TABLE IF NOT EXISTS study_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT NOT NULL,
    lesson_id TEXT NOT NULL,
    interaction_type TEXT, -- 'ANSWER', 'VOICE_ATTEMPT'
    is_correct BOOLEAN,
    response_time_ms INTEGER,
    timestamp INTEGER DEFAULT (unixepoch())
);

-- Chat History for AI Roleplay
CREATE TABLE IF NOT EXISTS chat_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    conversation_id TEXT NOT NULL,
    user_id TEXT NOT NULL,
    role TEXT NOT NULL, -- 'user' or 'assistant' or 'system'
    content TEXT NOT NULL,
    timestamp INTEGER DEFAULT (unixepoch())
);
CREATE INDEX IF NOT EXISTS idx_chat_history_conversation ON chat_history(conversation_id, timestamp);

-- User Streaks (Detailed history)
CREATE TABLE IF NOT EXISTS user_streaks (
    user_id TEXT NOT NULL,
    activity_date TEXT NOT NULL, -- YYYY-MM-DD format (UTC)
    activity_count INTEGER DEFAULT 1,
    PRIMARY KEY (user_id, activity_date),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- XP Logs (Audit trail)
CREATE TABLE IF NOT EXISTS xp_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT NOT NULL,
    amount INTEGER NOT NULL,
    source_type TEXT NOT NULL, -- 'LESSON_COMPLETE', 'QUIZ_PERFECT', 'STREAK_BONUS'
    reference_id TEXT, -- lesson_id or other ref
    timestamp INTEGER DEFAULT (unixepoch())
);

-- Admin Users (RBAC)
CREATE TABLE IF NOT EXISTS admins (
    user_id TEXT PRIMARY KEY,
    role TEXT DEFAULT 'editor', -- 'superadmin', 'editor'
    created_at INTEGER DEFAULT (unixepoch()),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Analytics Events
CREATE TABLE IF NOT EXISTS analytics_events (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT,
    event_name TEXT NOT NULL,
    properties TEXT, -- JSON
    timestamp INTEGER DEFAULT (unixepoch())
);