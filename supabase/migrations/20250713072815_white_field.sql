/*
  # Create ratings table

  1. New Tables
    - `ratings`
      - `id` (integer, primary key, auto-increment)
      - `swap_id` (integer, foreign key to swap_requests)
      - `rater_id` (integer, foreign key to users)
      - `rated_user_id` (integer, foreign key to users)
      - `rating` (integer, required, 1-5)
      - `feedback` (text, optional)
      - `created_at` (timestamp, default now)

  2. Security
    - Enable RLS on `ratings` table
    - Add policies for users to manage their own ratings

  3. Indexes
    - Index on rated_user_id for fast lookups
*/

-- Create ratings table
CREATE TABLE IF NOT EXISTS ratings (
  id SERIAL PRIMARY KEY,
  swap_id INTEGER REFERENCES swap_requests(id) ON DELETE CASCADE,
  rater_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  rated_user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  rating INTEGER NOT NULL,
  feedback TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add constraints
ALTER TABLE ratings ADD CONSTRAINT ratings_rating_check 
  CHECK (rating >= 1 AND rating <= 5);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_ratings_rated_user ON ratings(rated_user_id);

-- Enable RLS
ALTER TABLE ratings ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can create ratings for their swaps" ON ratings
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid()::text = rater_id::text);

CREATE POLICY "Users can read ratings about themselves" ON ratings
  FOR SELECT TO authenticated
  USING (auth.uid()::text = rated_user_id::text);

CREATE POLICY "Users can read ratings they created" ON ratings
  FOR SELECT TO authenticated
  USING (auth.uid()::text = rater_id::text);