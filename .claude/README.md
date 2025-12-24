# Claude Code Project Configuration

This directory contains project-specific Claude Code configuration for the GitHub Flow orchestrator.

## Structure

```
.claude/
├── agents/              # Custom agents (subagents for specialized tasks)
│   └── issue-implementer.md
├── commands/            # Slash commands available in this project
│   ├── check-and-implement.md
│   ├── idea-to-pr.md
│   └── g/              # Grouped commands (legacy)
├── hooks/              # Event hooks
│   └── hooks.json
├── PRINCIPLES.md       # Development principles (YAGNI, KISS, DRY)
└── README.md          # This file
```

## Available Commands

### Workflow Commands
- `/idea-to-pr` - Transform idea from `idea.md` into GitHub issue and optionally implement
- `/check-and-implement` - Find eligible GitHub issues and implement them

### Legacy Commands (in /g/ namespace)
- `/g:generate-prd` - Generate PRD using template
- `/g:generate-story` - Generate user story
- `/g:generate-task` - Create task spec
- `/g:issue` - Analyze and fix GitHub issues
- `/g:sprint-prd` - Execute Phase 0 contract definition

## Available Agents

### issue-implementer
Autonomous agent that implements GitHub issues end-to-end:
- Reads issue from GitHub
- Creates feature branch
- Implements code following project patterns
- Writes tests
- Commits and pushes changes
- Creates pull request

## Hooks

### SessionStart Hook
Automatically executes `/check-and-implement` when Claude Code starts, checking for eligible issues to implement.

## Usage

All configuration in `.claude/` is automatically loaded by Claude Code. No installation required.

**Quick start:**
1. Write your idea in `idea.md`
2. Run `/idea-to-pr --auto-implement`
3. Get a PR!

See `workflow-state.md` in the project root for workflow tracking.
