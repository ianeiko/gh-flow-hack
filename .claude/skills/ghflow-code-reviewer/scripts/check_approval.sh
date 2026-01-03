#!/bin/bash
# Check if PR is approved
# Usage: check_approval.sh <pr_number>
# Returns: APPROVED, CHANGES_REQUESTED, or PENDING

set -e

PR_NUMBER="$1"

if [ -z "$PR_NUMBER" ]; then
    echo "Error: PR number required"
    echo "Usage: check_approval.sh <pr_number>"
    exit 1
fi

# Get review decision
DECISION=$(gh pr view "$PR_NUMBER" --json reviewDecision -q '.reviewDecision' 2>/dev/null || echo "PENDING")

case "$DECISION" in
    "APPROVED")
        echo "✅ PR #${PR_NUMBER} is APPROVED"
        echo "APPROVED"
        ;;
    "CHANGES_REQUESTED")
        echo "⚠️  PR #${PR_NUMBER} has CHANGES_REQUESTED"
        echo "CHANGES_REQUESTED"
        ;;
    "")
        echo "⏳ PR #${PR_NUMBER} is PENDING review"
        echo "PENDING"
        ;;
    *)
        echo "⏳ PR #${PR_NUMBER} status: ${DECISION}"
        echo "PENDING"
        ;;
esac
