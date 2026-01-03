# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an **AI-Driven Development Flow** system (a "Software Factory") that orchestrates the complete lifecycle from idea to implementation using AI agents and modular skills. The repository contains:

1. **The Flow System**: Five modular skills in `.claude/skills/` that orchestrate the complete workflow
2. **The Target Application**: A LangChain/LangGraph Deep Agent being built in `/app` using the [`langchain-ai/deepagents`](https://github.com/langchain-ai/deepagents) template
3. **Coder Integration**: Terraform configuration for running Claude Code as an AI agent within Coder workspaces

## Quick Start

**TL;DR**: Write idea in `idea.md` → Run `/ghflow-orchestrator` → Get PR

## Common Skills

### One-Time Setup
```bash
# IMPORTANT: Run this first when setting up ghflow on a project
/ghflow-project-setup       # Analyze project and populate implementation guide in CLAUDE.md
```

### Workflow Orchestration
```bash
# Complete workflow: Idea → Issue → Implementation → PR
/ghflow-orchestrator

# Individual workflow steps:
/ghflow-issue-expander      # Transform idea into GitHub issue
/ghflow-feature-implementer # Implement feature from issue (uses CLAUDE.md guide)
/ghflow-pr-creator          # Create pull request
/ghflow-code-reviewer       # Aggregate reviews and apply fixes
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

The repository implements a **skill-driven AI development workflow** where modular skills orchestrate the complete lifecycle from idea to merged PR:

**Modular Skills (`.claude/skills/`):**
Six specialized skills that work together:

0. **ghflow-project-setup** - Initializes project-specific implementation guidance
   - Analyzes codebase patterns and conventions
   - Populates "Feature Implementation Guide" section in CLAUDE.md
   - Eliminates need for codebase exploration during feature implementation
   - Scripts: `generate_implementation_guide.sh`, `update_claude_md.sh`
   - **Run this first when setting up ghflow on a project**

1. **ghflow-issue-expander** - Transforms ideas into comprehensive GitHub issues
   - Applies YAGNI/KISS/DRY principles
   - Creates issues with "HF-required" label for human review
   - Scripts: `create_issue.sh`, `save_issue.sh`

2. **ghflow-feature-implementer** - Implements features following project patterns
   - Reads project context from CLAUDE.md (populated by ghflow-project-setup)
   - Uses pyright-LSP for type checking (not codebase exploration)
   - Creates feature branches and implements with TDD
   - Scripts: `fetch_issue.sh`, `create_branch.sh`, `save_task.sh`

3. **ghflow-pr-creator** - Creates well-formatted pull requests
   - Validates branch naming (`feature/issue-X-description`)
   - Formats commits properly
   - Uses PR templates
   - Scripts: `validate_branch.sh`, `commit_changes.sh`, `create_pr.sh`

4. **ghflow-code-reviewer** - Aggregates reviews and applies fixes
   - Fetches CodeRabbit feedback
   - Categorizes issues (bugs, refactoring, style)
   - Applies fixes iteratively until approval
   - Scripts: `fetch_pr_reviews.sh`, `aggregate_reviews.sh`, `apply_fixes.sh`

5. **ghflow-orchestrator** - Coordinates the complete workflow
   - Manages 6-phase workflow (Issue → Review → Implement → PR → Review → Merge)
   - Tracks state in `workflow-state.md`
   - Invokes other skills in sequence
   - Scripts: `init_workflow.sh`, `check_eligible_issues.sh`, `poll_label.sh`

**Skill Dependency Chain:**
```
[ONE-TIME SETUP]
ghflow-project-setup → Populates CLAUDE.md "Feature Implementation Guide"

[WORKFLOW]
ghflow-orchestrator
  └─> ghflow-issue-expander (Phase 1)
  └─> [Human Review Gate] (Phase 2)
  └─> ghflow-feature-implementer (Phase 3) [Reads CLAUDE.md guide]
       └─> ghflow-pr-creator (Phase 4)
            └─> ghflow-code-reviewer (Phase 5-6)
```

**The Complete Flow:**
1. User writes idea in `idea.md` or provides direct input
2. `ghflow-orchestrator` invokes `ghflow-issue-expander` to create GitHub issue with "HF-required" label
3. Human reviews and removes label when ready
4. `ghflow-feature-implementer` fetches issue, explores codebase, implements with TDD
5. `ghflow-pr-creator` validates branch, commits, creates PR
6. CodeRabbit reviews PR automatically
7. `ghflow-code-reviewer` aggregates feedback to `docs/coderabbit/{pr_id}.md` and applies fixes
8. Cycle continues until PR approved and merged

**Workflow State Tracking:**
- `workflow-state.md` - **CHECK THIS FIRST** - Tracks current phase, issue, PR, and task details
- Updated by all skills via `scripts/update_workflow_state.sh`
- Managed by orchestrator throughout lifecycle

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
- Working directory: `/home/coder/gh-flow-hack`
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

## Skill Architecture

All skills located in `.claude/skills/`:

**Skill Structure:**
```
skill-name/
├── SKILL.md           # Workflow, instructions, patterns
├── scripts/           # Executable automation (bash)
├── references/        # Documentation loaded as needed
└── assets/            # Templates used in output
```

**Shared Resources:**
- `.claude/skills/shared/scripts/` - Common utilities (update_workflow_state.sh, gh_helpers.sh)
- Skills use GitHub CLI (`gh`) for all GitHub operations
- No MCP tools required - pure scripting approach

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
2. **Use skills for workflow** - Six modular skills orchestrate the complete development flow
3. **Skills are self-contained** - Each has SKILL.md with workflow, scripts for automation, and references
4. **Run ghflow-project-setup first** - Populates "Feature Implementation Guide" in CLAUDE.md for feature-implementer
5. **When implementing features**: ghflow-feature-implementer reads CLAUDE.md guide (no codebase exploration needed)
6. **When expanding issues**: `ghflow-issue-expander` applies YAGNI/KISS/DRY principles automatically
7. **GitHub operations**: All skills use `gh` CLI via scripts (no MCP tools needed)
8. **Type checking**: Use pyright-LSP for type validation (not manual code reading)
9. **Branch naming**: `feature/issue-{number}-{short-description}`
10. **Commit format**: `<type>: <description>` with `Closes #{issue-number}` in body
11. **Update workflow-state.md** - All skills update via `scripts/update_workflow_state.sh`
12. **Skill invocation chain** - Setup → Orchestrator → Issue Expander → Feature Implementer → PR Creator → Code Reviewer
13. **The "product" is the Flow** - This repo perfects the AI development workflow itself
