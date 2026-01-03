#!/bin/bash
# Archive completed workflow state
# Usage: cleanup_workflow.sh

set -e

# Get repository root
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
WORKFLOW_STATE_FILE="${REPO_ROOT}/workflow-state.md"
ARCHIVE_DIR="${REPO_ROOT}/workflow-state-archive"

if [ ! -f "$WORKFLOW_STATE_FILE" ]; then
    echo "⚠️  No workflow state file found to archive"
    exit 0
fi

# Create archive directory
mkdir -p "$ARCHIVE_DIR"

# Create archive filename with timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ARCHIVE_FILE="${ARCHIVE_DIR}/workflow-state_${TIMESTAMP}.md"

# Move workflow state to archive
mv "$WORKFLOW_STATE_FILE" "$ARCHIVE_FILE"

echo "✅ Archived workflow state to: ${ARCHIVE_FILE}"
echo "   Original file removed from root"
