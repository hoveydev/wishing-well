#!/bin/bash

# Test Refactoring Migration Helper
# This script helps identify tests that need refactoring according to new standards
# Exit codes: 0 = no issues found, 1 = issues found

# Track total issues found
TOTAL_ISSUES=0

echo "🔍 Analyzing test suite for refactoring opportunities..."
echo "========================================================"

# Function to check for patterns in test files
check_pattern() {
    local pattern=$1
    local description=$2
    local file=$3
    
    if grep -q "$pattern" "$file" 2>/dev/null; then
        echo "⚠️  $description in $file"
        grep -n "$pattern" "$file" | head -3
        echo ""
        ((TOTAL_ISSUES++))
    fi
}

# Check if file is a widget/UI test (needs widget helpers)
is_widget_test() {
    local file=$1
    # Unit tests don't need widget helpers
    if echo "$file" | grep -q "unit_tests/"; then
        return 1
    fi
    # Files that don't use testWidgets or pumpWidget are not widget tests
    if ! grep -q "testWidgets\|pumpWidget\|MaterialApp" "$file" 2>/dev/null; then
        return 1
    fi
    return 0
}

# Function to analyze a test file
analyze_test_file() {
    local file=$1
    echo "📄 Analyzing: $file"
    
    # Only check for inconsistent MaterialApp setup in widget tests
    # Flag files that define their own MaterialApp wrapper instead of using standard helpers
    if is_widget_test "$file"; then
        # Check for custom MaterialApp wrapper functions (not the standard helpers)
        if grep -q "Widget create.*TestWidget.*=> MaterialApp(" "$file" 2>/dev/null; then
            echo "⚠️  Custom MaterialApp wrapper found - use standard helpers from test_helpers.dart"
            grep -n "Widget create.*TestWidget.*=> MaterialApp(" "$file" | head -3
            echo ""
            ((TOTAL_ISSUES++))
        fi
        
        # Check for raw MaterialApp usage (not inside a helper)
        # This is a heuristic - if we find MaterialApp( not preceded by createScreenTestWidget etc.
        if grep -q "MaterialApp(" "$file" 2>/dev/null && \
           ! grep -q "createComponentTestWidget\|createScreenTestWidget\|createTestWidget\|buildMaterialAppHome" "$file" 2>/dev/null; then
            echo "⚠️  Raw MaterialApp usage - consider using createComponentTestWidget or createScreenTestWidget"
            grep -n "MaterialApp(" "$file" | head -3
            echo ""
            ((TOTAL_ISSUES++))
        fi
    fi
    
    # Check for missing group organization (applies to all tests)
    local group_count
    group_count=$(grep -c "group(" "$file" 2>/dev/null || echo 0)
    group_count=$(echo "$group_count" | tr -d '[:space:]')
    if [ "$group_count" -lt 1 ]; then
        echo "⚠️  No test groups found - consider using group() for organization"
        ((TOTAL_ISSUES++))
    fi
    
    echo ""
}

# Function to suggest specific refactorings (informational only, not counted as issues)
suggest_refactoring() {
    local file=$1
    
    # Skip suggestions for unit tests - they don't need widget helpers
    if ! is_widget_test "$file"; then
        return
    fi
    
    # Check if file already uses a standard helper - if so, no suggestions needed
    if grep -q "createTestWidget\|createComponentTestWidget\|createScreenTestWidget\|buildMaterialAppHome" "$file" 2>/dev/null; then
        return
    fi
    
    local suggestions=""
    
    # Check if file uses standard helpers
    if ! grep -q "TestHelpers\." "$file" 2>/dev/null; then
        suggestions="${suggestions}   - Consider using TestHelpers for common operations\n"
    fi
    
    # Check if file uses TestGroups
    if ! grep -q "TestGroups\." "$file" 2>/dev/null; then
        suggestions="${suggestions}   - Consider using TestGroups constants for consistent group naming\n"
    fi
    
    # Only print if there are actual suggestions
    if [ -n "$suggestions" ]; then
        echo "💡 Suggested refactorings for $file:"
        echo -e "$suggestions"
    fi
}

# Main analysis
echo "🔍 Finding test files..."
test_files=$(find test -name "*_test.dart" | sort)

echo "📊 Test Statistics:"
total_files=$(echo "$test_files" | wc -l)
echo "   Total test files: $total_files"

ui_test_files=$(echo "$test_files" | grep "ui_tests" | wc -l)
unit_test_files=$(echo "$test_files" | grep "unit_tests" | wc -l)
echo "   UI tests: $ui_test_files"
echo "   Unit tests: $unit_test_files"
echo ""

echo "🔍 Analyzing files for refactoring opportunities..."
echo ""

# Analyze each test file
for file in $test_files; do
    if [ -f "$file" ]; then
        analyze_test_file "$file"
        suggest_refactoring "$file"
    fi
done

echo "🎯 Priority Refactoring Recommendations:"
echo "========================================="
echo ""
echo "1. HIGH PRIORITY - Consolidate fragmented tests:"
echo "   - Look for multiple test files testing the same feature"
echo "   - Combine related component tests into single files"
echo "   - Example: add_wisher_*.dart tests could be consolidated"
echo ""
echo "2. HIGH PRIORITY - Standardize setup patterns:"
echo "   - Replace all MaterialApp() setups with helper functions"
echo "   - Use createComponentTestWidget for component tests"
echo "   - Use createScreenTestWidget for screen tests"
echo ""
echo "3. MEDIUM PRIORITY - Improve test organization:"
echo "   - Use TestGroups constants for consistent naming"
echo "   - Group related tests logically"
echo "   - Remove redundant test scenarios"
echo ""
echo "4. MEDIUM PRIORITY - Reduce code duplication:"
echo "   - Replace repetitive pumpAndSettle calls with TestHelpers"
echo "   - Use TestHelpers.expectTextOnce() instead of find/expect"
echo "   - Consolidate similar test patterns"
echo ""
echo "5. LOW PRIORITY - Improve naming and documentation:"
echo "   - Use more descriptive test names"
echo "   - Add comments for complex test scenarios"
echo "   - Follow AAA pattern consistently"
echo ""

echo "📝 Example Refactoring Commands:"
echo "==============================="
echo "# To run specific test groups after refactoring:"
echo "flutter test --name=\"Initial State\""
echo "flutter test --name=\"Interaction\""
echo "flutter test --name=\"Validation\""
echo ""
echo "# To run coverage on specific files:"
echo "flutter test --coverage test/ui_tests/components/button/app_button_test.dart"
echo ""
echo "# To create consolidated test files:"
echo "# See: test/ui_tests/screens/add_wisher/add_wisher_components_test.dart (example)"
echo ""

# Report results and exit with appropriate code
echo "========================================================"
echo "📊 Analysis Summary"
echo "========================================================"
if [ "$TOTAL_ISSUES" -gt 0 ]; then
    echo "❌ Found $TOTAL_ISSUES issue(s) requiring attention"
    echo ""
    echo "💡 See docs/TESTING_STANDARDS.md for guidance on fixing these issues"
    echo "💡 To temporarily disable this check, set enableTestQualityAnalysis = false in git_hooks.dart"
    exit 1
else
    echo "✅ No issues found! Test suite follows standards."
    exit 0
fi