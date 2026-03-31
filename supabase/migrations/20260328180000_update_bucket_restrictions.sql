-- Note: File size and mime type restrictions cannot be added via SQL 
-- because the storage.buckets table is managed by Supabase.
-- These restrictions must be set via the Supabase Dashboard or Storage API.

-- Current bucket configuration (unrestricted):
-- - No file size limit
-- - Any file type allowed

-- To add restrictions:
-- 1. Go to Supabase Dashboard > Storage
-- 2. Click on "profile-pictures" bucket
-- 3. Edit bucket settings to add:
--    - File size limit: 5MB
--    - Allowed mime types: image/jpeg, image/png, image/gif, image/webp

-- For now, this bucket accepts any file type with any size.
