#!/bin/bash
# Initialize workflow-state.md with template
# Usage: init_workflow.sh

set -e

# Get repository root
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
WORKFLOW_STATE_FILE="${REPO_ROOT}/workflow-state.md"

# Create workflow state template
cat > "$WORKFLOW_STATE_FILE" <<'EOF'
# Workflow State

**Current Phase:** Phase 1
**Started:** $(date)

## Phase 1: Issue Creation
- [ ] Issue created: #
- [ ] Label added: HF-required
- [ ] Local documentation saved: docs/issues/

## Phase 2: Human Review
- [ ] Human approved
- [ ] HF-required label removed

## Phase 3: Implementation
- [ ] Feature branch created:
- [ ] Implementation complete
- [ ] Tests passing

## Phase 4: PR Creation
- [ ] PR number:
- [ ] PR URL:
- [ ] Commits pushed

## Phase 5-6: Code Review
- [ ] Reviews fetched
- [ ] Feedback aggregated: docs/coderabbit/
- [ ] Fixes applied
- [ ] PR approved

## Notes

<!-- Add any workflow notes here -->

EOF

# Substitute the date
DATE=$(date)
sed -i.bak "s/\$(date)/$DATE/" "$WORKFLOW_STATE_FILE"
rm "${WORKFLOW_STATE_FILE}.bak"

echo "✅ Initialized workflow state: ${WORKFLOW_STATE_FILE}"
