#!/bin/bash
# Fetch issue details via GitHub CLI
# Usage: fetch_issue.sh <issue_number>

set -e

ISSUE_NUMBER="$1"

if [ -z "$ISSUE_NUMBER" ]; then
    echo "Error: Issue number required"
    echo "Usage: fetch_issue.sh <issue_number>"
    exit 1
fi

echo "Fetching issue #${ISSUE_NUMBER}..."

# Fetch issue with all details
gh issue view "$ISSUE_NUMBER" --json title,body,labels,state,assignees > "/tmp/issue_${ISSUE_NUMBER}.json"

echo "✅ Fetched issue #${ISSUE_NUMBER}"
echo "   Saved to: /tmp/issue_${ISSUE_NUMBER}.json"

# Also display human-readable version
echo ""
echo "=== Issue #${ISSUE_NUMBER} ==="
gh issue view "$ISSUE_NUMBER"
