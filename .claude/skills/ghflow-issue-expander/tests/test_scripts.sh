#!/bin/bash
# Test scripts for ghflow-issue-expander skill

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

# Test repository name (will be created and deleted)
TEST_REPO="ghflow-test-issue-expander-$(date +%s)"
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
echo "Testing ghflow-issue-expander Scripts"
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

# Register cleanup trap
trap cleanup EXIT

# Get the base directory for scripts
SKILL_DIR="/Users/jneiku/code/gh-flow-hack/.claude/skills/ghflow-issue-expander"

# Test 1: create_issue.sh
test_start "create_issue.sh - Creates issue with proper format and labels"

ISSUE_TITLE="Test Feature Implementation"
ISSUE_BODY="## Problem Statement
This is a test problem.

## User Story
As a user, I want to test.

## Requirements
- Requirement 1

## Acceptance Criteria
- [ ] Test passes

## Test Plan
- Test manually"

SCRIPT="$SKILL_DIR/scripts/create_issue.sh"
if [ ! -f "$SCRIPT" ]; then
    fail "Script not found: $SCRIPT"
else
    # Create issue
    ISSUE_NUMBER=$(bash "$SCRIPT" "$ISSUE_TITLE" "$ISSUE_BODY")

    if [ -n "$ISSUE_NUMBER" ]; then
        pass "Issue #$ISSUE_NUMBER created successfully"

        # Verify issue exists
        ISSUE_DATA=$(gh issue view "$ISSUE_NUMBER" --json number,title,body,labels)
        ISSUE_TITLE_ACTUAL=$(echo "$ISSUE_DATA" | jq -r .title)

        if [ "$ISSUE_TITLE_ACTUAL" = "$ISSUE_TITLE" ]; then
            pass "Issue title matches"
        else
            fail "Issue title mismatch: expected '$ISSUE_TITLE', got '$ISSUE_TITLE_ACTUAL'"
        fi

        # Check for HF-required label
        HAS_LABEL=$(echo "$ISSUE_DATA" | jq -r '.labels[] | select(.name=="HF-required") | .name')
        if [ "$HAS_LABEL" = "HF-required" ]; then
            pass "HF-required label added"
        else
            fail "HF-required label not found"
        fi
    else
        fail "Failed to create issue"
    fi
fi

# Test 2: save_issue.sh
test_start "save_issue.sh - Saves issue data to workflow-state.md"

SCRIPT="$SKILL_DIR/scripts/save_issue.sh"
if [ ! -f "$SCRIPT" ]; then
    fail "Script not found: $SCRIPT"
else
    # Create workflow-state.md
    mkdir -p .claude
    cat > .claude/workflow-state.md <<EOF
# Workflow State

## Current Phase
Phase 0: Initialization

## Current Issue
Number:
Title:
URL:

## Current PR
Number:
URL:

## Current Task
Path:
EOF

    # Save issue data
    bash "$SCRIPT" "$ISSUE_NUMBER"

    # Verify workflow-state.md updated
    if grep -q "Number: $ISSUE_NUMBER" .claude/workflow-state.md; then
        pass "Issue number saved to workflow-state.md"
    else
        fail "Issue number not found in workflow-state.md"
    fi

    if grep -q "Title: $ISSUE_TITLE" .claude/workflow-state.md; then
        pass "Issue title saved to workflow-state.md"
    else
        fail "Issue title not found in workflow-state.md"
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
