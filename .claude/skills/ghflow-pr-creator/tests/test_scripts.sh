#!/bin/bash
# Test scripts for ghflow-pr-creator skill

set -e

# Source shared test utilities
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
SHARED_UTILS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")/shared"
source "$SHARED_UTILS_DIR/test_utils.sh"

# Setup cleanup trap
trap cleanup_test_artifacts EXIT

# Setup
echo "==================================================================="
echo "Testing ghflow-pr-creator Scripts"
echo "==================================================================="

# Get skill directory
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

# Create a test issue for PRs to reference
ISSUE_NUMBER=$(create_test_issue "Test Issue for PR Creator" "This is a test issue")
echo "Created test issue #$ISSUE_NUMBER"

# Test 1: validate_branch.sh
test_start "validate_branch.sh - Validates branch naming convention"

SCRIPT="$SKILL_DIR/scripts/validate_branch.sh"
if [ ! -f "$SCRIPT" ]; then
    fail "Script not found: $SCRIPT"
else
    # Test valid branch name
    if bash "$SCRIPT" "feature/issue-$ISSUE_NUMBER-add-feature" 2>/dev/null; then
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
BRANCH_NAME=$(create_test_branch "pr-creator-test-$ISSUE_NUMBER")
echo "Test change $(date +%s)" >> "test_file_pr_creator.md"
git add "test_file_pr_creator.md"

SCRIPT="$SKILL_DIR/scripts/commit_changes.sh"
if [ ! -f "$SCRIPT" ]; then
    fail "Script not found: $SCRIPT"
else
    # Make commit
    bash "$SCRIPT" "$ISSUE_NUMBER" "feat" "Add test feature"

    # Verify commit message format
    COMMIT_MSG=$(git log -1 --pretty=%B)

    if echo "$COMMIT_MSG" | grep -q "feat: Add test feature"; then
        pass "Commit message format correct"
    else
        fail "Commit message format incorrect: $COMMIT_MSG"
    fi

    if echo "$COMMIT_MSG" | grep -q "Closes #$ISSUE_NUMBER"; then
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
git push -u origin "$BRANCH_NAME"

SCRIPT="$SKILL_DIR/scripts/create_pr.sh"
if [ ! -f "$SCRIPT" ]; then
    fail "Script not found: $SCRIPT"
else
    # Create PR (Fixing argument parsing from previous failure)
    PR_TITLE="[TEST] Add test feature $(date +%s)"
    PR_BODY="## Summary
- Test change 1
- Test change 2

## Test Plan
- [x] Manual testing

🤖 Generated with [Claude Code](https://claude.com/claude-code)"

    PR_OUTPUT=$(bash "$SCRIPT" "$ISSUE_NUMBER" "$PR_TITLE" "$PR_BODY" "main")

    # Extract PR number from output (last line contains number|url)
    LAST_LINE=$(echo "$PR_OUTPUT" | tail -n 1)
    PR_NUMBER=$(echo "$LAST_LINE" | cut -d'|' -f1)

    if [ -n "$PR_NUMBER" ] && [[ "$PR_NUMBER" =~ ^[0-9]+$ ]]; then
        TEST_PRS+=("$PR_NUMBER")
        pass "PR #$PR_NUMBER created successfully"

        # Verify PR data
        PR_DATA=$(gh pr view "$PR_NUMBER" --json number,title,body)
        PR_TITLE_ACTUAL=$(echo "$PR_DATA" | jq -r .title)

        if [ "$PR_TITLE_ACTUAL" = "$PR_TITLE" ]; then
            pass "PR title matches"
        else
            fail "PR title mismatch: Expected '$PR_TITLE', got '$PR_TITLE_ACTUAL'"
        fi

        PR_BODY_ACTUAL=$(echo "$PR_DATA" | jq -r .body)
        if echo "$PR_BODY_ACTUAL" | grep -q "#$ISSUE_NUMBER"; then
            pass "PR references issue #$ISSUE_NUMBER"
        else
            fail "PR doesn't reference issue"
        fi
    else
        fail "Failed to create PR or extract number. Output: $PR_OUTPUT"
    fi
fi

# Summary
print_test_summary
