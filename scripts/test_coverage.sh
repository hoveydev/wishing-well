#!/usr/bin/env bash
set -e

# -----------------------------------------------------------------------------
# Run Flutter tests with coverage (unit, widget, AND integration tests)
# -----------------------------------------------------------------------------

echo "🧪 Running Flutter tests with coverage..."
echo ""

# Run both regular tests and integration tests with coverage
# Note: flutter test runs both test/ and integration_test/ directories by default
flutter test --coverage --reporter compact

echo ""

# -----------------------------------------------------------------------------
# Coverage exclusions (must match git_hooks.dart excludePatterns)
# -----------------------------------------------------------------------------
EXCLUDES=(
  "*/l10n/*"
  "*.g.dart"
  "*/main.dart"
  "*/app_config.dart"
  "*/app_logger.dart"
  "*/components/demo/demos/*"
  "*/components/demo/demo_home.dart"
  "*/components/demo/demo_app.dart"
  "*/data/data_sources/*"
  # ImageRepositoryImpl directly uses Supabase Storage + flutter_image_compress
  # without a data-source abstraction, making it untestable at the unit level.
  "*/data/repositories/image/image_repository_impl.dart"
  "*/test_helpers/*"
  "*/test/testing/*"
  "*/features/*/demo/*"
  # Note: Integration tests are NOT excluded - they count toward coverage
)

echo "🧹 Removing excluded files from coverage..."

LCOV_REMOVE_ARGS=()
for pattern in "${EXCLUDES[@]}"; do
  LCOV_REMOVE_ARGS+=("$pattern")
done

lcov --ignore-errors unused -r coverage/lcov.info --exclude "${LCOV_REMOVE_ARGS[@]}" -o coverage/lcov.info

echo "📊 Generating HTML coverage report..."
genhtml coverage/lcov.info -o coverage/html

echo "📂 Coverage report: coverage/html/index.html"
if [[ "$OSTYPE" == "darwin"* ]]; then
  open coverage/html/index.html
fi

echo "✅ Coverage report ready!"