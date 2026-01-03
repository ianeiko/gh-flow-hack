#!/bin/bash
# Create a GitHub issue and add HF-required label
# Usage: create_github_issue "title" "body"
# Returns: Issue number

set -e

create_github_issue() {
    local title="$1"
    local body="$2"

    if [ -z "$title" ]; then
        echo "Error: Issue title required" >&2
        return 1
    fi

    # Create issue and capture the output
    local output=$(gh issue create --title "$title" --body "$body" 2>&1)

    # Extract issue number from URL (format: https://github.com/owner/repo/issues/123)
    local issue_number=$(echo "$output" | grep -oE '/issues/([0-9]+)' | grep -oE '[0-9]+')

    if [ -z "$issue_number" ]; then
        echo "Error: Failed to extract issue number from: $output" >&2
        return 1
    fi

    # Add HF-required label
    gh issue edit "$issue_number" --add-label "HF-required" >/dev/null 2>&1

    echo "✅ Created issue #$issue_number with HF-required label" >&2
    echo "$issue_number"
}

# Export function if sourced
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    export -f create_github_issue
else
    # Script is being run directly
    create_github_issue "$@"
fi
