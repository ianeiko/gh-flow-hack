#!/bin/bash
# Fetch PR review comments via GitHub API
# Usage: fetch_pr_reviews.sh <pr_number>

set -e

PR_NUMBER="$1"

if [ -z "$PR_NUMBER" ]; then
    echo "Error: PR number required"
    echo "Usage: fetch_pr_reviews.sh <pr_number>"
    exit 1
fi

# Get repository info
REPO_INFO=$(git config --get remote.origin.url | sed -E 's|.*[:/]([^/]+)/([^/]+)(\.git)?$|\1/\2|')

echo "Fetching reviews for PR #${PR_NUMBER}..."

# Fetch PR review comments
gh api "repos/${REPO_INFO}/pulls/${PR_NUMBER}/comments" > "/tmp/pr_${PR_NUMBER}_comments.json"

# Fetch PR reviews (top-level reviews)
gh api "repos/${REPO_INFO}/pulls/${PR_NUMBER}/reviews" > "/tmp/pr_${PR_NUMBER}_reviews.json"

echo "✅ Fetched reviews for PR #${PR_NUMBER}"
echo "   Comments: /tmp/pr_${PR_NUMBER}_comments.json"
echo "   Reviews: /tmp/pr_${PR_NUMBER}_reviews.json"
