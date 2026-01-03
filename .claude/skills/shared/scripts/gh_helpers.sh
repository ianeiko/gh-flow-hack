#!/bin/bash
# Shared GitHub CLI helper functions
# Source this file to use the functions: source gh_helpers.sh

set -e

# Get repository owner and name from git remote
get_repo_info() {
    local remote_url=$(git config --get remote.origin.url)
    # Extract owner/repo from URL (works for both SSH and HTTPS)
    echo "$remote_url" | sed -E 's|.*[:/]([^/]+)/([^/]+)(\.git)?$|\1/\2|'
}

# Create a GitHub issue
# Usage: create_issue "title" "body"
create_issue() {
    local title="$1"
    local body="$2"

    if [ -z "$title" ]; then
        echo "Error: Issue title required"
        return 1
    fi

    gh issue create --title "$title" --body "$body"
}

# Add label to issue
# Usage: add_label <issue_number> <label>
add_label() {
    local issue_number="$1"
    local label="$2"

    if [ -z "$issue_number" ] || [ -z "$label" ]; then
        echo "Error: Issue number and label required"
        return 1
    fi

    gh issue edit "$issue_number" --add-label "$label"
}

# Remove label from issue
# Usage: remove_label <issue_number> <label>
remove_label() {
    local issue_number="$1"
    local label="$2"

    if [ -z "$issue_number" ] || [ -z "$label" ]; then
        echo "Error: Issue number and label required"
        return 1
    fi

    gh issue edit "$issue_number" --remove-label "$label"
}

# Fetch issue details
# Usage: fetch_issue <issue_number>
fetch_issue() {
    local issue_number="$1"

    if [ -z "$issue_number" ]; then
        echo "Error: Issue number required"
        return 1
    fi

    gh issue view "$issue_number" --json title,body,labels,state
}

# Create a pull request
# Usage: create_pr "title" "body"
create_pr() {
    local title="$1"
    local body="$2"

    if [ -z "$title" ]; then
        echo "Error: PR title required"
        return 1
    fi

    gh pr create --title "$title" --body "$body"
}

# Fetch PR reviews/comments
# Usage: fetch_pr_reviews <pr_number>
fetch_pr_reviews() {
    local pr_number="$1"

    if [ -z "$pr_number" ]; then
        echo "Error: PR number required"
        return 1
    fi

    local repo_info=$(get_repo_info)
    gh api "repos/${repo_info}/pulls/${pr_number}/comments"
}

# Check if PR is approved
# Usage: check_pr_approval <pr_number>
check_pr_approval() {
    local pr_number="$1"

    if [ -z "$pr_number" ]; then
        echo "Error: PR number required"
        return 1
    fi

    gh pr view "$pr_number" --json reviewDecision -q '.reviewDecision'
}

# Create a branch
# Usage: create_branch "branch-name"
create_branch() {
    local branch_name="$1"

    if [ -z "$branch_name" ]; then
        echo "Error: Branch name required"
        return 1
    fi

    git checkout -b "$branch_name"
}

# Validate branch name format (feature/issue-X-description)
# Usage: validate_branch_name "branch-name"
validate_branch_name() {
    local branch_name="$1"

    if [[ ! "$branch_name" =~ ^feature/issue-[0-9]+-[a-z0-9-]+$ ]]; then
        echo "Error: Invalid branch name format. Expected: feature/issue-X-description"
        return 1
    fi

    echo "✅ Branch name valid: $branch_name"
    return 0
}

# Export functions so they're available when sourced
export -f get_repo_info
export -f create_issue
export -f add_label
export -f remove_label
export -f fetch_issue
export -f create_pr
export -f fetch_pr_reviews
export -f check_pr_approval
export -f create_branch
export -f validate_branch_name
