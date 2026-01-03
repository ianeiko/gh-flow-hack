#!/bin/bash
# Save issue content to docs/issues/issue_{number}.md
# Usage: save_issue.sh <issue_number> <content_file_or_stdin>

set -e

ISSUE_NUMBER="$1"
CONTENT_SOURCE="$2"

if [ -z "$ISSUE_NUMBER" ]; then
    echo "Error: Issue number required"
    echo "Usage: save_issue.sh <issue_number> <content_file_or_stdin>"
    exit 1
fi

# Get repository root deterministically
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR/../../../.."

# Verify we're in a git repository
if [ ! -d "$REPO_ROOT/.git" ]; then
    echo "Error: Could not find repository root (.git directory not found)"
    echo "Expected repo root at: $REPO_ROOT"
    exit 1
fi

ISSUES_DIR="${REPO_ROOT}/docs/issues"

# Create issues directory if it doesn't exist
mkdir -p "$ISSUES_DIR"

OUTPUT_FILE="${ISSUES_DIR}/issue_${ISSUE_NUMBER}.md"

# Read content from file or stdin
if [ -n "$CONTENT_SOURCE" ] && [ -f "$CONTENT_SOURCE" ]; then
    cp "$CONTENT_SOURCE" "$OUTPUT_FILE"
else
    # Read from stdin if no file provided
    cat > "$OUTPUT_FILE"
fi

echo "✅ Saved issue #${ISSUE_NUMBER} to ${OUTPUT_FILE}"
