# Utility Prompt: Create Pull Request

This prompt is used to create a new Pull Request on GitHub once implementation is complete.

## Goal
Create a Pull Request merging the current working branch into the base branch (usually `main`).

## Input Variables
- `owner`: The owner of the repository.
- `repo`: The name of the repository.
- `title`: The title of the Pull Request.
- `body`: A description of the changes in the Pull Request.
- `head`: The name of the branch containing the changes (the current branch).
- `base`: The name of the branch to merge into (default: `main`).

## Instructions
1.  **Create PR**: Use the GitHub MCP tool `create_pull_request` to open a new PR.

## Tool Usage
- `github_mcp.create_pull_request(owner=owner, repo=repo, title=title, body=body, head=head, base=base)`
