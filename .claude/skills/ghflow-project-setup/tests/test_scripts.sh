#!/bin/bash
# Test scripts for ghflow-project-setup skill

set -e

# Source shared test utilities
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
SHARED_UTILS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")/shared"
source "$SHARED_UTILS_DIR/test_utils.sh"

# Setup cleanup trap
trap cleanup_test_artifacts EXIT

# Setup
echo "==================================================================="
echo "Testing ghflow-project-setup Scripts"
echo "==================================================================="

# Get skill directory
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

# Backup CLAUDE.md
if [ -f "CLAUDE.md" ]; then
    cp "CLAUDE.md" "CLAUDE.md.original_backup"
fi

# Override cleanup to restore CLAUDE.md
cleanup_local() {
    if [ -f "CLAUDE.md.original_backup" ]; then
        mv "CLAUDE.md.original_backup" "CLAUDE.md"
        echo "Restored CLAUDE.md"
    fi
    rm -f CLAUDE.md.backup.*
    cleanup_test_artifacts
}
trap cleanup_local EXIT

# Test 1: generate_implementation_guide.sh
test_start "generate_implementation_guide.sh - Generates implementation guide"

SCRIPT="$SKILL_DIR/scripts/generate_implementation_guide.sh"
if [ ! -f "$SCRIPT" ]; then
    fail "Script not found: $SCRIPT"
else
    GUIDE_CONTENT=$(bash "$SCRIPT")

    if [ -n "$GUIDE_CONTENT" ]; then
        pass "Implementation guide generated"
        if echo "$GUIDE_CONTENT" | grep -q "Project Overview"; then
            pass "Guide contains Project Overview section"
        else
            fail "Guide missing Project Overview section"
        fi
    else
        fail "Failed to generate implementation guide"
    fi
fi

# Test 2: update_claude_md.sh
test_start "update_claude_md.sh - Updates CLAUDE.md with guide"

# Create dummy CLAUDE.md for test
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
    GUIDE_CONTENT=$(bash "$SKILL_DIR/scripts/generate_implementation_guide.sh")
    echo "$GUIDE_CONTENT" | bash "$SCRIPT"

    if grep -q "Feature Implementation Guide" CLAUDE.md; then
        pass "CLAUDE.md updated with Feature Implementation Guide"
    else
        fail "CLAUDE.md not updated with guide section"
    fi

    if grep -q "Development Principles" CLAUDE.md; then
        pass "Original CLAUDE.md content preserved"
    else
        fail "Original CLAUDE.md content lost"
    fi

    if ls CLAUDE.md.backup.* 1> /dev/null 2>&1; then
        pass "Backup of CLAUDE.md created"
    else
        fail "No backup created by script"
    fi
fi

# Summary
print_test_summary
