#!/bin/bash

# Test Refactoring Migration Helper
# This script helps identify tests that need refactoring according to new standards

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
    fi
}

# Function to analyze a test file
analyze_test_file() {
    local file=$1
    echo "📄 Analyzing: $file"
    
    # Check for inconsistent setup patterns
    check_pattern "MaterialApp(" "Inconsistent MaterialApp setup" "$file"
    check_pattern "await tester.pumpWidget(" "Multiple pumpWidget calls" "$file"
    
    # Check for inconsistent naming
    check_pattern "testWidgets('renders" "Generic test naming" "$file"
    check_pattern "testWidgets('.*correctly" "Vague test descriptions" "$file"
    
    # Check for redundancy
    local pump_count=$(grep -c "await tester.pumpAndSettle()" "$file" 2>/dev/null || echo 0)
    if [ "$pump_count" -gt 5 ]; then
        echo "⚠️  High pumpAndSettle usage ($pump_count times) - consider using TestHelpers"
    fi
    
    local text_finder_count=$(grep -c "find.text(" "$file" 2>/dev/null || echo 0)
    if [ "$text_finder_count" -gt 3 ]; then
        echo "⚠️  Multiple find.text() calls - consider using TestHelpers.expectTextOnce()"
    fi
    
    # Check for missing group organization
    local group_count=$(grep -c "group(" "$file" 2>/dev/null || echo 0)
    if [ "$group_count" -lt 2 ]; then
        echo "⚠️  Poor test organization - consider using TestGroups constants"
    fi
    
    echo ""
}

# Function to suggest specific refactorings
suggest_refactoring() {
    local file=$1
    echo "💡 Suggested refactorings for $file:"
    
    # Check if file uses createTestWidget
    if ! grep -q "createTestWidget\|createComponentTestWidget\|createScreenTestWidget" "$file" 2>/dev/null; then
        echo "   - Replace MaterialApp setup with createTestWidget helper"
    fi
    
    # Check if file uses standard helpers
    if ! grep -q "TestHelpers\." "$file" 2>/dev/null; then
        echo "   - Replace pumpAndSettle with TestHelpers.pumpAndSettle"
        echo "   - Replace find.text() + expect with TestHelpers.expectTextOnce"
    fi
    
    # Check if file uses TestGroups
    if ! grep -q "TestGroups\." "$file" 2>/dev/null; then
        echo "   - Use TestGroups constants for consistent group naming"
    fi
    
    # Check for component vs screen classification
    if echo "$file" | grep -q "components/" && grep -q "createScreenTestWidget\|MaterialApp.*localizations" "$file" 2>/dev/null; then
        echo "   - Consider using createComponentTestWidget for component tests"
    fi
    
    if echo "$file" | grep -q "screens/" && grep -q "createTestWidget" "$file" 2>/dev/null; then
        echo "   - Consider using createScreenTestWidget for screen tests with localization"
    fi
    
    echo ""
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

echo "✅ Analysis complete! Follow the docs/TESTING_STANDARDS.md guide for detailed patterns."