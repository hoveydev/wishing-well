#!/usr/bin/env bash
set -e

# -----------------------------------------------------------------------------
# Run Flutter tests with coverage
# -----------------------------------------------------------------------------

echo "🧪 Running Flutter tests with coverage..."
echo ""

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
  "*/test_helpers/*"
  "*/test/testing/*"
  "*/features/*/demo/*"
)

echo "🧹 Removing excluded files from coverage..."

LCOV_REMOVE_ARGS=()
for pattern in "${EXCLUDES[@]}"; do
  LCOV_REMOVE_ARGS+=("$pattern")
done

lcov --ignore-errors unused -r coverage/lcov.info --exclude "${LCOV_REMOVE_ARGS[@]}" -o coverage/lcov.info

echo "📊 Generating HTML coverage report..."
genhtml coverage/lcov.info -o coverage/html

echo "🌍 Opening coverage report..."
open coverage/html/index.html

echo "✅ Coverage report ready!"