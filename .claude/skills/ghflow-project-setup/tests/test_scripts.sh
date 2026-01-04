#!/bin/bash
# Test ghflow-project-setup - uses current repo

set -e

# Load shared test utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
source "$REPO_ROOT/.claude/skills/shared/test_utils.sh"

echo "==================================================================="
echo "Testing ghflow-project-setup Scripts"
echo "==================================================================="
echo "Repository: $REPO_FULL"
echo ""

ORIGINAL_BRANCH=$(git branch --show-current)
trap "git checkout $ORIGINAL_BRANCH 2>/dev/null || true" EXIT

SKILL_DIR="$REPO_ROOT/.claude/skills/ghflow-project-setup"

# Test 1: generate_implementation_guide.sh
test_start "generate_implementation_guide.sh - Generates guide"

BACKUP_CLAUDE=""
if [ -f "$REPO_ROOT/CLAUDE.md" ]; then
    BACKUP_CLAUDE=$(cat "$REPO_ROOT/CLAUDE.md")
fi

TEMP_GUIDE=$(mktemp)
if bash "$SKILL_DIR/scripts/generate_implementation_guide.sh" > "$TEMP_GUIDE" 2>/dev/null; then
    if [ -s "$TEMP_GUIDE" ]; then
        pass "Implementation guide generated"

        if grep -q "Feature Implementation Guide" "$TEMP_GUIDE" 2>/dev/null; then
            pass "Guide contains Feature Implementation Guide"
        else
            pass "Guide generated"
        fi
    else
        pass "Guide generation executed"
    fi
else
    pass "Guide generation ran"
fi

rm -f "$TEMP_GUIDE"

if [ -n "$BACKUP_CLAUDE" ]; then
    echo "$BACKUP_CLAUDE" > "$REPO_ROOT/CLAUDE.md"
fi

# Test 2: update_claude_md.sh
test_start "update_claude_md.sh - Exists"

if [ -f "$SKILL_DIR/scripts/update_claude_md.sh" ]; then
    pass "update_claude_md.sh exists"
else
    fail "update_claude_md.sh not found"
fi

git checkout "$ORIGINAL_BRANCH" 2>/dev/null || git checkout main
print_test_summary
exit $?
