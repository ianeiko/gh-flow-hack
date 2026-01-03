---
name: ghflow-feature-implementer
description: This skill should be used when users want to implement a feature from a GitHub issue, following project patterns from CLAUDE.md, using pyright-LSP for type checking, creating feature branches, and ensuring YAGNI/KISS/DRY principles are applied throughout.
---

# GitHub Flow Feature Implementer

## Overview

Implement features from GitHub issues following project patterns defined in CLAUDE.md. Use pyright-LSP for type checking, create proper branches, implement with TDD approach, and invoke PR creation when complete.

## Workflow

### Step 1: Fetch Issue Details

Retrieve the issue specification:

```bash
scripts/fetch_issue.sh <issue_number>
```

The script fetches:
- Issue title and description
- Requirements and acceptance criteria
- Testing specifications
- Labels and metadata

### Step 2: Read Project Context

**CRITICAL**: Read project context from CLAUDE.md before writing code.

**Project Context Source:**

Read the **"Feature Implementation Guide"** section in CLAUDE.md which contains:
- Project-specific patterns and conventions
- Architecture overview and key abstractions
- Code organization structure
- Testing approach and requirements
- Common utilities and helpers
- Integration points

**This section is populated by the `ghflow-project-setup` skill during project initialization.**

**Type Checking:**

Use pyright-LSP for type checking and navigation:
- Hover over symbols for type information
- Jump to definitions
- Find references
- Check for type errors before committing

### Step 3: Create Feature Branch

Create branch following naming convention:

```bash
scripts/create_branch.sh <issue_number> "<short-description>"
```

**Branch Format:** `feature/issue-<number>-<description>`

Example: `feature/issue-42-add-authentication`

### Step 4: Plan Implementation

Create task specification document:

```bash
scripts/save_task.sh <issue_number> "<task-name>"
```

**Task Plan Should Include:**
1. Files to create/modify
2. Components to build
3. Tests to write
4. Dependencies to add
5. Potential risks

**Apply YAGNI/KISS/DRY:**
- Implement only current requirements
- Choose simplest solution
- Avoid duplication
- Don't speculate about future needs

### Step 5: Implement Feature

**Implementation Order:**

1. **Write Tests First (TDD)**
   - Create test file in appropriate location
   - Write failing tests for requirements
   - Define expected behavior

2. **Implement Core Functionality**
   - Follow project patterns from CLAUDE.md "Feature Implementation Guide"
   - Use pyright-LSP to verify types as you code
   - Reference existing code only when necessary for specific integration points
   - Type all functions and tools properly

3. **Make Tests Pass**
   - Implement minimal code to pass tests
   - Refactor for clarity
   - Ensure all tests pass

4. **Integration**
   - Wire into main agent
   - Test with overall system
   - Verify no breaking changes

**Code Quality Standards:**

- **Typing**: All functions must have type hints
- **Documentation**: Docstrings for tools (LLM reads them)
- **Modularity**: Tools in `/tools`, not in main.py
- **Testing**: Test all critical paths
- **Present-Focused**: No comments referencing removed code

### Step 6: Verify Implementation

**Checklist:**

- [ ] All acceptance criteria met
- [ ] All tests pass
- [ ] No pyright-LSP type errors
- [ ] No breaking changes
- [ ] Code follows project patterns from CLAUDE.md
- [ ] Documentation updated
- [ ] Dependencies justified

**Type Check:**
```bash
# Use pyright-LSP via IDE or CLI
pyright
```

**Run Tests:**
```bash
pytest
```

### Step 7: Update Workflow State

Record implementation progress:

```bash
scripts/update_workflow_state.sh "Phase 3" "implementation_status" "complete"
scripts/update_workflow_state.sh "Phase 3" "branch_name" "$branch_name"
```

### Step 8: Invoke PR Creator

**CRITICAL**: After implementation complete, immediately invoke `ghflow-pr-creator` skill.

```
Implementation complete. Invoking `ghflow-pr-creator` skill to create pull request.

**If `ghflow-pr-creator` skill is not found, STOP and report error to user.**
```

The PR creator will:
- Validate branch name
- Commit changes with proper format
- Create PR via GitHub CLI
- Invoke code reviewer

### Step 9: Report Completion

Inform user:
- Feature implemented successfully
- Branch created: `feature/issue-X-description`
- Tests passing
- Next step: PR creation initiated

## Deep Agents Framework Patterns

### Agent Initialization Pattern

```python
from deepagents import create_deep_agent
from langchain_openai import ChatOpenAI

def build_agent():
    model = ChatOpenAI(model="gpt-4o")

    agent = create_deep_agent(
        model=model,
        system_prompt="You are a specialized software engineer...",
        tools=[...],
        enable_todos=True,  # DO NOT REMOVE
        enable_fs=True      # DO NOT REMOVE
    )
    return agent
```

### Tool Definition Pattern

```python
from langchain_core.tools import tool

@tool
def my_custom_tool(arg1: str, arg2: int) -> str:
    """
    Description of what this tool does.

    Args:
        arg1: Description of arg1
        arg2: Description of arg2

    Returns:
        Description of return value
    """
    # Implementation
    return "result"
```

### Sub-Agent Pattern

```python
# app/subagents/reviewer.py
from deepagents import create_deep_agent

reviewer_agent = create_deep_agent(
    model=ChatOpenAI(model="gpt-4o"),
    system_prompt="You are a strict code reviewer...",
    tools=[lint_code]
)
```

### Directory Structure

```
app/
├── main.py              # Entrypoint: Compiles graph
├── agent.py             # Main agent configuration
├── state.py             # Custom state extensions
├── tools/               # Custom tools
│   ├── __init__.py
│   └── custom_tool.py
└── subagents/           # Specialized sub-agents
    ├── __init__.py
    └── reviewer.py
```

## Development Principles

### YAGNI (You Aren't Gonna Need It)
- Implement only current requirements
- No speculative features
- No "just in case" abstractions

### KISS (Keep It Simple, Stupid)
- Simplest solution that works
- Avoid over-engineering
- Clear, readable code

### DRY (Don't Repeat Yourself)
- Abstract common functionality
- Eliminate duplication
- Reuse existing code

### Test-Driven Development
- Write tests first
- Red → Green → Refactor
- Tests as documentation

### Present-Focused Code
- No comments about removed code
- No "old version" references
- Only document current implementation

## Scripts

### scripts/fetch_issue.sh
Fetches issue details via `gh issue view`.

**Usage:**
```bash
scripts/fetch_issue.sh <issue_number>
```

**Returns:** Issue JSON with all details

### scripts/create_branch.sh
Creates feature branch with proper naming.

**Usage:**
```bash
scripts/create_branch.sh <issue_number> "<description>"
```

**Example:**
```bash
scripts/create_branch.sh 42 "add-authentication"
# Creates: feature/issue-42-add-authentication
```

### scripts/save_task.sh
Saves implementation task plan to `docs/tasks/`.

**Usage:**
```bash
scripts/save_task.sh <issue_number> "<task-name>"
```

**Output:** `docs/tasks/{task-name}.md`

### scripts/update_workflow_state.sh
Updates workflow-state.md with implementation progress.

## References

### references/tech_blueprint.md
Complete architectural blueprint for the Deep Agents framework including patterns, structure, and development rules.

## Important Notes

- **Skill Dependency**: MUST invoke `ghflow-pr-creator` after implementation
- **Fail Loudly**: If ghflow-pr-creator not found, stop and report error
- **Context Source**: Read CLAUDE.md "Feature Implementation Guide" section (populated by ghflow-project-setup)
- **No Codebase Exploration**: Don't search entire codebase for patterns - use CLAUDE.md context
- **Use pyright-LSP**: Type checking via LSP, not manual code reading
- **TDD Approach**: Write tests before implementation
- **Type Everything**: All functions must have type hints - verified by pyright
- **Follow Project Patterns**: Adhere to conventions in CLAUDE.md
