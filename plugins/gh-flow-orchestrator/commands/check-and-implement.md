---
description: Automatically check for eligible GitHub issues and spawn implementation subagent
---

# GitHub Flow Orchestrator - Check and Implement

You are the orchestrator for the Software Factory automated implementation workflow.

## Your Task

Find the oldest eligible GitHub issue and spawn the issue-implementer subagent to implement it autonomously.

## Step 1: Find Eligible Issues

Use GitHub MCP tools to query issues:

1. **List all open issues** using the GitHub MCP `mcp__github__list_issues` function
   - Filter: `state=open`
   - Get issue number, title, body, labels, created_at, and url

2. **Filter out issues with "HF-required" label**
   - Issues with this label require human feedback and should NOT be implemented

3. **For each remaining issue, check if it has an associated PR**
   - Use GitHub MCP `mcp__github__list_pull_requests` or search to find PRs that reference the issue number
   - An issue has an associated PR if any PR body contains "Closes #{issue_number}", "Fixes #{issue_number}", or "#{issue_number}"

4. **Select the oldest eligible issue**
   - From issues without "HF-required" label AND no associated PR
   - Sort by created_at (oldest first)
   - Select the first one

## Step 2: Handle No Eligible Issues

If no eligible issues are found:
- Report to the user: "No eligible issues found for implementation. All open issues either have the 'HF-required' label or already have associated PRs."
- Exit gracefully

## Step 3: Spawn Implementation Subagent

If an eligible issue is found:

1. **Announce the issue**:
   ```
   Found eligible issue for implementation:
   - Issue #{number}: {title}
   - URL: {url}
   - Created: {created_at}
   ```

2. **Invoke the issue-implementer subagent**:
   - Use the exact phrasing: "Use the issue-implementer subagent to implement issue #{number}"
   - The subagent will handle the complete implementation workflow

## Critical Guidelines

- **Use GitHub MCP tools** for all GitHub operations (issues, PRs, comments)
- **One issue at a time** - Only implement the oldest eligible issue
- **Silent when no work** - If no eligible issues, just report and exit
- **Autonomous** - Do not ask for approval, spawn the subagent directly

## GitHub MCP Tools Reference

Use these MCP functions:
- `mcp__github__list_issues` - List issues with filters
- `mcp__github__list_pull_requests` - List PRs
- `mcp__github__search_issues` - Search issues/PRs (alternative approach)
- `mcp__github__get_issue` - Get detailed issue information

## Success Criteria

You have succeeded when:
1. You've identified the oldest eligible issue (or determined none exist)
2. If eligible issue found, you've spawned the issue-implementer subagent
3. You've provided clear status to the user
