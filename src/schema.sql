-- Create task queue
CREATE TABLE IF NOT EXISTS tasks (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    duration INTEGER NOT NULL
);

-- Push to task queue
INSERT INTO tasks (name, duration) VALUES (?, ?);

-- Remove from task queue
DELETE FROM tasks WHERE id = 1;

-- Load from task queue
SELECT id, name, duration FROM tasks;