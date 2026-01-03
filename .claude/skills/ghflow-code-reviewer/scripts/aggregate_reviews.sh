#!/bin/bash
# Aggregate review comments and save to docs/coderabbit/{pr_id}.md
# Usage: aggregate_reviews.sh <pr_number>

set -e

PR_NUMBER="$1"

if [ -z "$PR_NUMBER" ]; then
    echo "Error: PR number required"
    echo "Usage: aggregate_reviews.sh <pr_number>"
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

CODERABBIT_DIR="${REPO_ROOT}/docs/coderabbit"
OUTPUT_FILE="${CODERABBIT_DIR}/pr_${PR_NUMBER}.md"

# Create directory if it doesn't exist
mkdir -p "$CODERABBIT_DIR"

# Check if review files exist
COMMENTS_FILE="/tmp/pr_${PR_NUMBER}_comments.json"
REVIEWS_FILE="/tmp/pr_${PR_NUMBER}_reviews.json"

if [ ! -f "$COMMENTS_FILE" ] || [ ! -f "$REVIEWS_FILE" ]; then
    echo "Error: Review files not found. Run fetch_pr_reviews.sh first."
    exit 1
fi

# Create markdown header
cat > "$OUTPUT_FILE" <<EOF
# Code Review Feedback - PR #${PR_NUMBER}

**Generated:** $(date)

## Summary

This document aggregates all code review feedback from automated reviewers.

---

## Review Comments

EOF

# Parse and append comments (using jq if available, otherwise simple format)
if command -v jq &> /dev/null; then
    # Use jq to parse JSON nicely
    jq -r '.[] | "### \(.path):\(.line)\n\n**Reviewer:** \(.user.login)\n\n\(.body)\n\n---\n"' "$COMMENTS_FILE" >> "$OUTPUT_FILE" 2>/dev/null || echo "No inline comments found" >> "$OUTPUT_FILE"

    echo -e "\n## General Reviews\n" >> "$OUTPUT_FILE"
    jq -r '.[] | select(.body != null and .body != "") | "**Reviewer:** \(.user.login)\n**State:** \(.state)\n\n\(.body)\n\n---\n"' "$REVIEWS_FILE" >> "$OUTPUT_FILE" 2>/dev/null || echo "No general reviews found" >> "$OUTPUT_FILE"
else
    # Fallback: Just note that reviews exist
    echo "Review data saved. Install 'jq' for formatted output." >> "$OUTPUT_FILE"
    echo "Raw data available in: $COMMENTS_FILE and $REVIEWS_FILE" >> "$OUTPUT_FILE"
fi

echo "✅ Aggregated reviews saved to: ${OUTPUT_FILE}"
