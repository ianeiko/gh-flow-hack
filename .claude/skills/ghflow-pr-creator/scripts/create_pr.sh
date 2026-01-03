#!/bin/bash
# Create a pull request using template
# Usage: create_pr.sh <issue_number> "<pr_title>"

set -e

ISSUE_NUMBER="$1"
PR_TITLE="$2"

if [ -z "$ISSUE_NUMBER" ] || [ -z "$PR_TITLE" ]; then
    echo "Error: All parameters required"
    echo "Usage: create_pr.sh <issue_number> \"<pr_title>\""
    exit 1
fi

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATE_FILE="${SKILL_DIR}/assets/pr-template.md"

if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "Error: PR template not found at $TEMPLATE_FILE"
    exit 1
fi

# Read template and substitute variables
PR_BODY=$(cat "$TEMPLATE_FILE" | sed "s/{{ISSUE_NUMBER}}/${ISSUE_NUMBER}/g")

# Create PR
OUTPUT=$(gh pr create --title "$PR_TITLE" --body "$PR_BODY" 2>&1)

# Extract PR number and URL
PR_URL=$(echo "$OUTPUT" | grep -oE 'https://github.com/[^/]+/[^/]+/pull/[0-9]+')
PR_NUMBER=$(echo "$PR_URL" | grep -oE '[0-9]+$')

if [ -z "$PR_NUMBER" ]; then
    echo "Error: Failed to extract PR number from: $OUTPUT"
    exit 1
fi

echo "✅ Created PR #${PR_NUMBER}"
echo "   URL: ${PR_URL}"
echo "${PR_NUMBER}|${PR_URL}"
