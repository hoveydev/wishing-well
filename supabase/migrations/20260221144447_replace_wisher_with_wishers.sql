-- ============================================================================
-- MIGRATION: Replace Wisher table with wishers table
-- ============================================================================
-- This migration:
-- 1. Drops the old "Wisher" table (uppercase, bigint ID, no user relationship)
-- 2. Creates new "wishers" table with proper design:
--    - UUID primary key
--    - Foreign key to auth.users
--    - Required first_name and last_name
--    - Profile picture URL
--    - Timestamps
--    - Row Level Security policies
--    - Performance indexes
-- ============================================================================

-- ============================================================================
-- STEP 1: Drop the old Wisher table
-- ============================================================================

DROP TABLE IF EXISTS public."Wisher" CASCADE;

-- ============================================================================
-- STEP 2: Create the new wishers table
-- ============================================================================

CREATE TABLE public.wishers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    profile_picture VARCHAR(500),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================================
-- STEP 3: Create indexes for performance
-- ============================================================================

-- Index for fast lookups by user
CREATE INDEX idx_wishers_user_id ON public.wishers(user_id);

-- Index for case-insensitive name search
CREATE INDEX idx_wishers_name_search ON public.wishers(lower(first_name), lower(last_name));

-- GIN index for full-text search on names
CREATE INDEX idx_wishers_name_gin ON public.wishers 
    USING gin(to_tsvector('english', first_name || ' ' || last_name));

-- ============================================================================
-- STEP 4: Enable Row Level Security
-- ============================================================================

ALTER TABLE public.wishers ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view their own wishers
CREATE POLICY "Users can view their own wishers"
    ON public.wishers FOR SELECT
    USING (auth.uid() = user_id);

-- Policy: Users can insert their own wishers
CREATE POLICY "Users can insert their own wishers"
    ON public.wishers FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Policy: Users can update their own wishers
CREATE POLICY "Users can update their own wishers"
    ON public.wishers FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- Policy: Users can delete their own wishers
CREATE POLICY "Users can delete their own wishers"
    ON public.wishers FOR DELETE
    USING (auth.uid() = user_id);

-- ============================================================================
-- STEP 5: Create trigger for auto-updating updated_at
-- ============================================================================

CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at
    BEFORE UPDATE ON public.wishers
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at();

-- ============================================================================
-- STEP 6: Add comments for documentation
-- ============================================================================

COMMENT ON TABLE public.wishers IS 'Stores wisher profiles associated with users. Each user can have multiple wishers.';
COMMENT ON COLUMN public.wishers.id IS 'Unique identifier for the wisher';
COMMENT ON COLUMN public.wishers.user_id IS 'Reference to the user who owns this wisher';
COMMENT ON COLUMN public.wishers.first_name IS 'Wisher''s first name (required)';
COMMENT ON COLUMN public.wishers.last_name IS 'Wisher''s last name (required)';
COMMENT ON COLUMN public.wishers.profile_picture IS 'URL to the wisher''s profile picture';
COMMENT ON COLUMN public.wishers.created_at IS 'Timestamp when the wisher was created';
COMMENT ON COLUMN public.wishers.updated_at IS 'Timestamp when the wisher was last updated';
