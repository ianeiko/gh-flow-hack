#!/bin/bash
# Test scripts for ghflow-feature-implementer skill

set -e

# Source shared test utilities
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
SHARED_UTILS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")/shared"
source "$SHARED_UTILS_DIR/test_utils.sh"

# Setup cleanup trap
trap cleanup_test_artifacts EXIT

# Setup
echo "==================================================================="
echo "Testing ghflow-feature-implementer Scripts"
echo "==================================================================="

# Get skill directory
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

# Create test issue
ISSUE_NUMBER=$(create_test_issue "Add new feature for implementer test" "Test feature description")
echo "Created test issue #$ISSUE_NUMBER"

# Test 1: fetch_issue.sh
test_start "fetch_issue.sh - Fetches issue details"

SCRIPT="$SKILL_DIR/scripts/fetch_issue.sh"
if [ ! -f "$SCRIPT" ]; then
    fail "Script not found: $SCRIPT"
else
    OUTPUT=$(bash "$SCRIPT" "$ISSUE_NUMBER")

    if echo "$OUTPUT" | jq -e '.number' > /dev/null 2>&1; then
        pass "Issue data fetched successfully"

        FETCHED_NUMBER=$(echo "$OUTPUT" | jq -r .number)
        if [ "$FETCHED_NUMBER" = "$ISSUE_NUMBER" ]; then
            pass "Issue number matches"
        else
            fail "Issue number mismatch: Expected $ISSUE_NUMBER, got $FETCHED_NUMBER"
        fi
    else
        fail "Failed to fetch issue data. Output: $OUTPUT"
    fi
fi

# Test 2: create_branch.sh
test_start "create_branch.sh - Creates feature branch with proper naming"

SCRIPT="$SKILL_DIR/scripts/create_branch.sh"
if [ ! -f "$SCRIPT" ]; then
    fail "Script not found: $SCRIPT"
else
    OUTPUT=$(bash "$SCRIPT" "$ISSUE_NUMBER" "add-new-feature-$(date +%s)")
    # Extract branch name from last line
    BRANCH_NAME=$(echo "$OUTPUT" | tail -n 1)

    if [ -n "$BRANCH_NAME" ]; then
        TEST_BRANCHES+=("$BRANCH_NAME")
        pass "Branch created: $BRANCH_NAME"

        if [[ "$BRANCH_NAME" =~ ^feature/issue-[0-9]+-.*$ ]]; then
            pass "Branch name follows convention"
        else
            fail "Branch name doesn't follow convention: $BRANCH_NAME"
        fi

        CURRENT_BRANCH=$(git branch --show-current)
        if [ "$CURRENT_BRANCH" = "$BRANCH_NAME" ]; then
            pass "Switched to new branch"
        else
            fail "Not on new branch, current: $CURRENT_BRANCH"
        fi
    else
        fail "Failed to create branch"
    fi
fi

# Test 3: save_task.sh
test_start "save_task.sh - Creates task documentation"

SCRIPT="$SKILL_DIR/scripts/save_task.sh"
if [ ! -f "$SCRIPT" ]; then
    fail "Script not found: $SCRIPT"
else
    # Pass short task name
    bash "$SCRIPT" "$ISSUE_NUMBER" "Add New Feature"

    # Script sanitizes name -> add-new-feature
    TASK_FILE="docs/tasks/add-new-feature.md"
    if [ -f "$TASK_FILE" ]; then
        pass "Task file created: $TASK_FILE"

        if grep -q "Add New Feature" "$TASK_FILE"; then
            pass "Task template generated correctly"
        else
            fail "Task content incorrect"
        fi

        rm "$TASK_FILE"
    else
        fail "Task file not created at $TASK_FILE"
    fi
fi

# Summary
print_test_summary
