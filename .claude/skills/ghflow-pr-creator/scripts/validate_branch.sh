#!/bin/bash
# Validate branch name format: feature/issue-X-description
# Usage: validate_branch.sh <branch_name>

set -e

BRANCH_NAME="$1"

if [ -z "$BRANCH_NAME" ]; then
    echo "Error: Branch name required"
    echo "Usage: validate_branch.sh <branch_name>"
    exit 1
fi

# Pattern: feature/issue-NUMBER-description (all lowercase with hyphens)
if [[ ! "$BRANCH_NAME" =~ ^feature/issue-[0-9]+-[a-z0-9-]+$ ]]; then
    echo "❌ Invalid branch name: $BRANCH_NAME"
    echo ""
    echo "Expected format: feature/issue-<number>-<description>"
    echo ""
    echo "Valid examples:"
    echo "  - feature/issue-42-add-authentication"
    echo "  - feature/issue-100-fix-memory-leak"
    echo "  - feature/issue-7-update-readme"
    echo ""
    echo "Rules:"
    echo "  - All lowercase"
    echo "  - Use hyphens for spaces"
    echo "  - Include issue number"
    echo "  - Keep description concise"
    exit 1
fi

echo "✅ Branch name valid: $BRANCH_NAME"
exit 0
