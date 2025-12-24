# Pull Request Standards

## Delegation
**Use `/github` plugin for PR operations.**

## Our Standards
### Branch Naming
`feature/issue-{number}-{short-description}`

### Commit Format
```
feat: {description}

{detailed description if needed}

Closes #{issue-number}
```

### PR Title Format
`feat: {feature name} (#{issue-number})`

### PR Body Template
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

### PR Creation Checklist
1. Review changes: `git status`, `git diff`
2. Create feature branch (if not exists)
3. Commit with proper format
4. Push to remote
5. Create PR via GitHub MCP tools
6. Link PR to issue
7. Update `workflow-state.md` with PR details
