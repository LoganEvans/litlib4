#!/bin/bash
# FILENAME: Tests/test_all.sh

# Always execute from the project root, no matter where the script is called from
cd "$(dirname "$0")/.."

echo "=============================================="
echo "         LITLIB4 DYNAMIC TEST SUITE"
echo "=============================================="

# IMPORTANT: Rebuild the CLI to update the .olean caches for the tests
echo "Rebuilding CLI core to ensure test environment is up to date..."
if ! lake build Litlib.Core.CLI > /dev/null 2>&1; then
    echo -e "\033[31mFAIL: Build failed before tests could run. Check lake build output.\033[0m"
    lake build Litlib.Core.CLI
    exit 1
fi
echo "Build successful."
echo "----------------------------------------------"

FAIL_COUNT=0
PASS_COUNT=0
FAILED_TESTS=""

# Dynamically find all Lean test files
for test_file in $(find Tests -type f -name "*.lean" | sort); do
    # Print the file name and pad with spaces for alignment
    printf "Running %-40s ... " "$test_file"

    # Run the test, hiding standard output unless it fails
    if lake env lean "$test_file" > /dev/null 2>&1; then
        echo -e "\033[32mPASS\033[0m"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo -e "\033[31mFAIL\033[0m"
        # Run it again without swallowing the output so the user can see the Lean compiler error
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
