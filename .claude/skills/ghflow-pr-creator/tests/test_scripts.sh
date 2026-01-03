#!/bin/bash
# Test scripts for ghflow-pr-creator skill

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
TEST_REPO="ghflow-test-pr-creator-$(date +%s)"
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
echo "Testing ghflow-pr-creator Scripts"
echo "==================================================================="

# Create test repository
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

trap cleanup EXIT

SKILL_DIR="/Users/jneiku/code/gh-flow-hack/.claude/skills/ghflow-pr-creator"

# Test 1: validate_branch.sh
test_start "validate_branch.sh - Validates branch naming convention"

SCRIPT="$SKILL_DIR/scripts/validate_branch.sh"
if [ ! -f "$SCRIPT" ]; then
    fail "Script not found: $SCRIPT"
else
    # Test valid branch name
    if bash "$SCRIPT" "feature/issue-123-add-feature" 2>/dev/null; then
        pass "Valid branch name accepted"
    else
        fail "Valid branch name rejected"
    fi

    # Test invalid branch name (should fail)
    if bash "$SCRIPT" "invalid-branch-name" 2>/dev/null; then
        fail "Invalid branch name accepted"
    else
        pass "Invalid branch name rejected"
    fi
fi

# Test 2: commit_changes.sh
test_start "commit_changes.sh - Creates properly formatted commit"

# Create a feature branch
git checkout -b feature/issue-42-test-feature
echo "Test change" >> README.md
git add README.md

SCRIPT="$SKILL_DIR/scripts/commit_changes.sh"
if [ ! -f "$SCRIPT" ]; then
    fail "Script not found: $SCRIPT"
else
    # Make commit
    bash "$SCRIPT" 42 "Add test feature"

    # Verify commit message format
    COMMIT_MSG=$(git log -1 --pretty=%B)

    if echo "$COMMIT_MSG" | grep -q "feat: Add test feature"; then
        pass "Commit message format correct"
    else
        fail "Commit message format incorrect"
    fi

    if echo "$COMMIT_MSG" | grep -q "Closes #42"; then
        pass "Issue reference included in commit"
    else
        fail "Issue reference missing from commit"
    fi

    if echo "$COMMIT_MSG" | grep -q "Generated with.*Claude Code"; then
        pass "Claude Code attribution included"
    else
        fail "Claude Code attribution missing"
    fi
fi

# Test 3: create_pr.sh
test_start "create_pr.sh - Creates PR with proper format"

# Push feature branch
git push -u origin feature/issue-42-test-feature

SCRIPT="$SKILL_DIR/scripts/create_pr.sh"
if [ ! -f "$SCRIPT" ]; then
    fail "Script not found: $SCRIPT"
else
    # Create PR
    PR_TITLE="Add test feature"
    PR_BODY="## Summary
- Test change 1
- Test change 2

## Test Plan
- [x] Manual testing

🤖 Generated with [Claude Code](https://claude.com/claude-code)"

    PR_NUMBER=$(bash "$SCRIPT" 42 "$PR_TITLE" "$PR_BODY" "main")

    if [ -n "$PR_NUMBER" ]; then
        pass "PR #$PR_NUMBER created successfully"

        # Verify PR data
        PR_DATA=$(gh pr view "$PR_NUMBER" --json number,title,body)
        PR_TITLE_ACTUAL=$(echo "$PR_DATA" | jq -r .title)

        if [ "$PR_TITLE_ACTUAL" = "$PR_TITLE" ]; then
            pass "PR title matches"
        else
            fail "PR title mismatch"
        fi

        # Check if PR references issue
        PR_BODY_ACTUAL=$(echo "$PR_DATA" | jq -r .body)
        if echo "$PR_BODY_ACTUAL" | grep -q "#42"; then
            pass "PR references issue #42"
        else
            fail "PR doesn't reference issue"
        fi
    else
        fail "Failed to create PR"
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
