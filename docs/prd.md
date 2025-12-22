# AI-Driven Development Flow PRD

> **Concept**: A "Software Factory" flow where an Agent builds a **Target Application** (based on LangChain) using a strictly defined set of prompts and manual/scripted steps.

## Overview

### The Goal
To build a **Target Application** (a LangChain/LangGraph agent) by following a rigorous 10-step development flow. The "Product" here is the *Flow itself* (the prompts and process) that enables us to build the App reliability.

### The Target Application
The app we are building (the output of this flow) will be a **LangChain Deep Agent**.
- **Location**: `app/`
- **Architecture**: LangGraph (Nodes, Edges, State).
- **Starting Point**: [`langchain-ai/deepagents`](https://github.com/langchain-ai/deepagents) template.

## The "Flow" Assets

The "Flow" is defined by specific assets that guide the Agent (and Developer) through the lifecycle.

### 1. The Prompts (The "Instructions")
Located in `/prompts`, these drive the Implementation Agent at each step.

#### Core Prompts
| ID | File | Step | Role |
|----|------|------|------|
| **00** | `docs/user-prd-template.md` | Init | **User Input**: The User fills this out to define the *Target App*. |
| **01** | `prompts/01_issue_expansion.md` | 1 | **PM Agent**: Expands user text -> Draft Issue. |
| **02** | `prompts/02_implementation.md` | 5 | **Dev Agent**: Builds `app/` code based on Issue + `tech_implementation.md`. |
| **03** | `prompts/03_review_aggregation.md` | 8 | **QA Agent**: saves Code Rabbit "Prompt for AI Agents" comments only and saves them to `docs/coderabbit/{pr_id}.md` |
| **04** | `prompts/04_refactor_analysis.md` | 9 | **Architect Agent**: Address feedback from `docs/coderabbit/{pr_id}.md`
| **05** | `prompts/05_fix_application.md` | 11 | **Dev Agent**: Applies fixes to `app/`. |

#### Utility Prompts (MCP Tools)
| Name | File | Step | Action |
|------|------|------|--------|
| **Sync Issue** | `prompts/utility_sync_issue.md` | 3 | Syncs local markdown issue to GitHub. |
| **Start Impl** | `prompts/utility_start_implementation.md` | 4 | Removes `HF-required` label. |
| **Create PR** | `prompts/utility_create_pr.md` | 6 | Creates a PR from the current branch. |

### 2. The Reference Architecture (The "Blueprint")
- **File**: `docs/tech_implementation.md`
- **Purpose**: A technical guide that describes *how* to build the Target App.
- **Usage**: The Implementation Agent (Step 5) reads this file to ensure it uses correct LangGraph patterns, folder structures, and coding standards.

## The 10-Step Workflow

1.  **Draft Creation**: User provides a text prompt. Script uses **Prompt 01** to create a detailed Draft Issue in `docs/issues/issue_{N}.md`.
2.  **Draft Refinement**: LLM expands and refines the *local* markdown draft based on user feedback.
3.  **Issue Sync**: User is satisfied. Agent uses `prompts/utility_sync_issue.md` to push the local draft to the specific GitHub Issue.
4.  **Start Implementation**: Agent uses `prompts/utility_start_implementation.md` to remove the `HF-required` label, signaling readiness.
5.  **Implementation**:
    *   **Input**: Finalized Issue + `docs/tech_implementation.md` (The Blueprint).
    *   **Action**: Agent generates/modifies code in `app/`.
    *   **Context**: Agent understands it must follow the LangGraph architecture defined in the Blueprint.
6.  **PR Creation**: Agent uses `prompts/utility_create_pr.md` to commit changes and open a PR.
7.  **Automated Review**: Code Rabbit reviews the PR.
8.  **Review Aggregation**: User triggers aggregation. **Prompt 03** creates a todo list.
9.  **Assessment**: **Prompt 04** analyzes code for clean-up.
10. **Refinement Loop**: Agent uses **Prompt 05** to fix issues in `app/` until PR is merged.

## Success Criteria for the "Flow"
- [ ] **Prompt Library**: All 5 prompts are strictly defined and effective.
- [ ] **Blueprint**: `docs/tech_implementation.md` accurately describes a robust LangGraph architecture.
- [ ] **Output**: The flow successfully produces a working LangGraph agent in `app/`.
