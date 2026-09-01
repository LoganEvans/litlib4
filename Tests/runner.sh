# FILENAME: Tests/runner.sh

#!/bin/bash

# Always execute from the project root, no matter where the script is called from
cd "$(dirname "$0")/.."

# Parse filters from CLI arguments
FILTERS=()
RUN_ALL=true

for arg in "$@"; do
    if [ "$arg" == "--all" ] || [ "$arg" == "-a" ]; then
        RUN_ALL=true
    elif [[ "$arg" == --glob=* ]]; then
        RUN_ALL=false
        IFS=',' read -ra ADDR <<< "${arg#--glob=}"
        for g in "${ADDR[@]}"; do
            FILTERS+=("$g")
        done
    elif [[ "$arg" == --filter=* ]]; then
        RUN_ALL=false
        IFS=',' read -ra ADDR <<< "${arg#--filter=}"
        for f in "${ADDR[@]}"; do
            FILTERS+=("$f")
        done
    else
        RUN_ALL=false
        FILTERS+=("$arg")
    fi
done

echo "=============================================="
echo "         LITLIB4 DYNAMIC TEST SUITE"
echo "=============================================="

# 1. Rebuild the CLI core
echo "Rebuilding CLI core to ensure test environment is up to date..."
if ! lake build Litlib.Core.CLI > /dev/null 2>&1; then
    echo -e "\033[31mFAIL: Build failed before tests could run. Check lake build output.\033[0m"
    lake build Litlib.Core.CLI
    exit 1
fi
echo "Build successful."

# 2. Compile test fixtures into Lake build cache locations
if [ -d "Tests/Fixtures" ]; then
    echo "Compiling test fixtures..."
    mkdir -p .lake/build/lib/lean/Tests/Fixtures
    mkdir -p .lake/build/lib/Tests/Fixtures
    for f in $(find Tests/Fixtures -type f -name "*.lean"); do
        rel="${f#Tests/Fixtures/}"
        dir=$(dirname "$rel")
        mkdir -p ".lake/build/lib/lean/Tests/Fixtures/$dir"
        mkdir -p ".lake/build/lib/Tests/Fixtures/$dir"
        stem=$(basename "$f" .lean)
        target1=".lake/build/lib/lean/Tests/Fixtures/${dir}/${stem}.olean"
        target2=".lake/build/lib/Tests/Fixtures/${dir}/${stem}.olean"
        lake env lean -R . -o "$target1" "$f" > /dev/null 2>&1
        cp "$target1" "$target2" 2>/dev/null || true
    done
fi
echo "----------------------------------------------"

FAIL_COUNT=0
PASS_COUNT=0
FAILED_TESTS=""

# Find test files (excluding fixtures and runner itself)
ALL_FILES=$(find Tests -type f -name "*.lean" ! -path "Tests/Fixtures/*" | sort)
TEST_FILES=()

for f in $ALL_FILES; do
    if [ "$RUN_ALL" = true ]; then
        TEST_FILES+=("$f")
    else
        for pattern in "${FILTERS[@]}"; do
            if [[ "$f" == *"$pattern"* ]] || [[ "$f" == $pattern ]]; then
                TEST_FILES+=("$f")
                break
            fi
        done
    fi
done

if [ ${#TEST_FILES[@]} -eq 0 ]; then
    echo "No test files matched the filter(s): ${FILTERS[*]}"
    exit 0
fi

# Run matched test files
for test_file in "${TEST_FILES[@]}"; do
    printf "Running %-50s ... " "$test_file"

    if lake env lean "$test_file" > /dev/null 2>&1; then
        echo -e "\033[32mPASS\033[0m"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo -e "\033[31mFAIL\033[0m"
        lake env lean "$test_file"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        FAILED_TESTS="$FAILED_TESTS\n  - $test_file"
    fi
done

echo "=============================================="
echo "Tests Passed: $PASS_COUNT"
echo "Tests Failed: $FAIL_COUNT"

if [ $FAIL_COUNT -gt 0 ]; then
    echo -e "\033[31mFailed Tests:\033[0m$FAILED_TESTS"
    exit 1
else
    echo -e "\033[32m✔ SUCCESS: All tests passed.\033[0m"
    exit 0
fi
