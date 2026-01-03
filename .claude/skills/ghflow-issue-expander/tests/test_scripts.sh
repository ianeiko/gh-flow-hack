#!/bin/bash
# Test scripts for ghflow-issue-expander skill

set -e

# Source shared test utilities
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
SHARED_UTILS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")/shared"
source "$SHARED_UTILS_DIR/test_utils.sh"

# Setup cleanup trap
trap cleanup_test_artifacts EXIT

# Setup
echo "==================================================================="
echo "Testing ghflow-issue-expander Scripts"
echo "==================================================================="

# Get skill directory
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

# Test 1: create_issue.sh
test_start "create_issue.sh - Creates issue with proper format and labels"

ISSUE_TITLE="Test Feature Implementation $(date +%s)"
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
    ISSUE_NUMBER=$(bash "$SCRIPT" "$ISSUE_TITLE" "$ISSUE_BODY" | grep -o '[0-9]\+$')

    if [ -n "$ISSUE_NUMBER" ]; then
        TEST_ISSUES+=("$ISSUE_NUMBER")
        pass "Issue #$ISSUE_NUMBER created successfully"

        # Verify issue exists
        ISSUE_DATA=$(gh issue view "$ISSUE_NUMBER" --json title,labels)
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
        # If extraction failed, script output might be verbose
        fail "Failed to extract issue number or create issue"
    fi
fi

# Test 2: save_issue.sh
test_start "save_issue.sh - Saves issue data"

SCRIPT="$SKILL_DIR/scripts/save_issue.sh"
if [ ! -f "$SCRIPT" ]; then
    fail "Script not found: $SCRIPT"
else
    # Save issue data via stdin
    echo "$ISSUE_BODY" | bash "$SCRIPT" "$ISSUE_NUMBER"

    # Verify file created
    OUTPUT_FILE="docs/issues/issue_${ISSUE_NUMBER}.md"

    if [ -f "$OUTPUT_FILE" ]; then
        pass "Issue file created at $OUTPUT_FILE"

        # Verify content
        if grep -q "Problem Statement" "$OUTPUT_FILE"; then
            pass "Issue content saved correctly"
        else
            fail "Issue content check failed"
        fi

        rm "$OUTPUT_FILE"
    else
        fail "Issue file not found at $OUTPUT_FILE"
    fi
fi

# Summary
print_test_summary
