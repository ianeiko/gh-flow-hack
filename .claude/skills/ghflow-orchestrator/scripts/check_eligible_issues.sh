#!/bin/bash
# Find oldest issue without HF-required label
# Usage: check_eligible_issues.sh
# Returns: Issue number or empty if none found

set -e

# Get all open issues without HF-required label, sorted by creation date (oldest first)
ISSUE=$(gh issue list \
    --state open \
    --json number,labels,createdAt \
    --jq '.[] | select(.labels | map(.name) | contains(["HF-required"]) | not) | .number' \
    | head -n 1)

if [ -z "$ISSUE" ]; then
    echo "No eligible issues found" >&2
    exit 1
fi

echo "✅ Found eligible issue: #${ISSUE}" >&2
echo "$ISSUE"
