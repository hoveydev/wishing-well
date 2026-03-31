-- Update existing profile picture URLs to use authenticated endpoint
-- Run this manually in Supabase SQL Editor

UPDATE wishers
SET profile_picture = REPLACE(profile_picture, '/object/public/', '/object/authenticated/')
WHERE profile_picture IS NOT NULL
AND profile_picture LIKE '%/object/public/%';
