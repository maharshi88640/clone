/*
  # Create skills table

  1. New Tables
    - `skills`
      - `id` (integer, primary key, auto-increment)
      - `user_id` (integer, foreign key to users)
      - `name` (varchar, required)
      - `description` (text, optional)
      - `category` (varchar, required)
      - `level` (varchar, required - Beginner/Intermediate/Advanced/Expert)
      - `type` (varchar, required - offered/wanted)
      - `created_at` (timestamp, default now)
      - `updated_at` (timestamp, default now)

  2. Security
    - Enable RLS on `skills` table
    - Add policies for users to manage their own skills
    - Add policy for public read access to offered skills

  3. Indexes
    - Index on user_id for fast user skill lookups
    - Index on category for filtering
    - Index on type for filtering
*/

-- Create skills table
CREATE TABLE IF NOT EXISTS skills (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  category VARCHAR(100) NOT NULL,
  level VARCHAR(20) NOT NULL,
  type VARCHAR(20) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add constraints
ALTER TABLE skills ADD CONSTRAINT skills_level_check 
  CHECK (level IN ('Beginner', 'Intermediate', 'Advanced', 'Expert'));

ALTER TABLE skills ADD CONSTRAINT skills_type_check 
  CHECK (type IN ('offered', 'wanted'));

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_skills_user_id ON skills(user_id);
CREATE INDEX IF NOT EXISTS idx_skills_category ON skills(category);
CREATE INDEX IF NOT EXISTS idx_skills_type ON skills(type);

-- Enable RLS
ALTER TABLE skills ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can manage own skills" ON skills
  FOR ALL TO authenticated
  USING (auth.uid()::text = user_id::text);

CREATE POLICY "Offered skills are publicly readable" ON skills
  FOR SELECT TO authenticated
  USING (
    type = 'offered' AND 
    user_id IN (
      SELECT id FROM users 
      WHERE is_public = true AND is_active = true
    )
  );