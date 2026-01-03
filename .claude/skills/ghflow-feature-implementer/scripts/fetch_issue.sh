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

# Resolve repo root and workflow-state directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR/../../../.."
WORKFLOW_STATE_DIR="$REPO_ROOT/.claude/workflow-state/issues"

# Create workflow-state directory
if ! mkdir -p "$WORKFLOW_STATE_DIR" 2>/dev/null; then
    echo "Error: Failed to create workflow-state directory: $WORKFLOW_STATE_DIR"
    exit 1
fi

ISSUE_FILE="$WORKFLOW_STATE_DIR/issue_${ISSUE_NUMBER}.json"

echo "Fetching issue #${ISSUE_NUMBER}..."

# Fetch issue with all details
if ! gh issue view "$ISSUE_NUMBER" --json title,body,labels,state,assignees > "$ISSUE_FILE" 2>&1; then
    echo "Error: Failed to fetch issue #${ISSUE_NUMBER} via gh CLI"
    rm -f "$ISSUE_FILE"
    exit 1
fi

echo "✅ Fetched issue #${ISSUE_NUMBER}"
echo "   Saved to: $ISSUE_FILE"

# Also display human-readable version
echo ""
echo "=== Issue #${ISSUE_NUMBER} ==="
gh issue view "$ISSUE_NUMBER"
