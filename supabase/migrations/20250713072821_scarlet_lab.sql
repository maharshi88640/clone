/*
  # Create admin_messages table

  1. New Tables
    - `admin_messages`
      - `id` (integer, primary key, auto-increment)
      - `title` (varchar, required)
      - `content` (text, required)
      - `type` (varchar, default 'info')
      - `is_active` (boolean, default true)
      - `created_at` (timestamp, default now)

  2. Security
    - Enable RLS on `admin_messages` table
    - Add policies for admin management and public reading

  3. Indexes
    - Index on is_active for filtering
*/

-- Create admin_messages table
CREATE TABLE IF NOT EXISTS admin_messages (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  type VARCHAR(20) DEFAULT 'info',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add constraints
ALTER TABLE admin_messages ADD CONSTRAINT admin_messages_type_check 
  CHECK (type IN ('info', 'warning', 'error', 'success'));

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_admin_messages_active ON admin_messages(is_active);

-- Enable RLS
ALTER TABLE admin_messages ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Admins can manage messages" ON admin_messages
  FOR ALL TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users 
      WHERE id::text = auth.uid()::text AND role = 'admin'
    )
  );

CREATE POLICY "Active messages are publicly readable" ON admin_messages
  FOR SELECT TO authenticated
  USING (is_active = true);

-- Insert welcome message
INSERT INTO admin_messages (title, content, type, is_active, created_at)
VALUES (
  'Welcome to SkillXchange Platform!',
  'We''re excited to have you join our community of skill exchangers.',
  'info',
  true,
  NOW()
) ON CONFLICT DO NOTHING;