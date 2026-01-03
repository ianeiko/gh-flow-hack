#!/bin/bash
# Verify skill exists before invoking
# Usage: invoke_skill.sh <skill_name>
# Exits with error if skill not found

set -e

SKILL_NAME="$1"

if [ -z "$SKILL_NAME" ]; then
    echo "Error: Skill name required"
    echo "Usage: invoke_skill.sh <skill_name>"
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

SKILLS_DIR="${REPO_ROOT}/.claude/skills"
SKILL_PATH="${SKILLS_DIR}/${SKILL_NAME}"

# Check if skill exists
if [ ! -d "$SKILL_PATH" ]; then
    echo "❌ ERROR: Required skill '${SKILL_NAME}' not found." >&2
    echo "" >&2
    echo "Expected location: ${SKILL_PATH}" >&2
    echo "" >&2
    echo "The orchestrator requires this skill to continue." >&2
    echo "Please ensure the skill is installed before running the orchestrator." >&2
    exit 1
fi

# Check if SKILL.md exists
if [ ! -f "${SKILL_PATH}/SKILL.md" ]; then
    echo "❌ ERROR: Skill '${SKILL_NAME}' exists but SKILL.md not found." >&2
    exit 1
fi

echo "✅ Skill '${SKILL_NAME}' verified at: ${SKILL_PATH}" >&2
echo "$SKILL_PATH"
