#!/bin/bash

# Component Demo Runner
# ====================
# This script runs the component demo app for testing and development purposes.

set -e

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Target file
TARGET_FILE="lib/components/demo/main.dart"

# Check if target file exists
if [ ! -f "$PROJECT_ROOT/$TARGET_FILE" ]; then
    echo "❌ Error: Target file not found: $PROJECT_ROOT/$TARGET_FILE"
    echo "   Please ensure the component demo app is in the correct location."
    exit 1
fi

echo "🚨 Starting Component Demo App..."
echo "📁 Target: $TARGET_FILE"
echo "⚙️  Project root: $PROJECT_ROOT"
echo ""

# Change to project root
cd "$PROJECT_ROOT"

# Run the component demo app
flutter run --target "$TARGET_FILE"
