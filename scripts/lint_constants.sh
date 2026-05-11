#!/bin/bash
# Lint script to detect hardcoded pixel values that should use app constants
# This script checks for common violations of the design constants system

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LIB_DIR="$REPO_ROOT/lib"

# ANSI colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Counter for violations
VIOLATION_COUNT=0

# Patterns to check for hardcoded values
check_hardcoded_spacing() {
  local files=$1
  local pattern=$2
  local message=$3
  local suggestion=$4
  
  if grep -rn "$pattern" $files --include="*.dart" 2>/dev/null | grep -v "test/" | grep -v ".dart.g" | grep -v "AppSpacerSize\|AppSpacing\|WisherSizing\|AppScreenLayout\|AppBarSizing"; then
    echo -e "${RED}✗ Found: $message${NC}"
    echo -e "  Suggestion: $suggestion"
    VIOLATION_COUNT=$((VIOLATION_COUNT + 1))
  fi
}

check_hardcoded_spacing_excluding_demos() {
  local files=$1
  local pattern=$2
  local message=$3
  local suggestion=$4
  
  if grep -rn "$pattern" $files --include="*.dart" 2>/dev/null | grep -v "test/" | grep -v ".dart.g" | grep -v "AppSpacerSize\|AppSpacing\|WisherSizing\|AppScreenLayout\|AppBarSizing" | grep -v "/demo/"; then
    echo -e "${RED}✗ Found: $message${NC}"
    echo -e "  Suggestion: $suggestion"
    VIOLATION_COUNT=$((VIOLATION_COUNT + 1))
  fi
}

echo "🔍 Checking for hardcoded design constants..."
echo ""

# Check for hardcoded spacing values
echo "Checking spacing values..."
check_hardcoded_spacing "$LIB_DIR" "EdgeInsets\.all([0-9])" \
  "Hardcoded EdgeInsets.all() values" \
  "Use AppSpacerSize constants: EdgeInsets.all(AppSpacerSize.large)"

check_hardcoded_spacing "$LIB_DIR" "EdgeInsets\.\(symmetric\|only\|fromLTRB\)[^)]*[^A-Za-z][0-9]\+[^A-Za-z]" \
  "Hardcoded EdgeInsets with numeric values" \
  "Use AppSpacerSize constants: EdgeInsets.symmetric(horizontal: AppSpacerSize.large)"

check_hardcoded_spacing "$LIB_DIR" "SizedBox\(width: [0-9]" \
  "Hardcoded SizedBox width values" \
  "Use AppSpacerSize constants: SizedBox(width: AppSpacerSize.small)"

check_hardcoded_spacing "$LIB_DIR" "SizedBox\(height: [0-9]" \
  "Hardcoded SizedBox height values" \
  "Use AppSpacerSize constants: SizedBox(height: AppSpacerSize.medium)"

# Date picker overlays should also avoid hardcoded width/height values
# outside of AppSpacerSize or semantic constants.
check_hardcoded_spacing "$LIB_DIR/components/date_picker" "width: [0-9]\+" \
  "Hardcoded date picker width values" \
  "Use AppSpacerSize or component semantic constants for width"

check_hardcoded_spacing "$LIB_DIR/components/date_picker" "height: [0-9]\+" \
  "Hardcoded date picker height values" \
  "Use AppSpacerSize or component semantic constants for height"

# Check for hardcoded border radius
echo "Checking border radius values..."
check_hardcoded_spacing "$LIB_DIR" "borderRadius: BorderRadius\.circular\([0-9]" \
  "Hardcoded border radius values" \
  "Use AppBorderRadius constants: BorderRadius.circular(AppBorderRadius.small)"

# Check for hardcoded border widths
echo "Checking border width values..."
check_hardcoded_spacing "$LIB_DIR" "width: [01]\." \
  "Possible hardcoded border width values" \
  "Use AppBorderWeight constants: width: AppBorderWeight.regular"

# Check for hardcoded icon sizes (outside of AppIconSize), excluding demos
# which intentionally use custom sizes to showcase components at different scales
echo "Checking icon size values..."
check_hardcoded_spacing_excluding_demos "$LIB_DIR" "size: [0-9]" \
  "Possible hardcoded icon size values" \
  "Use AppIconSize constants: size: const AppIconSize().medium"

# Check for hardcoded colors
echo "Checking color values..."
check_hardcoded_spacing "$LIB_DIR" "Color\(0x[0-9A-Fa-f]" \
  "Hardcoded Color values" \
  "Use AppColorScheme constants: colorScheme?.primary"

echo ""
if [ $VIOLATION_COUNT -eq 0 ]; then
  echo -e "${GREEN}✓ No hardcoded design constants found!${NC}"
  exit 0
else
  echo -e "${RED}✗ Found $VIOLATION_COUNT potential violations${NC}"
  echo ""
  echo "📖 For detailed guidelines, see: docs/DESIGN_CONSTANTS.md"
  exit 1
fi
