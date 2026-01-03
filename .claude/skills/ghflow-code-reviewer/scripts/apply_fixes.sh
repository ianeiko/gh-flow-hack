#!/bin/bash
# Apply code review fixes and commit
# Usage: apply_fixes.sh <pr_number> "<fix_description>"

set -e

PR_NUMBER="$1"
FIX_DESCRIPTION="$2"

if [ -z "$PR_NUMBER" ] || [ -z "$FIX_DESCRIPTION" ]; then
    echo "Error: All parameters required"
    echo "Usage: apply_fixes.sh <pr_number> \"<fix_description>\""
    exit 1
fi

# Stage all changes
git add .

# Check if there are changes to commit
if git diff --cached --quiet; then
    echo "No changes to commit"
    exit 0
fi

# Create commit message
COMMIT_MSG=$(cat <<EOF
fix: address code review feedback - ${FIX_DESCRIPTION}

Related to PR #${PR_NUMBER}

🤖 Generated with Claude Code
Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
EOF
)

# Commit
git commit -m "$COMMIT_MSG"

# Push to current branch
CURRENT_BRANCH=$(git branch --show-current)
git push origin "$CURRENT_BRANCH"

echo "✅ Applied fix and pushed to ${CURRENT_BRANCH}"
echo "   ${FIX_DESCRIPTION}"
