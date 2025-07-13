/*
  # Create swap_requests table

  1. New Tables
    - `swap_requests`
      - `id` (integer, primary key, auto-increment)
      - `requester_id` (integer, foreign key to users)
      - `receiver_id` (integer, foreign key to users)
      - `offered_skill_id` (integer, foreign key to skills)
      - `wanted_skill_id` (integer, foreign key to skills)
      - `message` (text, optional)
      - `status` (varchar, default 'pending')
      - `created_at` (timestamp, default now)
      - `updated_at` (timestamp, default now)

  2. Security
    - Enable RLS on `swap_requests` table
    - Add policies for users to manage their own swap requests

  3. Indexes
    - Index on requester_id for fast lookups
    - Index on receiver_id for fast lookups
    - Index on status for filtering
*/

-- Create swap_requests table
CREATE TABLE IF NOT EXISTS swap_requests (
  id SERIAL PRIMARY KEY,
  requester_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  receiver_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  offered_skill_id INTEGER REFERENCES skills(id) ON DELETE CASCADE,
  wanted_skill_id INTEGER REFERENCES skills(id) ON DELETE CASCADE,
  message TEXT,
  status VARCHAR(20) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add constraints
ALTER TABLE swap_requests ADD CONSTRAINT swap_requests_status_check 
  CHECK (status IN ('pending', 'accepted', 'rejected', 'completed', 'cancelled'));

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_swap_requests_requester ON swap_requests(requester_id);
CREATE INDEX IF NOT EXISTS idx_swap_requests_receiver ON swap_requests(receiver_id);
CREATE INDEX IF NOT EXISTS idx_swap_requests_status ON swap_requests(status);

-- Enable RLS
ALTER TABLE swap_requests ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can manage their swap requests" ON swap_requests
  FOR ALL TO authenticated
  USING (
    auth.uid()::text = requester_id::text OR 
    auth.uid()::text = receiver_id::text
  );