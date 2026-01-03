#!/bin/bash
# Test scripts for ghflow-project-setup skill

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
TEST_REPO="ghflow-test-project-setup-$(date +%s)"
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
echo "Testing ghflow-project-setup Scripts"
echo "==================================================================="

# Create test repository
echo ""
echo "Creating test repository: $TEST_REPO"
gh repo create "$TEST_REPO" --public --clone
cd "$TEST_REPO"
git config user.name "Test User"
git config user.email "test@example.com"

# Create a simple Python project structure
mkdir -p src tests
cat > src/main.py <<EOF
def hello(name: str) -> str:
    """Return a greeting."""
    return f"Hello, {name}!"

if __name__ == "__main__":
    print(hello("World"))
EOF

cat > tests/test_main.py <<EOF
from src.main import hello

def test_hello():
    assert hello("World") == "Hello, World!"
EOF

cat > pyproject.toml <<EOF
[project]
name = "test-project"
version = "0.1.0"
EOF

git add .
git commit -m "Initial project structure"
git push -u origin main

trap cleanup EXIT

SKILL_DIR="/Users/jneiku/code/gh-flow-hack/.claude/skills/ghflow-project-setup"

# Test 1: generate_implementation_guide.sh
test_start "generate_implementation_guide.sh - Generates implementation guide"

SCRIPT="$SKILL_DIR/scripts/generate_implementation_guide.sh"
if [ ! -f "$SCRIPT" ]; then
    fail "Script not found: $SCRIPT"
else
    GUIDE_CONTENT=$(bash "$SCRIPT")

    if [ -n "$GUIDE_CONTENT" ]; then
        pass "Implementation guide generated"

        # Check for expected sections
        if echo "$GUIDE_CONTENT" | grep -q "Project Overview"; then
            pass "Guide contains Project Overview section"
        else
            fail "Guide missing Project Overview section"
        fi

        if echo "$GUIDE_CONTENT" | grep -q "Common Patterns"; then
            pass "Guide contains Common Patterns section"
        else
            fail "Guide missing Common Patterns section"
        fi
    else
        fail "Failed to generate implementation guide"
    fi
fi

# Test 2: update_claude_md.sh
test_start "update_claude_md.sh - Updates CLAUDE.md with guide"

# Create initial CLAUDE.md
cat > CLAUDE.md <<EOF
# Project Documentation

## Overview
Test project

## Development Principles
- Keep it simple
- Write tests
EOF

SCRIPT="$SKILL_DIR/scripts/update_claude_md.sh"
if [ ! -f "$SCRIPT" ]; then
    fail "Script not found: $SCRIPT"
else
    # Generate and save guide
    GUIDE_CONTENT=$(bash "$SKILL_DIR/scripts/generate_implementation_guide.sh")
    echo "$GUIDE_CONTENT" | bash "$SCRIPT"

    # Verify CLAUDE.md was updated
    if grep -q "Feature Implementation Guide" CLAUDE.md; then
        pass "CLAUDE.md updated with Feature Implementation Guide"
    else
        fail "CLAUDE.md not updated with guide section"
    fi

    # Verify original content preserved
    if grep -q "Development Principles" CLAUDE.md; then
        pass "Original CLAUDE.md content preserved"
    else
        fail "Original CLAUDE.md content lost"
    fi

    # Verify backup created
    if ls CLAUDE.md.backup.* 1> /dev/null 2>&1; then
        pass "Backup of CLAUDE.md created"
    else
        fail "No backup created"
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
