#!/usr/bin/env bash
set -e

echo "🧪 Running Flutter tests with coverage..."
flutter test --coverage

# -----------------------------------------------------------------------------
# Coverage exclusions (must match git_hooks.dart excludePatterns)
# -----------------------------------------------------------------------------
EXCLUDES=(
  "**/l10n/**"
  "**/*.g.dart"
  "main.dart"
  "app_config.dart"
  "app_logger.dart"
  "**/components/demo/demos/**"
  "**/components/demo/demo_home.dart"
  "**/components/demo/demo_app.dart"
)

echo "🧹 Removing excluded files from coverage..."

# Build lcov remove arguments
LCOV_REMOVE_ARGS=()
for pattern in "${EXCLUDES[@]}"; do
  LCOV_REMOVE_ARGS+=("$pattern")
done

# --ignore-errors unused: skip patterns that don't match any files
lcov --ignore-errors unused -r coverage/lcov.info --exclude "${LCOV_REMOVE_ARGS[@]}" -o coverage/lcov.info

echo "📊 Generating HTML coverage report..."
genhtml coverage/lcov.info -o coverage/html

echo "🌍 Opening coverage report..."
open coverage/html/index.html

echo "✅ Coverage report ready!"
