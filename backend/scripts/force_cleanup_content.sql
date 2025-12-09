PRAGMA foreign_keys=OFF;

-- Clear all content tables to ensure clean state for new localized data
DELETE FROM lessons;
DELETE FROM units;
DELETE FROM courses;

PRAGMA foreign_keys=ON;
