# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an **AI-Driven Development Flow** system (a "Software Factory") that orchestrates the complete lifecycle from idea to implementation using AI agents and structured prompts. The repository contains:

1. **The Flow System**: Orchestration prompts and workflows in `/prompts` and workflow docs (`plan.md`, `implement.md`)
2. **The Target Application**: A LangChain/LangGraph Deep Agent being built in `/app` using the [`langchain-ai/deepagents`](https://github.com/langchain-ai/deepagents) template
3. **Coder Integration**: Terraform configuration for running Claude Code as an AI agent within Coder workspaces

## Quick Start

**See `QUICKSTART.md` for installation and usage.**

**TL;DR**: Write idea → Run `/gh-flow-orchestrator:idea-to-pr` → Get PR

## Common Commands

### Workflow Orchestration
```bash
# Idea → Issue → Implementation → PR (auto)
/gh-flow-orchestrator:idea-to-pr --auto-implement

# Idea → Issue (with human review)
/gh-flow-orchestrator:idea-to-pr

# Find eligible issue → Implement
/gh-flow-orchestrator:check-and-implement
```

### Development Environment
```bash
# Setup Coder template (first time only)
make setup

# Run Coder server
make run

# Build and push Coder template
make build

# Clean up all tasks
make clean
```

### Application Development
```bash
# Run the application
cd app && python main.py
```

## Architecture

### 1. The Flow System (Core Concept)

The repository implements a **plugin-driven AI development workflow** where agents transform ideas into code using Claude Code plugins:

**Workflow State Tracking:**
- `workflow-state.md` - **CHECK THIS FIRST** - Tracks current phase, issue, PR, and task details
- `plan.md` - Orchestrates Phase 1-3: Idea → GitHub Issue creation
- `implement.md` - Orchestrates Phase 4-6: Implementation → PR → Review & Fix
- `docs/prd.md` - Complete workflow specification

**Standards Library (`/prompts`):**
Our prompts define standards and delegate to plugins:
- `01_issue_expansion.md` - Issue template format (our specific structure)
- `02_implementation.md` - Implementation standards (delegates to `/feature-dev`)
- `03_review_aggregation.md` - Review standards (delegates to `/code-review`)
- `04_refactor_analysis.md` - Refactoring standards (delegates to `/code-review`)
- `05_fix_application.md` - Fix standards (delegates to `/code-review`)
- `utility_*.md` - GitHub operation standards (delegate to `/github`)

**Claude Code Plugins (Installed):**
- `/github` - GitHub operations (issues, PRs, labels)
- `/feature-dev` - Feature implementation workflow
- `/code-review` - Code review and feedback aggregation

**The Complete Flow:**
1. User writes idea in `idea.md`
2. Agent expands idea using template from `prompts/01_issue_expansion.md`
3. Agent creates GitHub issue via `/github` plugin with "HF-required" label
4. Human reviews and removes label when ready
5. Agent implements feature via `/feature-dev` plugin following `docs/tech_implementation.md`
6. Agent creates PR via `/github` plugin
7. Code Rabbit reviews PR automatically
8. Agent aggregates feedback via `/github` plugin to `docs/coderabbit/{pr_id}.md`
9. Agent analyzes & applies fixes via `/code-review` plugin until PR merges

**Always start by checking `workflow-state.md` to see current phase and context!**

### 2. Target Application Architecture (`/app`)

The application follows the **Deep Agents** framework pattern:

**Required Structure:**
```
app/
├── main.py              # Entrypoint with graph compilation
├── agent.py             # Main agent configuration
├── state.py             # Custom state extensions
├── tools/               # Custom tool definitions
└── subagents/           # Specialized sub-agents
```

**Critical Patterns (from `docs/tech_implementation.md`):**

1. **Always use `create_deep_agent` factory** - Don't reinvent the graph
2. **Preserve middleware** - `enable_todos=True` and `enable_fs=True` are the agent's brain/memory
3. **Type all tools** - LLM needs strict typing and docstrings
4. **Modularize** - Tools in `/tools`, not cluttered in main.py
5. **Test compilation** - Run `python app/main.py` to verify graph compiles

**State Management:**
- Uses `DeepAgentState` with `messages`, `todo_list`, and `filesystem` tracking
- Middleware injects functionality (todos, file system context)
- Sub-agents handle specialized tasks via `task` tool

### 3. Coder Workspace Integration

The Terraform configuration (`coder/template/build.tf`) sets up:
- Docker-based workspaces with Claude Code agent
- `coder_ai_task` resource for task execution
- Claude Code module with configurable system prompts and model selection
- Working directory: `/home/coder/projects/gh-flow-hack`
- Permission mode: `plan` (requires approval before execution)

## Development Principles (`.claude/PRINCIPLES.md`)

**Core Philosophy:**
- **YAGNI** - Implement only current requirements
- **KISS** - Prefer simplicity over complexity
- **DRY** - Abstract common functionality

**Code Quality:**
- Test-Driven Development approach
- Never reference removed code in comments (present-focused)
- Fail fast with explicit errors
- All dependencies must be justified

**Post-Implementation:**
- Perform simplification pass after features work
- Remove redundant artifacts from generation process
- Optimize for human readability and elegance

## Custom Claude Commands

Located in `.claude/commands/g/`:

- `/g:generate-prd` - Generate PRD using `docs/user-prd-template.md`
- `/g:generate-story` - Generate user story
- `/g:generate-task [task]` - Create implementation task spec in `docs/tasks/[task-name].md`
- `/g:issue` - Analyze and fix GitHub issues
- `/g:sprint-prd` - Execute Phase 0 contract definition

## Environment Configuration

Required environment variables (see `.env-example`):
```bash
GITHUB_TOKEN=""              # For GitHub operations
ANTHROPIC_API_KEY=""         # For Claude API
CODER_EXTERNAL_AUTH_0_*      # Coder OAuth configuration
LOCAL_CODER_CALLBACK_URL=""
REMOTE_CODER_CALLBACK_URL=""
```

## Important Context

1. **Always check `workflow-state.md` first** - It tracks current phase, issue, PR, and task context
2. **Use plugins for execution** - `/github`, `/feature-dev`, `/code-review` handle mechanics
3. **Prompts define our standards** - They specify how plugins should be used with our conventions
4. **When implementing features in `/app`**: Read `docs/tech_implementation.md` - architectural blueprint
5. **When expanding issues**: Use template from `prompts/01_issue_expansion.md`
6. **GitHub operations**: Use `/github` plugin (delegates to GitHub MCP tools)
7. **Branch naming**: `feature/issue-{number}-{short-description}`
8. **Commit format**: `feat: {description}` with `Closes #{issue-number}` in body
9. **Update workflow-state.md** - Check off items as you progress through phases
10. **The "product" is the Flow** - This repo perfects the AI development workflow itself
