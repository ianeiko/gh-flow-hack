# GitHub Issue Implementation Flow

## Overview
After a GitHub issue has been created and reviewed (HF-required label removed), proceed with implementation and PR creation.

## Workflow Continuation

### Phase 4: Local Implementation
**Input**: GitHub issue number and content
**Prompt Template**: `prompts/02_implementation.md`
**Action**:
1. Fetch the GitHub issue details using the GitHub MCP tool
2. Read and analyze the requirements and acceptance criteria from the issue body
3. Explore the codebase to understand current structure and patterns
4. Plan the implementation:
   - Identify files to create or modify
   - Determine necessary dependencies or utilities
   - Consider test requirements
5. Implement the changes locally:
   - Write clean, efficient code following the requirements
   - Add or update tests as needed
   - Ensure code follows existing patterns and conventions
6. Verify the implementation meets all acceptance criteria
7. Test locally to ensure functionality works as expected

### Phase 5: Pull Request Creation
**Input**: Completed local implementation with changes
**Action**:
1. Review all changed files using `git status` and `git diff`
2. Create a new branch for the changes using `git checkout -b feature/issue-{number}-{short-description}`
3. Stage and commit the changes locally:
   - Use descriptive commit message referencing the issue number
   - Format: `feat: description (fixes #{issue-number})`
4. Push the branch to remote repository
5. Create a pull request using the GitHub MCP tool:
   - Set title to reference the issue: `feat: {feature name} (#{issue-number})`
   - Set body to include:
     - Summary of changes
     - Reference to the issue: `Closes #{issue-number}`
     - Test plan or verification steps
     - Any additional context
6. Link the PR to the original issue
7. Report the PR URL and number

## Execution Instructions

When implementing an issue:
1. **Fetch** the issue using `mcp__github__issue_read` with method="get"
2. **Analyze** the requirements and acceptance criteria
3. **Explore** the codebase context (use Task tool with Explore agent)
4. **Plan** the implementation approach
5. **Implement** changes following the 02_implementation.md prompt guidelines
6. **Test** locally to verify functionality
7. **Commit** changes with proper commit message format
8. **Create PR** using GitHub MCP tools (`mcp__github__create_pull_request`)
9. **Report** the PR URL and status

## Repository Context
- **Owner**: Determine from authenticated GitHub user
- **Repo**: `gh-flow-hack`
- **Base Branch**: `main`
- **Feature Branch**: `feature/issue-{number}-{description}`

## Commit Message Format
```
feat: {short description}

{detailed description if needed}

Closes #{issue-number}
```

## PR Body Template
```markdown
## Summary
{Brief description of what was implemented}

## Changes
- {List of key changes}
- {Files modified/created}

## Related Issue
Closes #{issue-number}

## Test Plan
{How to verify the changes work}

## Additional Notes
{Any relevant context or decisions made}
```

## Notes
- Use GitHub MCP tools for all GitHub operations
- Follow existing code patterns and conventions
- Keep changes focused and minimal (avoid over-engineering)
- Ensure all acceptance criteria are met before creating PR
- Test thoroughly before pushing changes
