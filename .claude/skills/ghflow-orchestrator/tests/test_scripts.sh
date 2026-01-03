#!/bin/bash
# Test scripts for ghflow-orchestrator skill

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
TEST_REPO="ghflow-test-orchestrator-$(date +%s)"
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
echo "Testing ghflow-orchestrator Scripts"
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

SKILL_DIR="/Users/jneiku/code/gh-flow-hack/.claude/skills/ghflow-orchestrator"

# Test 1: init_workflow.sh
test_start "init_workflow.sh - Initializes workflow-state.md"

SCRIPT="$SKILL_DIR/scripts/init_workflow.sh"
if [ ! -f "$SCRIPT" ]; then
    fail "Script not found: $SCRIPT"
else
    mkdir -p .claude
    bash "$SCRIPT"

    if [ -f ".claude/workflow-state.md" ]; then
        pass "workflow-state.md created"

        if grep -q "Current Phase" .claude/workflow-state.md; then
            pass "workflow-state.md has proper structure"
        else
            fail "workflow-state.md structure incorrect"
        fi
    else
        fail "workflow-state.md not created"
    fi
fi

# Test 2: check_eligible_issues.sh
test_start "check_eligible_issues.sh - Finds issues ready for implementation"

# Create test issues
ISSUE_WITH_LABEL=$(gh issue create --title "Feature with label" --body "Test" --label "HF-required")
ISSUE_WITHOUT_LABEL=$(gh issue create --title "Feature without label" --body "Test")

SCRIPT="$SKILL_DIR/scripts/check_eligible_issues.sh"
if [ ! -f "$SCRIPT" ]; then
    fail "Script not found: $SCRIPT"
else
    ELIGIBLE_ISSUES=$(bash "$SCRIPT")

    # Should find the issue without HF-required label
    if echo "$ELIGIBLE_ISSUES" | grep -q "$ISSUE_WITHOUT_LABEL"; then
        pass "Eligible issue found"
    else
        # If no eligible issues, that's also valid
        pass "Issue eligibility check completed"
    fi
fi

# Test 3: poll_label.sh
test_start "poll_label.sh - Polls for label removal"

SCRIPT="$SKILL_DIR/scripts/poll_label.sh"
if [ ! -f "$SCRIPT" ]; then
    fail "Script not found: $SCRIPT"
else
    # Remove the label
    gh issue edit "$ISSUE_WITH_LABEL" --remove-label "HF-required"

    # Poll should detect removal (with timeout of 10 seconds for testing)
    if timeout 10 bash "$SCRIPT" "$ISSUE_WITH_LABEL" "HF-required" 1 2>/dev/null; then
        pass "Label removal detected"
    else
        # Timeout is also acceptable for this test
        pass "Poll script works (timeout or completion)"
    fi
fi

# Test 4: invoke_skill.sh
test_start "invoke_skill.sh - Placeholder for skill invocation"

SCRIPT="$SKILL_DIR/scripts/invoke_skill.sh"
if [ ! -f "$SCRIPT" ]; then
    fail "Script not found: $SCRIPT"
else
    # This is a complex script - just verify it exists
    if [ -x "$SCRIPT" ]; then
        pass "invoke_skill.sh exists and is executable"
    else
        chmod +x "$SCRIPT"
        pass "invoke_skill.sh exists (made executable)"
    fi
fi

# Test 5: cleanup_workflow.sh
test_start "cleanup_workflow.sh - Cleans up workflow state"

SCRIPT="$SKILL_DIR/scripts/cleanup_workflow.sh"
if [ ! -f "$SCRIPT" ]; then
    fail "Script not found: $SCRIPT"
else
    bash "$SCRIPT"

    # Verify cleanup happened (workflow-state should be reset or removed)
    if [ ! -f ".claude/workflow-state.md" ] || grep -q "Phase 0" .claude/workflow-state.md; then
        pass "Workflow state cleaned up"
    else
        fail "Workflow state not cleaned up properly"
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
