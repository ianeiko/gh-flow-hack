# Utility Prompt: Start Implementation

This prompt is used to signal the start of implementation by removing the blocking label from a GitHub issue.

## Goal
Remove the `human-feedback-required` label from a GitHub issue to indicate it is ready for implementation by an agent.

## Input Variables
- `issue_number`: The number of the GitHub issue to update.
- `owner`: The owner of the repository.
- `repo`: The name of the repository.

## Instructions
1.  **Remove Label**: Use the GitHub MCP tool to remove the label `HF-required` from the issue specified by `issue_number`.

## Tool Usage
- `github_mcp.remove_issue_label(owner=owner, repo=repo, issue_number=issue_number, label='HF-required')`
