#!/bin/bash
# Save implementation task plan to docs/tasks/
# Usage: save_task.sh <issue_number> "<task-name>"

set -e

ISSUE_NUMBER="$1"
TASK_NAME="$2"

if [ -z "$ISSUE_NUMBER" ] || [ -z "$TASK_NAME" ]; then
    echo "Error: All parameters required"
    echo "Usage: save_task.sh <issue_number> \"<task-name>\""
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

TASKS_DIR="${REPO_ROOT}/docs/tasks"

# Create directory if it doesn't exist
mkdir -p "$TASKS_DIR"

# Sanitize task name for filename
CLEAN_TASK=$(echo "$TASK_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')
OUTPUT_FILE="${TASKS_DIR}/${CLEAN_TASK}.md"

# Create task template
cat > "$OUTPUT_FILE" <<EOF
# Task: ${TASK_NAME}

**Issue:** #${ISSUE_NUMBER}
**Created:** $(date)
**Status:** In Progress

## Objective

<!-- Brief description of what this task accomplishes -->

## Implementation Plan

### Files to Create/Modify

- [ ] \`path/to/file1.py\`
- [ ] \`path/to/file2.py\`

### Components to Build

1. **Component 1**
   - Description
   - Key functionality

2. **Component 2**
   - Description
   - Key functionality

### Tests to Write

- [ ] Unit test: \`tests/test_feature.py\`
- [ ] Integration test: \`tests/integration/test_feature.py\`

### Dependencies

- [ ] Dependency 1 (if any)
- [ ] Dependency 2 (if any)

## Risks & Considerations

- Potential risk 1
- Potential risk 2

## Progress Notes

### $(date +%Y-%m-%d)
- Task created
- Initial planning complete

---

## Checklist

- [ ] Tests written
- [ ] Implementation complete
- [ ] Tests passing
- [ ] Documentation updated
- [ ] Code reviewed
- [ ] Ready for PR
EOF

echo "✅ Created task file: ${OUTPUT_FILE}"
echo "   Edit this file to plan your implementation"
