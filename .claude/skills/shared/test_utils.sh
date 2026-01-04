#!/bin/bash
# Shared test utilities for all ghflow skill tests

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters (global)
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Current repo info (set once at start)
REPO_OWNER=$(gh api user -q .login 2>/dev/null || echo "unknown")
REPO_NAME=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" || echo "gh-flow-hack")
REPO_FULL="${REPO_OWNER}/${REPO_NAME}"

# Capture starting branch
START_BRANCH=$(git branch --show-current)

# Test artifact tracking (for cleanup)
declare -a TEST_BRANCHES=()
declare -a TEST_ISSUES=()
declare -a TEST_PRS=()

# Helper functions (fixed for set -e compatibility)
pass() {
    echo -e "${GREEN}✓${NC} $1"
    : $((TESTS_PASSED++))  # Prefix with : to avoid set -e exit
}

fail() {
    echo -e "${RED}✗${NC} $1"
    : $((TESTS_FAILED++))
}

test_start() {
    echo ""
    echo "-------------------------------------------------------------------"
    echo "TEST: $1"
    echo "-------------------------------------------------------------------"
    : $((TESTS_RUN++))
}

# Create test branch with unique name
create_test_branch() {
    local base_name="$1"
    local timestamp=$(date +%s)
    local branch_name="test/${base_name}-${timestamp}"

    # Create from current branch (START_BRANCH) instead of main. Suppress output.
    git checkout -b "$branch_name" "$START_BRANCH" >/dev/null 2>&1 || git checkout -b "$branch_name" >/dev/null 2>&1
    TEST_BRANCHES+=("$branch_name")
    echo "$branch_name"
}

# Create test issue with [TEST] prefix
create_test_issue() {
    local title="$1"
    local body="$2"

    local issue_num=$(gh issue create \
        --title "[TEST] $title" \
        --body "$body" \
        --label "HF-required" \
        | grep -o '[0-9]*$')

    TEST_ISSUES+=("$issue_num")
    echo "$issue_num"
}

# Cleanup all test artifacts
cleanup_test_artifacts() {
    echo ""
    echo "-------------------------------------------------------------------"
    echo "Cleaning up test artifacts"
    echo "-------------------------------------------------------------------"

    # Switch back to start branch before cleanup
    if [ -n "$START_BRANCH" ]; then
        git checkout "$START_BRANCH" >/dev/null 2>&1 || true
    else
        git checkout main >/dev/null 2>&1 || true
    fi

    # Close test PRs
    for pr in "${TEST_PRS[@]}"; do
        echo "Closing test PR #$pr"
        gh pr close "$pr" 2>/dev/null || true
    done

    # Close test issues
    for issue in "${TEST_ISSUES[@]}"; do
        echo "Closing test issue #$issue"
        gh issue close "$issue" 2>/dev/null || true
    done

    # Delete test branches (local and remote)
    for branch in "${TEST_BRANCHES[@]}"; do
        echo "Deleting test branch: $branch"
        git branch -D "$branch" 2>/dev/null || true
        git push origin --delete "$branch" 2>/dev/null || true
    done

    echo "✓ Cleanup complete"
}

# Print test summary
print_test_summary() {
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
        return 0
    else
        echo -e "${RED}❌ SOME TESTS FAILED${NC}"
        return 1
    fi
}
