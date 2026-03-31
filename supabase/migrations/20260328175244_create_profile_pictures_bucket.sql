-- ============================================================================
-- MIGRATION: Create profile-pictures storage bucket
-- ============================================================================
-- This migration:
-- 1. Creates a storage bucket named 'profile-pictures' with public read access
-- 2. Creates a policy allowing authenticated users to upload their own profile pictures
-- 3. Creates a policy allowing authenticated users to read profile pictures
-- ============================================================================

-- ============================================================================
-- STEP 1: Create the storage bucket (using only basic columns)
-- ============================================================================

INSERT INTO storage.buckets (id, name)
VALUES (
    'profile-pictures',
    'profile-pictures'
)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- STEP 2: Create policy for authenticated users to upload their own profile pictures
-- ============================================================================

DROP POLICY IF EXISTS "Authenticated users can upload their own profile pictures" ON storage.objects;
CREATE POLICY "Authenticated users can upload their own profile pictures"
    ON storage.objects FOR INSERT
    WITH CHECK (
        bucket_id = 'profile-pictures'
        AND auth.uid()::text = (storage.foldername(name))[1]
    );

-- ============================================================================
-- STEP 3: Create policy for authenticated users to read profile pictures
-- ============================================================================

DROP POLICY IF EXISTS "Authenticated users can read profile pictures" ON storage.objects;
CREATE POLICY "Authenticated users can read profile pictures"
    ON storage.objects FOR SELECT
    USING (
        bucket_id = 'profile-pictures'
    );

-- ============================================================================
-- STEP 4: Create policy for authenticated users to update their own profile pictures
-- ============================================================================

DROP POLICY IF EXISTS "Authenticated users can update their own profile pictures" ON storage.objects;
CREATE POLICY "Authenticated users can update their own profile pictures"
    ON storage.objects FOR UPDATE
    USING (
        bucket_id = 'profile-pictures'
        AND auth.uid()::text = (storage.foldername(name))[1]
    )
    WITH CHECK (
        bucket_id = 'profile-pictures'
        AND auth.uid()::text = (storage.foldername(name))[1]
    );

-- ============================================================================
-- STEP 5: Create policy for authenticated users to delete their own profile pictures
-- ============================================================================

DROP POLICY IF EXISTS "Authenticated users can delete their own profile pictures" ON storage.objects;
CREATE POLICY "Authenticated users can delete their own profile pictures"
    ON storage.objects FOR DELETE
    USING (
        bucket_id = 'profile-pictures'
        AND auth.uid()::text = (storage.foldername(name))[1]
    );
