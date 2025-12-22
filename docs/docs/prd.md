# AI-Driven Development Flow PRD

> **AI Agent Optimized**: This PRD defines the workflow and tooling required to implement a semi-autonomous development pipeline involving AI agents and automated reviews.

## Overview

### Problem Statement
The current development process involves manual orchestration between defining requirements, coding, and reviewing. We need a streamlined, automated flow that leverages AI for heavy lifting while keeping humans in control of high-level direction and quality assurance.

### Solution Summary
**MVP**: A defined 10-step lifecycle for features: from simple text prompt -> AI Refinement -> Implementation -> Code Rabbit Review -> Automated Fixes -> Follow-on Cleanup.
**Vision**: A "Software Factory" where ideas become high-quality, reviewed code with minimal human friction.

### Success Criteria
**MVP Success** (Phase 2):
- [ ] Pipeline executes all 10 steps for a sample feature.
- [ ] Code Rabbit comments are successfully parsed into Agent tasks.
- [ ] Follow-on cleanup stories are automatically generated with correct context.
- [ ] Human intervention is limited to high-value "Feedback" steps (Step 3 & Step 10).

## Product Context

### User Stories
**MVP Stories**:
- As a **Product Owner**, I want to start a feature with a single sentence (Step 1) so that I don't get bogged down in template filling.
- As a **Developer**, I want the agent to automatically address Code Rabbit reviews (Step 7) so that I don't have to manually fix style or logic nits.
- As a **Tech Lead**, I want verbose LLM code to be flagged for a specific refactoring follow-up (Steps 8-9) so that the main PR remains focused on functionality while technical debt is managed immediately.

## Technical Requirements

### The 10-Step Workflow

#### 1. Issue Creation
- **Trigger**: Simple text prompt entering the system.
- **Output**: A raw issue/ticket entry.

#### 2. Draft Issue Rework
- **Process**: Agent takes the simple prompt and expands it.
- **Output**: A "Draft Issue" containing detailed requirements, context, and acceptance criteria.

#### 3. Human Feedback (Planning)
- **Process**: Human interacts with the Draft Issue.
- **Output**: Adjusted details, finalized specification.

#### 4. Implementation Phase
- **Process**: Development Agent reads the finalized spec and writes code.
- **Output**: Code committed to a local/feature branch.

#### 5. PR Creation
- **Process**: Agent pushes code and opens a Pull Request against `main`.
- **Output**: A live PR URL.

#### 6. Automated Review
- **Process**: Code Rabbit runs on the new PR.
- **Output**: Automated review comments on the PR.

#### 7. Agent Review Integration
- **Process**: Notify a specialized agent that Code Rabbit has commented.
- **Action**: Pull specific sections/comments from Code Rabbit.
- **Output**: A generated Task List for the agent relative to the feedback.

#### 8. Follow-on Assessment
- **Process**: Assess the code for "LLM verbosity" or redundancy.
- **Action**: Determine if a follow-on cleanup story is needed.
- **Context**: LLM code often works but is verbose; we keep the strict refactoring prompts here.

#### 9. Direction Placement
- **Process**: Place the specific cleanup/refactoring directions into the Follow-on Story/Task.
- **Output**: A created/drafted Follow-on Issue for "Refactoring & Cleanup".

#### 10. Loop & Finalize
- **Process**:
    1. Agent pushes fixes based on Step 7.
    2. Code Rabbit runs again.
    3. Human performs final feedback/review.
- **Output**: Merged PR.

## Architecture Overview

### Agent Infrastructure
- **Orchestrator**: Needs to manage state between steps (Issue -> Draft -> PR -> Review).
- **Integrations**:
    - GitHub API (Issues, PRs, Comments).
    - Code Rabbit Webhooks/Events.

### Data Models
```typescript
interface DevelopmentTask {
  id: string;
  originalPrompt: string;
  status: 'draft' | 'implementation' | 'review' | 'refactor';
  prUrl?: string;
  codeRabbitComments?: CodeRabbitComment[];
}
```

## Implementation Plan

### Phase 1: Core Pipeline (Steps 1-5)
- [ ] Implement "Prompt to Draft Issue" agent workflow.
- [ ] Implement "Draft to Code" agent capability.
- [ ] Automate PR creation.

### Phase 2: Review Intelligence (Steps 6-10)
- [ ] Integrate Code Rabbit feedback loop.
- [ ] Build "Comment to Task" parser.
- [ ] Implement "Follow-on Story" generator with refactoring context.

## Integration Checkpoints
- **Checkpoint A**: Can we go from text -> PR automated?
- **Checkpoint B**: Does the agent successfully fix issues identified by Code Rabbit?
- **Checkpoint C**: Are follow-on cleanup tasks created with the correct "Prompt Instructions"?

## Agent Instructions for this PRD
- When implementing this flow, build modular "nodes" for each step.
- Ensure the "Human Feedback" steps are blocking—the agent must wait for approval/input.
- Prioritize the **Code Rabbit -> Agent** loop (Step 7), as this is the high-leverage feature.
