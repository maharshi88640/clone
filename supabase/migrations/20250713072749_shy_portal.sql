/*
  # Create users table

  1. New Tables
    - `users`
      - `id` (integer, primary key, auto-increment)
      - `name` (varchar, required)
      - `email` (varchar, unique, required)
      - `password` (varchar, required)
      - `location` (varchar, optional)
      - `profile_photo` (text, optional)
      - `is_public` (boolean, default true)
      - `availability` (jsonb, default empty array)
      - `rating` (numeric, default 0.0)
      - `total_swaps` (integer, default 0)
      - `is_active` (boolean, default true)
      - `role` (varchar, default 'user')
      - `created_at` (timestamp, default now)
      - `updated_at` (timestamp, default now)

  2. Security
    - Enable RLS on `users` table
    - Add policies for authenticated users to manage their own data
    - Add policy for public read access to public profiles

  3. Indexes
    - Index on email for fast lookups
    - Index on is_public for filtering
*/

-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  location VARCHAR(255),
  profile_photo TEXT,
  is_public BOOLEAN DEFAULT true,
  availability JSONB DEFAULT '[]'::jsonb,
  rating NUMERIC(3,2) DEFAULT 0.0,
  total_swaps INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  role VARCHAR(20) DEFAULT 'user',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add constraints
ALTER TABLE users ADD CONSTRAINT users_role_check 
  CHECK (role IN ('user', 'admin'));

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_is_public ON users(is_public);

-- Enable RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can read own data" ON users
  FOR SELECT TO authenticated
  USING (auth.uid()::text = id::text);

CREATE POLICY "Users can update own data" ON users
  FOR UPDATE TO authenticated
  USING (auth.uid()::text = id::text);

CREATE POLICY "Public profiles are readable" ON users
  FOR SELECT TO authenticated
  USING (is_public = true AND is_active = true);

-- Insert default admin user
INSERT INTO users (name, email, password, location, is_public, availability, role, created_at, updated_at)
VALUES (
  'Admin User',
  'admin@skillxchange.com',
  '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj/VcSAHHfye', -- admin123
  'Platform',
  false,
  '[]'::jsonb,
  'admin',
  NOW(),
  NOW()
) ON CONFLICT (email) DO NOTHING;