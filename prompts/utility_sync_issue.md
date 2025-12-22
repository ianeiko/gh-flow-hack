# Utility Prompt: Sync Issue to GitHub

This prompt is used to synchronize the content of a local markdown issue file with a specific GitHub issue.

## Goal
Update the body of an existing GitHub issue with the content from a local markdown file.

## Input Variables
- `issue_path`: The absolute path to the local markdown file containing the issue content (e.g., `/Users/jneiku/code/gh-flow-hack/docs/issues/issue_123.md`).
- `issue_number`: The number of the GitHub issue to update.
- `owner`: The owner of the repository (e.g., `jneiku`).
- `repo`: The name of the repository (e.g., `gh-flow-hack`).

## Instructions
1.  **Read Local File**: Read the content of the file at `issue_path`.
2.  **Update GitHub Issue**: Use the GitHub MCP tool `update_issue` to update the issue specified by `issue_number`.
    - Set `body` to the content read from the local file.

## Tool Usage
- `read_file(path=issue_path)`
- `github_mcp.update_issue(owner=owner, repo=repo, issue_number=issue_number, body=file_content)`
