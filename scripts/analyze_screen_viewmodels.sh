#!/bin/bash

TOTAL_ISSUES=0

echo "🧭 Checking screen/viewmodel consistency..."
echo "==========================================="

report_issue() {
    local message=$1
    local file=$2

    echo "❌ $message"
    echo "   $file"
    echo ""
    ((TOTAL_ISSUES++))
}

screen_files=$(find lib/features -path "*/demo/*" -prune -o -name "*_screen.dart" -print | sort)

for file in $screen_files; do
    if ! grep -q "required this.viewModel" "$file"; then
        report_issue "Screen is missing constructor injection for viewModel" "$file"
    fi

    if ! grep -Eq "final [A-Za-z0-9_]+ViewModelContract viewModel;" "$file"; then
        report_issue "Screen should type its viewModel field as a *ViewModelContract" "$file"
    fi

    if grep -Eq "context\.(push|pushNamed|go|goNamed|pop)\(" "$file"; then
        report_issue "Screen should delegate navigation through the viewModel" "$file"
    fi

    if grep -Eq "\b[A-Za-z0-9_]*ViewModel\(" "$file"; then
        report_issue "Screen should not construct a concrete ViewModel directly" "$file"
    fi
done

view_model_files=$(find lib/features -path "*/demo/*" -prune -o -name "*_view_model.dart" -print | sort)

for file in $view_model_files; do
    if ! grep -q "ScreenViewModelContract" "$file"; then
        report_issue "ViewModel contract should implement ScreenViewModelContract" "$file"
    fi

    if ! grep -q "ViewModelContract" "$file"; then
        report_issue "ViewModel file should declare a *ViewModelContract" "$file"
    fi
done

echo "==========================================="
if [ "$TOTAL_ISSUES" -gt 0 ]; then
    echo "❌ Found $TOTAL_ISSUES screen/viewmodel consistency issue(s)"
    echo ""
    echo "💡 See docs/AGENTS.md for the standard pattern"
    exit 1
fi

echo "✅ Screen/viewmodel consistency checks passed"
