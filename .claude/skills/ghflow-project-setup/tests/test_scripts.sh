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

# Backup CLAUDE.md if it exists, to restore later (since we modify it)
if [ -f "CLAUDE.md" ]; then
    cp "CLAUDE.md" "CLAUDE.md.original_backup"

    # Add to cleanup function in a way that restores it
    # We can append to the trap, or just handle it here?
    # Better to create a custom cleanup function that calls the shared one.
fi

# Override cleanup to restore CLAUDE.md
cleanup_local() {
    if [ -f "CLAUDE.md.original_backup" ]; then
        mv "CLAUDE.md.original_backup" "CLAUDE.md"
        echo "Restored CLAUDE.md"
    fi

    # Remove any backups created by the script
    rm -f CLAUDE.md.backup.*

    # Call shared cleanup
    cleanup_test_artifacts
}
trap cleanup_local EXIT

# We don't need to create a whole project structure because the current repo IS a project structure.
# But `generate_implementation_guide.sh` might rely on specific files existing (src/, pyproject.toml etc)
# The current repo has app/, coder/, tests/.
# Let's see what `generate_implementation_guide.sh` looks for.
# It probably scans typical directories.

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

        # The script might not output "Common Patterns" if it doesn't recognize the repo structure?
        # Let's assume it outputs something reasonable.
    else
        fail "Failed to generate implementation guide"
    fi
fi

# Test 2: update_claude_md.sh
test_start "update_claude_md.sh - Updates CLAUDE.md with guide"

# Create a dummy CLAUDE.md for testing if one doesn't exist (it should, but just in case)
# Actually, we backed up the real one.
# We can create a TEMP CLAUDE.md to test against, to verify the script works,
# instead of modifying the real one even with restore??
# But the script updates "CLAUDE.md" in current dir.
# Safe way: We already backed up. We can overwrite CLAUDE.md with a test content.

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

    # Pass input via pipe
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

    # Verify backup created by the script (it creates CLAUDE.md.backup.timestamp)
    if ls CLAUDE.md.backup.* 1> /dev/null 2>&1; then
        pass "Backup of CLAUDE.md created"
    else
        fail "No backup created by script"
    fi
fi

# Summary
print_test_summary
