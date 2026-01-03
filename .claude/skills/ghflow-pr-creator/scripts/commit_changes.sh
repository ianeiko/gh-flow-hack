#!/bin/bash
# Stage and commit all changes with proper formatting
# Usage: commit_changes.sh <issue_number> <type> "<description>"

set -e

ISSUE_NUMBER="$1"
TYPE="$2"
DESCRIPTION="$3"

if [ -z "$ISSUE_NUMBER" ] || [ -z "$TYPE" ] || [ -z "$DESCRIPTION" ]; then
    echo "Error: All parameters required"
    echo "Usage: commit_changes.sh <issue_number> <type> \"<description>\""
    echo ""
    echo "Types: feat, fix, refactor, docs, test, chore"
    echo "Example: commit_changes.sh 42 feat \"add dark mode toggle\""
    exit 1
fi

# Validate type
case "$TYPE" in
    feat|fix|refactor|docs|test|chore)
        ;;
    *)
        echo "Error: Invalid type '$TYPE'"
        echo "Valid types: feat, fix, refactor, docs, test, chore"
        exit 1
        ;;
esac

# Stage all changes
git add .

# Create commit message
COMMIT_MSG=$(cat <<EOF
${TYPE}: ${DESCRIPTION}

Closes #${ISSUE_NUMBER}

🤖 Generated with Claude Code
Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
EOF
)

# Commit
git commit -m "$COMMIT_MSG"

echo "✅ Committed changes: ${TYPE}: ${DESCRIPTION}"
echo "   Closes #${ISSUE_NUMBER}"
