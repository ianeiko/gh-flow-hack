#!/bin/bash
# Shared script to update workflow-state.md
# Usage: update_workflow_state.sh <phase> <key> <value>

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKFLOW_STATE_FILE="$SCRIPT_DIR/../../../../workflow-state.md"

if [ ! -f "$WORKFLOW_STATE_FILE" ]; then
    echo "Error: workflow-state.md not found at $WORKFLOW_STATE_FILE"
    exit 1
fi

PHASE=$1
KEY=$2
VALUE=$3

if [ -z "$PHASE" ] || [ -z "$KEY" ] || [ -z "$VALUE" ]; then
    echo "Usage: update_workflow_state.sh <phase> <key> <value>"
    echo "Example: update_workflow_state.sh 'Phase 1' 'issue_number' '123'"
    exit 1
fi

# Create backup
cp "$WORKFLOW_STATE_FILE" "${WORKFLOW_STATE_FILE}.bak"

# Update the workflow state using sed
# This is a simple implementation - can be enhanced with more sophisticated parsing
sed -i.tmp "s|${KEY}:.*|${KEY}: ${VALUE}|g" "$WORKFLOW_STATE_FILE"
rm "${WORKFLOW_STATE_FILE}.tmp"

echo "✅ Updated workflow-state.md: ${PHASE} -> ${KEY} = ${VALUE}"
