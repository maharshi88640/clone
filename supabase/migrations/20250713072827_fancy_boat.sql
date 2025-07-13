/*
  # Insert demo data

  1. Demo Users
    - Sarah Johnson (sarah@example.com)
    - Mike Chen (mike@example.com)
    - Emma Wilson (emma@example.com)

  2. Demo Skills
    - Various skills for each user (offered and wanted)

  3. Demo Swap Requests
    - Sample swap requests between users

  4. Demo Ratings
    - Sample ratings for completed swaps
*/

-- Insert demo users
INSERT INTO users (name, email, password, location, profile_photo, is_public, availability, rating, total_swaps, created_at, updated_at)
VALUES 
(
  'Sarah Johnson',
  'sarah@example.com',
  '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj/VcSAHHfye', -- demo123
  'San Francisco, CA',
  'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=150',
  true,
  '["Weekends", "Evenings"]'::jsonb,
  4.8,
  12,
  '2024-01-15'::timestamp,
  NOW()
),
(
  'Mike Chen',
  'mike@example.com',
  '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj/VcSAHHfye', -- demo123
  'New York, NY',
  'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=150',
  true,
  '["Weekdays", "Evenings"]'::jsonb,
  4.9,
  18,
  '2023-11-22'::timestamp,
  NOW()
),
(
  'Emma Wilson',
  'emma@example.com',
  '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj/VcSAHHfye', -- demo123
  'London, UK',
  'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=150',
  true,
  '["Weekends"]'::jsonb,
  4.7,
  8,
  '2024-02-10'::timestamp,
  NOW()
)
ON CONFLICT (email) DO NOTHING;

-- Insert demo skills for Sarah Johnson
DO $$
DECLARE
  sarah_id INTEGER;
BEGIN
  SELECT id INTO sarah_id FROM users WHERE email = 'sarah@example.com';
  
  IF sarah_id IS NOT NULL THEN
    INSERT INTO skills (user_id, name, description, category, level, type, created_at, updated_at)
    VALUES 
    (sarah_id, 'Adobe Photoshop', 'Professional photo editing and design', 'Design', 'Expert', 'offered', NOW(), NOW()),
    (sarah_id, 'UI/UX Design', 'Modern interface and user experience design', 'Design', 'Advanced', 'offered', NOW(), NOW()),
    (sarah_id, 'Python Programming', 'Learn Python for data analysis', 'Programming', 'Intermediate', 'wanted', NOW(), NOW())
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- Insert demo skills for Mike Chen
DO $$
DECLARE
  mike_id INTEGER;
BEGIN
  SELECT id INTO mike_id FROM users WHERE email = 'mike@example.com';
  
  IF mike_id IS NOT NULL THEN
    INSERT INTO skills (user_id, name, description, category, level, type, created_at, updated_at)
    VALUES 
    (mike_id, 'Python Programming', 'Full-stack Python development', 'Programming', 'Expert', 'offered', NOW(), NOW()),
    (mike_id, 'Data Analysis', 'Statistical analysis and visualization', 'Data', 'Advanced', 'offered', NOW(), NOW()),
    (mike_id, 'Digital Marketing', 'Social media and content marketing', 'Marketing', 'Beginner', 'wanted', NOW(), NOW())
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- Insert demo skills for Emma Wilson
DO $$
DECLARE
  emma_id INTEGER;
BEGIN
  SELECT id INTO emma_id FROM users WHERE email = 'emma@example.com';
  
  IF emma_id IS NOT NULL THEN
    INSERT INTO skills (user_id, name, description, category, level, type, created_at, updated_at)
    VALUES 
    (emma_id, 'Digital Marketing', 'SEO, SEM, and social media marketing', 'Marketing', 'Expert', 'offered', NOW(), NOW()),
    (emma_id, 'Content Writing', 'Blog posts and copywriting', 'Writing', 'Advanced', 'offered', NOW(), NOW()),
    (emma_id, 'Web Development', 'Frontend React development', 'Programming', 'Intermediate', 'wanted', NOW(), NOW())
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- Insert demo swap requests
DO $$
DECLARE
  sarah_id INTEGER;
  mike_id INTEGER;
  emma_id INTEGER;
  sarah_photoshop_id INTEGER;
  mike_python_id INTEGER;
  mike_data_id INTEGER;
  emma_marketing_id INTEGER;
BEGIN
  SELECT id INTO sarah_id FROM users WHERE email = 'sarah@example.com';
  SELECT id INTO mike_id FROM users WHERE email = 'mike@example.com';
  SELECT id INTO emma_id FROM users WHERE email = 'emma@example.com';
  
  SELECT id INTO sarah_photoshop_id FROM skills WHERE user_id = sarah_id AND name = 'Adobe Photoshop';
  SELECT id INTO mike_python_id FROM skills WHERE user_id = mike_id AND name = 'Python Programming';
  SELECT id INTO mike_data_id FROM skills WHERE user_id = mike_id AND name = 'Data Analysis';
  SELECT id INTO emma_marketing_id FROM skills WHERE user_id = emma_id AND name = 'Digital Marketing';
  
  IF sarah_id IS NOT NULL AND mike_id IS NOT NULL AND sarah_photoshop_id IS NOT NULL AND mike_python_id IS NOT NULL THEN
    INSERT INTO swap_requests (requester_id, receiver_id, offered_skill_id, wanted_skill_id, message, status, created_at, updated_at)
    VALUES 
    (sarah_id, mike_id, sarah_photoshop_id, mike_python_id, 'Hi! I''d love to learn Python in exchange for teaching Photoshop. I have 5+ years of experience.', 'pending', '2024-12-20 10:00:00', '2024-12-20 10:00:00')
    ON CONFLICT DO NOTHING;
  END IF;
  
  IF mike_id IS NOT NULL AND emma_id IS NOT NULL AND mike_data_id IS NOT NULL AND emma_marketing_id IS NOT NULL THEN
    INSERT INTO swap_requests (requester_id, receiver_id, offered_skill_id, wanted_skill_id, message, status, created_at, updated_at)
    VALUES 
    (mike_id, emma_id, mike_data_id, emma_marketing_id, 'Looking to trade data analysis skills for digital marketing expertise!', 'accepted', '2024-12-19 14:30:00', '2024-12-19 16:45:00')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- Insert demo rating
DO $$
DECLARE
  mike_id INTEGER;
  emma_id INTEGER;
  swap_id INTEGER;
BEGIN
  SELECT id INTO mike_id FROM users WHERE email = 'mike@example.com';
  SELECT id INTO emma_id FROM users WHERE email = 'emma@example.com';
  SELECT id INTO swap_id FROM swap_requests WHERE requester_id = mike_id AND receiver_id = emma_id;
  
  IF mike_id IS NOT NULL AND emma_id IS NOT NULL AND swap_id IS NOT NULL THEN
    INSERT INTO ratings (swap_id, rater_id, rated_user_id, rating, feedback, created_at)
    VALUES 
    (swap_id, mike_id, emma_id, 5, 'Emma was an excellent teacher! Very patient and knowledgeable about digital marketing.', '2024-12-19 18:00:00')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;