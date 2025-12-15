#!/usr/bin/env bash
set -e

echo "🧪 Running Flutter tests with coverage..."
flutter test --coverage

# -----------------------------------------------------------------------------
# Coverage exclusions (add/remove patterns here)
# -----------------------------------------------------------------------------
EXCLUDES=(
  "**/l10n/**"
  "app_config.dart"
  "main.dart"
  # "*/lib/config/**"
  # "*/lib/generated/**"
  # "*/lib/**.g.dart"
  # "*/lib/**.freezed.dart"
)

echo "🧹 Removing excluded files from coverage..."

# Build lcov remove arguments
LCOV_REMOVE_ARGS=()
for pattern in "${EXCLUDES[@]}"; do
  LCOV_REMOVE_ARGS+=("$pattern")
done

lcov -r coverage/lcov.info --exclude "${LCOV_REMOVE_ARGS[@]}" -o coverage/lcov.info

echo "📊 Generating HTML coverage report..."
genhtml coverage/lcov.info -o coverage/html

echo "🌍 Opening coverage report..."
open coverage/html/index.html

echo "✅ Coverage report ready!"
