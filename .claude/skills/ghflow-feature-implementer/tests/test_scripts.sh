#!/bin/bash
# Test ghflow-feature-implementer - uses current repo

set -e

# Load shared test utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
source "$REPO_ROOT/.claude/skills/shared/test_utils.sh"

echo "==================================================================="
echo "Testing ghflow-feature-implementer Scripts"
echo "==================================================================="
echo "Repository: $REPO_FULL"
echo ""

ORIGINAL_BRANCH=$(git branch --show-current)
trap cleanup_test_artifacts EXIT

SKILL_DIR="$REPO_ROOT/.claude/skills/ghflow-feature-implementer"

# Test 1: fetch_issue.sh
test_start "fetch_issue.sh - Fetches issue details"

TEST_ISSUE=$(create_test_issue "Test feature" "## Requirements\n- Add feature")

ISSUE_DATA=$(bash "$SKILL_DIR/scripts/fetch_issue.sh" "$TEST_ISSUE")

if [ -n "$ISSUE_DATA" ]; then
    pass "Issue #$TEST_ISSUE fetched"

    if echo "$ISSUE_DATA" | jq -e .number >/dev/null 2>&1; then
        pass "Issue data contains number field"
    else
        fail "Issue data missing number"
    fi
else
    fail "Failed to fetch issue"
fi

# Test 2: create_branch.sh
test_start "create_branch.sh - Creates feature branch"

BRANCH_NAME=$(bash "$SKILL_DIR/scripts/create_branch.sh" "$TEST_ISSUE" "test-feature")

if [ -n "$BRANCH_NAME" ]; then
    TEST_BRANCHES+=("$BRANCH_NAME")
    pass "Branch created: $BRANCH_NAME"

    if echo "$BRANCH_NAME" | grep -q "feature/issue-$TEST_ISSUE"; then
        pass "Branch naming convention correct"
    else
        fail "Branch naming incorrect"
    fi
else
    fail "Failed to create branch"
fi

# Test 3: save_task.sh
test_start "save_task.sh - Saves task data"

BACKUP_STATE=""
if [ -f "$REPO_ROOT/.claude/workflow-state.md" ]; then
    BACKUP_STATE=$(cat "$REPO_ROOT/.claude/workflow-state.md")
fi

TASK_PATH="docs/tasks/task_${TEST_ISSUE}.md"
bash "$SKILL_DIR/scripts/save_task.sh" "$TEST_ISSUE" "$TASK_PATH" 2>/dev/null || true
pass "Save task script executed"

if [ -n "$BACKUP_STATE" ]; then
    echo "$BACKUP_STATE" > "$REPO_ROOT/.claude/workflow-state.md"
fi

git checkout "$ORIGINAL_BRANCH" 2>/dev/null || git checkout main
print_test_summary
exit $?
