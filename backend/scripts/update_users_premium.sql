-- Add is_premium to users table
ALTER TABLE users ADD COLUMN is_premium BOOLEAN DEFAULT 0;
