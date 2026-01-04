#!/bin/bash
# Test ghflow-pr-creator - uses current repo

set -e

# Load shared test utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
source "$REPO_ROOT/.claude/skills/shared/test_utils.sh"

echo "==================================================================="
echo "Testing ghflow-pr-creator Scripts"
echo "==================================================================="
echo "Repository: $REPO_FULL"
echo ""

ORIGINAL_BRANCH=$(git branch --show-current)
trap cleanup_test_artifacts EXIT

SKILL_DIR="$REPO_ROOT/.claude/skills/ghflow-pr-creator"

# Test 1: validate_branch.sh
test_start "validate_branch.sh - Validates branch naming"

if bash "$SKILL_DIR/scripts/validate_branch.sh" "feature/issue-123-add-feature" 2>/dev/null; then
    pass "Valid branch name accepted"
else
    fail "Valid branch name rejected"
fi

if bash "$SKILL_DIR/scripts/validate_branch.sh" "invalid-branch" 2>/dev/null; then
    fail "Invalid branch name accepted"
else
    pass "Invalid branch name rejected"
fi

# Test 2: commit_changes.sh
test_start "commit_changes.sh - Creates formatted commit"

TEST_ISSUE=$(create_test_issue "Test PR creator" "Testing commit")
TEST_BRANCH=$(create_test_branch "pr-creator")

echo "# Test change" >> README.md
git add README.md

bash "$SKILL_DIR/scripts/commit_changes.sh" "$TEST_ISSUE" "Add test feature"
COMMIT_MSG=$(git log -1 --pretty=%B)

if echo "$COMMIT_MSG" | grep -q "feat: Add test feature"; then
    pass "Commit message format correct"
else
    fail "Commit message format incorrect"
fi

if echo "$COMMIT_MSG" | grep -q "Closes #$TEST_ISSUE"; then
    pass "Issue reference included"
else
    fail "Issue reference missing"
fi

# Test 3: create_pr.sh
test_start "create_pr.sh - Creates PR"

git push -u origin "$TEST_BRANCH"

PR_TITLE="[TEST] Test PR"
PR_BODY="## Summary
Test PR"

PR_NUMBER=$(bash "$SKILL_DIR/scripts/create_pr.sh" "$TEST_ISSUE" "$PR_TITLE" "$PR_BODY" "main")

if [ -n "$PR_NUMBER" ]; then
    TEST_PRS+=("$PR_NUMBER")
    pass "PR #$PR_NUMBER created"
else
    fail "Failed to create PR"
fi

git checkout "$ORIGINAL_BRANCH" 2>/dev/null || git checkout main
print_test_summary
exit $?
