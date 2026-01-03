#!/bin/bash
# Check if specific label exists on issue
# Usage: poll_label.sh <issue_number> "<label_name>"
# Returns: 0 if label removed, 1 if still present

set -e

ISSUE_NUMBER="$1"
LABEL_NAME="$2"

if [ -z "$ISSUE_NUMBER" ] || [ -z "$LABEL_NAME" ]; then
    echo "Error: All parameters required"
    echo "Usage: poll_label.sh <issue_number> \"<label_name>\""
    exit 2
fi

# Get labels for the issue
LABELS=$(gh issue view "$ISSUE_NUMBER" --json labels --jq '.labels[].name')

# Check if label exists in the list
if echo "$LABELS" | grep -q "^${LABEL_NAME}$"; then
    echo "⏳ Label '${LABEL_NAME}' still present on issue #${ISSUE_NUMBER}" >&2
    exit 1
else
    echo "✅ Label '${LABEL_NAME}' has been removed from issue #${ISSUE_NUMBER}" >&2
    exit 0
fi
