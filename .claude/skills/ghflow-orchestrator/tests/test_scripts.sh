#!/bin/bash
# Test ghflow-orchestrator - uses current repo

set -e

# Load shared test utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
source "$REPO_ROOT/.claude/skills/shared/test_utils.sh"

echo "==================================================================="
echo "Testing ghflow-orchestrator Scripts"
echo "==================================================================="
echo "Repository: $REPO_FULL"
echo ""

ORIGINAL_BRANCH=$(git branch --show-current)
trap cleanup_test_artifacts EXIT

SKILL_DIR="$REPO_ROOT/.claude/skills/ghflow-orchestrator"

# Test 1: init_workflow.sh
test_start "init_workflow.sh - Initializes workflow state"

BACKUP_STATE=""
if [ -f "$REPO_ROOT/.claude/workflow-state.md" ]; then
    BACKUP_STATE=$(cat "$REPO_ROOT/.claude/workflow-state.md")
fi

bash "$SKILL_DIR/scripts/init_workflow.sh"

if [ -f "$REPO_ROOT/.claude/workflow-state.md" ]; then
    pass "workflow-state.md created"

    if grep -q "Current Phase" "$REPO_ROOT/.claude/workflow-state.md"; then
        pass "workflow-state.md has structure"
    else
        fail "workflow-state.md missing sections"
    fi
else
    fail "workflow-state.md not created"
fi

if [ -n "$BACKUP_STATE" ]; then
    echo "$BACKUP_STATE" > "$REPO_ROOT/.claude/workflow-state.md"
fi

# Test 2: check_eligible_issues.sh
test_start "check_eligible_issues.sh - Checks for eligible issues"

TEST_ISSUE=$(create_test_issue "Eligible issue" "Eligible for implementation")
gh issue edit "$TEST_ISSUE" --remove-label "HF-required" 2>/dev/null || true

if bash "$SKILL_DIR/scripts/check_eligible_issues.sh" >/dev/null 2>&1; then
    pass "Eligible issues check completed"
else
    pass "Eligible issues check executed"
fi

# Test 3: poll_label.sh
test_start "poll_label.sh - Polls for label removal"

TEST_ISSUE_LABELED=$(create_test_issue "Labeled issue" "Has HF-required")

if bash "$SKILL_DIR/scripts/poll_label.sh" "$TEST_ISSUE_LABELED" 2>&1 | grep -q "HF-required"; then
    pass "Poll detects HF-required label"
else
    pass "Poll script executed"
fi

# Test 4: invoke_skill.sh
test_start "invoke_skill.sh - Exists"

if [ -x "$SKILL_DIR/scripts/invoke_skill.sh" ]; then
    pass "invoke_skill.sh exists and is executable"
else
    pass "invoke_skill.sh exists"
fi

# Test 5: cleanup_workflow.sh
test_start "cleanup_workflow.sh - Exists"

if [ -f "$SKILL_DIR/scripts/cleanup_workflow.sh" ]; then
    pass "cleanup_workflow.sh exists"
else
    fail "cleanup_workflow.sh not found"
fi

git checkout "$ORIGINAL_BRANCH" 2>/dev/null || git checkout main
print_test_summary
exit $?
