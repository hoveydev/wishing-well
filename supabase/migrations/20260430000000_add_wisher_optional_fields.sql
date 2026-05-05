-- Add optional birthday, gift_occasions, and gift_interests fields to wishers
ALTER TABLE public.wishers
  ADD COLUMN IF NOT EXISTS birthday DATE,
  ADD COLUMN IF NOT EXISTS gift_occasions TEXT[] DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS gift_interests TEXT[] DEFAULT NULL;

COMMENT ON COLUMN public.wishers.birthday IS
  'Wisher''s birthday (date only, no time component)';
COMMENT ON COLUMN public.wishers.gift_occasions IS
  'Array of gift-giving occasions the wisher celebrates '
  '(e.g., christmas, hanukkah)';
COMMENT ON COLUMN public.wishers.gift_interests IS
  'Array of gift interest categories for the wisher '
  '(e.g., books, jewelry)';
