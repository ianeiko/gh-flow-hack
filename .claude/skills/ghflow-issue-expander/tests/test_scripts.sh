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
    # The script outputs the issue number on the last line (implied by previous test logic)
    # The script prints "✅ ..." to stderr and number to stdout?
    # Let's check script content again. Yes: `echo "$issue_number"` at end.

    ISSUE_NUMBER=$(bash "$SCRIPT" "$ISSUE_TITLE" "$ISSUE_BODY")

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
        fail "Failed to create issue"
    fi
fi

# Test 2: save_issue.sh
test_start "save_issue.sh - Saves issue data"

SCRIPT="$SKILL_DIR/scripts/save_issue.sh"
if [ ! -f "$SCRIPT" ]; then
    fail "Script not found: $SCRIPT"
else
    # Save issue data
    # Pass input via stdin to match script expectations for "content_file_or_stdin"
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

        # Use shared utils cleanup, but we also want to delete this specific file
        # The shared cleanup doesn't delete docs/issues files.
        rm "$OUTPUT_FILE"
    else
        fail "Issue file not found at $OUTPUT_FILE"
    fi

    # Note: Previous test checked workflow-state.md update.
    # Current script does not update workflow-state.md, so skipping that check.
fi

# Summary
print_test_summary
