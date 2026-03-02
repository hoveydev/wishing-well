#!/usr/bin/env bash
set -e

echo "🧪 Running Flutter tests with coverage..."
flutter test --coverage

# -----------------------------------------------------------------------------
# Coverage exclusions (must match git_hooks.dart excludePatterns)
# -----------------------------------------------------------------------------
# IMPORTANT: lcov requires glob patterns with wildcards (*), which differ from
# the substring patterns used in git_hooks.dart. Both must be kept in sync:
#
#   git_hooks.dart:  'data/data_sources/'     (substring match)
#   test_coverage.sh: "*/data/data_sources/*" (glob pattern with wildcards)
#
# The patterns below match the SF: lines in lcov.info
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
)

echo "🧹 Removing excluded files from coverage..."

# Build lcov remove arguments
LCOV_REMOVE_ARGS=()
for pattern in "${EXCLUDES[@]}"; do
  LCOV_REMOVE_ARGS+=("$pattern")
done

# --ignore-errors unused: skip patterns that don't match any files
lcov --ignore-errors unused,unused -r coverage/lcov.info --exclude "${LCOV_REMOVE_ARGS[@]}" -o coverage/lcov.info

echo "📊 Generating HTML coverage report..."
genhtml coverage/lcov.info -o coverage/html

echo "🌍 Opening coverage report..."
open coverage/html/index.html

echo "✅ Coverage report ready!"
