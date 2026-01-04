#!/bin/bash
# Test ghflow-issue-expander - uses current repo

set -e

# Load shared test utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
source "$REPO_ROOT/.claude/skills/shared/test_utils.sh"

echo "==================================================================="
echo "Testing ghflow-issue-expander Scripts"
echo "==================================================================="
echo "Repository: $REPO_FULL"
echo ""

ORIGINAL_BRANCH=$(git branch --show-current)
trap cleanup_test_artifacts EXIT

SKILL_DIR="$REPO_ROOT/.claude/skills/ghflow-issue-expander"

# Test 1: create_issue.sh
test_start "create_issue.sh - Creates issue with HF-required label"

ISSUE_TITLE="Test Feature Implementation"
ISSUE_BODY="## Problem
Test problem

## Requirements
- Test requirement"

ISSUE_NUMBER=$(bash "$SKILL_DIR/scripts/create_issue.sh" "$ISSUE_TITLE" "$ISSUE_BODY")

if [ -n "$ISSUE_NUMBER" ]; then
    TEST_ISSUES+=("$ISSUE_NUMBER")
    pass "Issue #$ISSUE_NUMBER created"

    ISSUE_DATA=$(gh issue view "$ISSUE_NUMBER" --json labels)
    if echo "$ISSUE_DATA" | jq -e '.labels[] | select(.name=="HF-required")' >/dev/null; then
        pass "HF-required label added"
    else
        fail "HF-required label not found"
    fi
else
    fail "Failed to create issue"
fi

# Test 2: save_issue.sh
test_start "save_issue.sh - Saves issue data"

BACKUP_STATE=""
if [ -f "$REPO_ROOT/.claude/workflow-state.md" ]; then
    BACKUP_STATE=$(cat "$REPO_ROOT/.claude/workflow-state.md")
fi

cat > "$REPO_ROOT/.claude/workflow-state.md" <<STATEOF
# Workflow State

## Current Issue
Number:
Title:
STATEOF

bash "$SKILL_DIR/scripts/save_issue.sh" "$ISSUE_NUMBER"

if grep -q "Number: $ISSUE_NUMBER" "$REPO_ROOT/.claude/workflow-state.md"; then
    pass "Issue number saved"
else
    fail "Issue number not saved"
fi

if [ -n "$BACKUP_STATE" ]; then
    echo "$BACKUP_STATE" > "$REPO_ROOT/.claude/workflow-state.md"
fi

git checkout "$ORIGINAL_BRANCH" 2>/dev/null || git checkout main
print_test_summary
exit $?
