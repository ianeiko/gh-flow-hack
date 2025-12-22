# AI-Driven Development Flow PRD

> **AI Agent Optimized**: This PRD defines the workflow and tooling required to implement a local-first, semi-autonomous development pipeline involving AI agents and automated reviews.

## Overview

### Problem Statement
The current development process involves manual orchestration between defining requirements, coding, and reviewing. We need a streamlined, automated flow that leverages AI for heavy lifting while keeping humans in control of high-level direction and quality assurance.

### Solution Summary
**MVP**: A defined 10-step lifecycle for features: from simple text prompt -> AI Refinement -> Local Agent Implementation -> Manual Code Rabbit Aggregation -> Automated Fixes -> Follow-on Cleanup.
**Vision**: A "Software Factory" where ideas become high-quality, reviewed code with minimal human friction, executed primarily on local machines.

### Success Criteria
**MVP Success** (Phase 2):
- [ ] Pipeline executes all 10 steps for a sample feature locally.
- [ ] Code Rabbit comments are manually aggregated into a single markdown file.
- [ ] Agent successfully reads and addresses the aggregated comments.
- [ ] Local GitHub MCP is used for Issue and PR management.

## Product Context

### User Stories
**MVP Stories**:
- As a **Developer**, I want to trigger the implementation agent by feeding it a drafted issue locally (Step 4), so I don't need complex remote orchestration.
- As a **Developer**, I want to aggregate Code Rabbit reviews into a single markdown file (Step 7) so the agent can batch-fix all issues at once.
- As a **Tech Lead**, I want to use standard GitHub tools via a local MCP server to manage the flow without context switching.

## Technical Requirements

### The 10-Step Workflow

#### 1. Issue Creation
- **Trigger**: Simple text prompt.
- **Action**: Use **Local GitHub MCP** to create a raw issue.
- **Output**: An Issue #ID. store in docs/nextissue.md

#### 2. Draft Issue Rework
- **Process**: LLM expands the simple prompt.
- **Action**: Update the Issue body via **GitHub MCP**.
- **Output**: A "Draft Issue" containing detailed requirements.

#### 3. Human Feedback (Planning)
- work on the next issue (and reference to it would in docs/nextissue.md)
- **Process**: Human interacts with the Draft Issue on GitHub.
- **Output**: Finalized specification in the Issue.

#### 4. Implementation Phase (Local Trigger)
- **Process**: Developer reads the Issue (via LLM/GitHub MCP) and feeds it to the **Local Development Agent**.
- **Action**: Agent writes code to a local branch.
- **Output**: Code committed locally.

#### 5. PR Creation
- **Process**: Agent pushes code and uses **GitHub MCP** to open a Pull Request against `main`.
- **Output**: A live PR URL.

#### 6. Automated Review
- **Process**: Code Rabbit runs on the new PR (External/GitHub Action).
- **Output**: Automated review comments on the PR.

#### 7. Manual Review Aggregation
- **Process**: Developer (or Script) fetches Code Rabbit comments.
- **Action**: Compile all comments into a single markdown file (e.g., `docs/code-rabbit-review.md`).
- **Output**: A local file containing all feedback.

#### 8. Follow-on Assessment
- **Process**: Assess the code for "LLM verbosity".
- **Action**: Determine if a follow-on cleanup story is needed.
- **Context**: Keep strict refactoring prompts for this phase.

#### 9. Direction Placement
- **Process**: Place specific cleanup directions into a new Follow-on Issue.
- **Action**: Use **GitHub MCP** to create the cleanup task.
- **Output**: A new Issue for "Refactoring & Cleanup".

#### 10. Loop & Finalize
- **Process**:
    1. Agent reads `docs/code-rabbit-review.md`.
    2. Agent applies fixes.
    3. Push to branch.
    4. Code Rabbit runs again.
- **Output**: Merged PR.

## Architecture Overview

### Local Agent Infrastructure
- **Runtime**: Local machine (CLI/Script driven).
- **Tooling**:
    - **Local GitHub MCP**: For all Issue/PR interactions.
    - **File System**: For code editing and review storage.

### Data Models
```typescript
interface DevelopmentTask {
  id: string; // GitHub Issue ID
  originalPrompt: string;
  status: 'draft' | 'implementation' | 'review' | 'refactor';
  localReviewFile?: string; // Path to aggregated Code Rabbit comments
}
```

## Implementation Plan

### Phase 1: Local Pipeline (Steps 1-5)
- [ ] Setup Local GitHub MCP connection.
- [ ] Create script/workflow to "Expand Prompt to Issue".
- [ ] Create script/workflow to "Implement from Issue".

### Phase 2: Review Loop (Steps 6-10)
- [ ] Create script/tool to fetch PR comments (via GitHub MCP) and save to Markdown.
- [ ] Create agent capability to "Fix from Markdown Review".
- [ ] Implement "Follow-on Issue" generator.

## Agent Instructions for this PRD
- **GitHub MCP is Key**: All GitHub interactions must go through the MCP server tools (e.g., `github_create_issue`, `github_list_comments`).
- **Manual Bridges**: Where we don't have webhooks (like Code Rabbit -> Agent), we use a file-based bridge (Markdown file).
- **Local Execution**: Assume the agent runs locally with full filesystem access.
