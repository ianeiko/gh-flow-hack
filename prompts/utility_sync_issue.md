# GitHub Issue Operations

## Delegation
**Use `/github` plugin for all GitHub issue operations.**

## Our Standards
### Creating Issues
- Use expanded content from `prompts/01_issue_expansion.md` template
- Add `HF-required` label (auto-created if doesn't exist)
- Save issue locally to `docs/issues/issue_{number}.md`
- Update `workflow-state.md` with issue details

### Updating Issues
- Read local file content
- Update via GitHub MCP tools (not bash)
- Keep local and GitHub in sync

### Repository Context
- Owner: From authenticated GitHub user
- Repo: `gh-flow-hack`
- Main branch: `main`
