#!/bin/bash

# Integration Test Runner Script
# Run this script to execute integration tests with optional coverage

# Default: run all integration tests
TEST_PATH="integration_test/"
COVERAGE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --coverage)
            COVERAGE=true
            shift
            ;;
        *)
            TEST_PATH="integration_test/$1"
            shift
            ;;
    esac
done

echo "Running integration tests: $TEST_PATH"
echo "Coverage: $COVERAGE"
echo ""

# Build the test command
CMD="flutter test $TEST_PATH --reporter compact"

if [ "$COVERAGE" = true ]; then
    CMD="$CMD --coverage"
    echo "⚠️  Note: Integration test coverage is included in overall coverage calculation"
fi

# Run integration tests
eval $CMD

echo ""
echo "Integration tests completed!"