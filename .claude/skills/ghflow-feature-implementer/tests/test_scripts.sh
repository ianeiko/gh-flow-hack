#!/bin/bash
# Test scripts for ghflow-feature-implementer skill

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test repository name
TEST_REPO="ghflow-test-feature-impl-$(date +%s)"
REPO_OWNER=$(gh api user -q .login)

# Helper functions
pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((TESTS_PASSED++))
}

fail() {
    echo -e "${RED}✗${NC} $1"
    ((TESTS_FAILED++))
}

test_start() {
    echo ""
    echo "-------------------------------------------------------------------"
    echo "TEST: $1"
    echo "-------------------------------------------------------------------"
    ((TESTS_RUN++))
}

cleanup() {
    echo ""
    echo "Cleaning up test repository: $TEST_REPO"
    gh repo delete "$REPO_OWNER/$TEST_REPO" --yes 2>/dev/null || true
}

# Setup
echo "==================================================================="
echo "Testing ghflow-feature-implementer Scripts"
echo "==================================================================="

# Create test repository with issue
echo ""
echo "Creating test repository: $TEST_REPO"
gh repo create "$TEST_REPO" --public --clone
cd "$TEST_REPO"
git config user.name "Test User"
git config user.email "test@example.com"
echo "# Test Repo" > README.md
git add README.md
git commit -m "Initial commit"
git push -u origin main

# Create test issue
ISSUE_NUMBER=$(gh issue create --title "Add new feature" --body "Test feature description")

trap cleanup EXIT

SKILL_DIR="/Users/jneiku/code/gh-flow-hack/.claude/skills/ghflow-feature-implementer"

# Test 1: fetch_issue.sh
test_start "fetch_issue.sh - Fetches issue details"

SCRIPT="$SKILL_DIR/scripts/fetch_issue.sh"
if [ ! -f "$SCRIPT" ]; then
    fail "Script not found: $SCRIPT"
else
    ISSUE_DATA=$(bash "$SCRIPT" "$ISSUE_NUMBER")

    if echo "$ISSUE_DATA" | jq -e '.number' > /dev/null 2>&1; then
        pass "Issue data fetched successfully"

        FETCHED_NUMBER=$(echo "$ISSUE_DATA" | jq -r .number)
        if [ "$FETCHED_NUMBER" = "$ISSUE_NUMBER" ]; then
            pass "Issue number matches"
        else
            fail "Issue number mismatch"
        fi
    else
        fail "Failed to fetch issue data"
    fi
fi

# Test 2: create_branch.sh
test_start "create_branch.sh - Creates feature branch with proper naming"

SCRIPT="$SKILL_DIR/scripts/create_branch.sh"
if [ ! -f "$SCRIPT" ]; then
    fail "Script not found: $SCRIPT"
else
    BRANCH_NAME=$(bash "$SCRIPT" "$ISSUE_NUMBER" "add-new-feature")

    if [ -n "$BRANCH_NAME" ]; then
        pass "Branch created: $BRANCH_NAME"

        # Verify branch name format
        if [[ "$BRANCH_NAME" =~ ^feature/issue-[0-9]+-.*$ ]]; then
            pass "Branch name follows convention"
        else
            fail "Branch name doesn't follow convention"
        fi

        # Verify we're on the new branch
        CURRENT_BRANCH=$(git branch --show-current)
        if [ "$CURRENT_BRANCH" = "$BRANCH_NAME" ]; then
            pass "Switched to new branch"
        else
            fail "Not on new branch"
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
    mkdir -p docs/tasks
    TASK_CONTENT="# Task: Add New Feature

## Objective
Implement new feature

## Implementation Steps
1. Step 1
2. Step 2

## Acceptance Criteria
- [ ] Feature works
"

    bash "$SCRIPT" "$ISSUE_NUMBER" "$TASK_CONTENT"

    TASK_FILE="docs/tasks/issue-${ISSUE_NUMBER}.md"
    if [ -f "$TASK_FILE" ]; then
        pass "Task file created: $TASK_FILE"

        if grep -q "Add New Feature" "$TASK_FILE"; then
            pass "Task content saved correctly"
        else
            fail "Task content incorrect"
        fi
    else
        fail "Task file not created"
    fi
fi

# Summary
echo ""
echo "==================================================================="
echo "Test Summary"
echo "==================================================================="
echo "Tests run:    $TESTS_RUN"
echo "Tests passed: $TESTS_PASSED"
echo "Tests failed: $TESTS_FAILED"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 ALL TESTS PASSED!${NC}"
    exit 0
else
    echo -e "${RED}❌ SOME TESTS FAILED${NC}"
    exit 1
fi
