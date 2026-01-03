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

# Get the repository root (assumes script is in a git repo)
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
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
