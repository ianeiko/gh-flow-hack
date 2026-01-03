#!/bin/bash
# Create feature branch with proper naming
# Usage: create_branch.sh <issue_number> "<description>"

set -e

ISSUE_NUMBER="$1"
DESCRIPTION="$2"

if [ -z "$ISSUE_NUMBER" ] || [ -z "$DESCRIPTION" ]; then
    echo "Error: All parameters required"
    echo "Usage: create_branch.sh <issue_number> \"<description>\""
    echo "Example: create_branch.sh 42 \"add-authentication\""
    exit 1
fi

# Sanitize description: lowercase, replace spaces with hyphens
CLEAN_DESC=$(echo "$DESCRIPTION" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')

# Create branch name
BRANCH_NAME="feature/issue-${ISSUE_NUMBER}-${CLEAN_DESC}"

echo "Creating branch: ${BRANCH_NAME}"

# Check if branch already exists
if git show-ref --verify --quiet "refs/heads/${BRANCH_NAME}"; then
    echo "⚠️  Branch already exists: ${BRANCH_NAME}"
    echo "Checking out existing branch..."
    git checkout "$BRANCH_NAME"
else
    # Create and checkout new branch
    git checkout -b "$BRANCH_NAME"
    echo "✅ Created and checked out branch: ${BRANCH_NAME}"
fi

echo "$BRANCH_NAME"
