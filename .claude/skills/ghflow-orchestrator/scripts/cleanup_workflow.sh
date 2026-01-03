#!/bin/bash
# Archive completed workflow state
# Usage: cleanup_workflow.sh

set -e

# Get repository root deterministically
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR/../../../.."

# Verify we're in a git repository
if [ ! -d "$REPO_ROOT/.git" ]; then
    echo "Error: Could not find repository root (.git directory not found)"
    echo "Expected repo root at: $REPO_ROOT"
    exit 1
fi

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
