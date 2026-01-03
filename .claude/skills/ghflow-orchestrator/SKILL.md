---
name: ghflow-orchestrator
description: This skill should be used when users want to execute the complete AI-driven development flow from idea to merged PR, orchestrating issue creation, human review gate, implementation, PR creation, and review cycles autonomously with state tracking.
---

# GitHub Flow Orchestrator

## Overview

Orchestrate the complete AI-driven development workflow from idea to merged pull request. Coordinate all phases including issue expansion, human approval, feature implementation, PR creation, and code review cycles with comprehensive state tracking.

## Complete Workflow Phases

The orchestrator manages a 6-phase workflow (see `references/workflow-phases.md` for details):

1. **Phase 1**: Draft Issue Creation
2. **Phase 2**: Human Review Gate
3. **Phase 3**: Feature Implementation
4. **Phase 4**: Pull Request Creation
5. **Phase 5**: Automated Code Review
6. **Phase 6**: Review & Fix Cycle

## Usage Modes

### Mode 1: Idea to PR (Full Automation)

Transform an idea directly into a merged PR with human review gate.

**Usage:**
```
Execute full workflow from idea.md to merged PR
```

**Process:**
1. Read idea from `idea.md` or user input
2. Invoke `ghflow-issue-expander` to create GitHub issue
3. Wait for human to remove "HF-required" label
4. Invoke `ghflow-feature-implementer` for implementation
5. (Feature implementer invokes `ghflow-pr-creator`)
6. (PR creator invokes `ghflow-code-reviewer`)
7. Monitor until PR is merged

### Mode 2: Implement Eligible Issue

Find and implement the oldest eligible issue (without HF-required label).

**Usage:**
```
Check for eligible issues and implement the next one
```

**Process:**
1. Find oldest issue without "HF-required" label
2. Invoke `ghflow-feature-implementer` for implementation
3. Continue through PR and review phases
4. Monitor until PR is merged

## Detailed Workflow

### Phase 1: Draft Issue Creation

**Objective:** Transform idea into comprehensive GitHub issue.

**Actions:**
1. Initialize workflow state
   ```bash
   scripts/init_workflow.sh
   ```

2. Verify `ghflow-issue-expander` skill exists
   ```bash
   scripts/invoke_skill.sh ghflow-issue-expander
   ```
   **If skill not found → STOP and report error**

3. Invoke issue expander with idea content

4. Update workflow state with issue number
   ```bash
   scripts/update_workflow_state.sh "Phase 1" "issue_number" "$issue_number"
   scripts/update_workflow_state.sh "Phase 1" "status" "complete"
   ```

**Success Criteria:**
- GitHub issue created with #number
- Issue has "HF-required" label
- Local documentation saved to `docs/issues/`

### Phase 2: Human Review Gate

**Objective:** Wait for human approval to proceed with implementation.

**Actions:**
1. Inform user that human review is required
2. Poll for label removal
   ```bash
   scripts/poll_label.sh <issue_number> "HF-required"
   ```

3. Update workflow state when label removed
   ```bash
   scripts/update_workflow_state.sh "Phase 2" "human_approved" "true"
   scripts/update_workflow_state.sh "Phase 2" "status" "complete"
   ```

**Success Criteria:**
- "HF-required" label removed from issue
- Human approval confirmed

### Phase 3: Feature Implementation

**Objective:** Implement the feature from the approved issue.

**Actions:**
1. Verify `ghflow-feature-implementer` skill exists
   ```bash
   scripts/invoke_skill.sh ghflow-feature-implementer
   ```
   **If skill not found → STOP and report error**

2. Invoke feature implementer with issue number

3. Feature implementer will:
   - Fetch issue details
   - Explore codebase
   - Create feature branch
   - Implement with TDD
   - Run tests
   - Invoke `ghflow-pr-creator` when done

**Success Criteria:**
- Feature implemented on feature branch
- All tests passing
- PR creator invoked

**Note:** Phase 4 (PR Creation) is automatically triggered by the feature implementer.

### Phase 4: Pull Request Creation

**Objective:** Create well-formatted PR (automatic via feature implementer).

**This phase is handled automatically by `ghflow-pr-creator` skill.**

**Success Criteria:**
- PR created on GitHub
- PR has proper formatting
- Code reviewer invoked

**Note:** Phase 5-6 (Code Review & Fix Cycle) are automatically triggered by the PR creator.

### Phase 5-6: Code Review & Fix Cycle

**Objective:** Address review feedback until PR approval (automatic via PR creator).

**This phase is handled automatically by `ghflow-code-reviewer` skill.**

**Success Criteria:**
- All review feedback addressed
- PR approved
- All checks passing

### Final Phase: Completion

**Objective:** Archive workflow state and report completion.

**Actions:**
1. Verify PR is merged or ready to merge

2. Archive workflow state
   ```bash
   scripts/cleanup_workflow.sh
   ```

3. Report final status to user

**Success Criteria:**
- PR merged or approved
- Workflow state archived
- User informed of completion

## Skill Invocation Chain

The orchestrator must invoke skills in this exact order:

```
ghflow-orchestrator
  └─> ghflow-issue-expander (Phase 1)
        └─> Creates issue with HF-required label

  [WAIT FOR HUMAN REVIEW]

  └─> ghflow-feature-implementer (Phase 3)
        └─> Implements feature
        └─> ghflow-pr-creator (Phase 4)
              └─> Creates PR
              └─> ghflow-code-reviewer (Phase 5-6)
                    └─> Reviews and fixes until approval
```

**Critical Error Handling:**
- If ANY skill is not found → STOP immediately
- Report missing skill to user
- Do not attempt to proceed without all skills

## State Tracking

All phases update `workflow-state.md`:

```markdown
# Workflow State

**Current Phase:** Phase 3
**Started:** 2024-01-15 10:30:00

## Phase 1: Issue Creation
- [x] Issue created: #42
- [x] Label added: HF-required
- [x] Local documentation saved

## Phase 2: Human Review
- [x] Human approved
- [x] Label removed

## Phase 3: Implementation
- [x] Feature branch created: feature/issue-42-add-auth
- [x] Implementation complete
- [x] Tests passing

## Phase 4: PR Creation
- [ ] PR number:
- [ ] PR URL:

## Phase 5-6: Code Review
- [ ] Reviews fetched
- [ ] Fixes applied
- [ ] PR approved
```

## Scripts

### scripts/init_workflow.sh
Initializes `workflow-state.md` with template.

**Usage:**
```bash
scripts/init_workflow.sh
```

### scripts/check_eligible_issues.sh
Finds oldest issue without "HF-required" label.

**Usage:**
```bash
scripts/check_eligible_issues.sh
```

**Returns:** Issue number or empty if none found

### scripts/poll_label.sh
Checks if specific label exists on issue.

**Usage:**
```bash
scripts/poll_label.sh <issue_number> "<label_name>"
```

**Returns:** 0 if label removed, 1 if still present

### scripts/invoke_skill.sh
Verifies skill exists and invokes it.

**Usage:**
```bash
scripts/invoke_skill.sh <skill_name>
```

**Exits with error if skill not found**

### scripts/cleanup_workflow.sh
Archives completed workflow state to `workflow-state-archive/`.

**Usage:**
```bash
scripts/cleanup_workflow.sh
```

### scripts/update_workflow_state.sh
Updates workflow-state.md with phase progress.

## References

### references/workflow-phases.md
Complete specification of all 6 workflow phases with success criteria and triggers.

## Error Handling

### Missing Skill

If any required skill is not found:
```
ERROR: Required skill 'ghflow-issue-expander' not found.

The orchestrator requires all of the following skills:
- ghflow-issue-expander
- ghflow-feature-implementer
- ghflow-pr-creator
- ghflow-code-reviewer

Please ensure all skills are installed before running the orchestrator.
```

### Human Approval Timeout

If human doesn't remove label within reasonable time:
```
WAITING: Issue #42 requires human review.

Remove the "HF-required" label when ready to proceed with implementation.

Current status: Waiting for approval (30 minutes elapsed)
```

### Implementation Failure

If any phase fails:
```
ERROR: Phase 3 (Implementation) failed.

Error: Tests did not pass after implementation.

The workflow has been paused. Check workflow-state.md for details.
Fix the issues and resume the workflow manually.
```

## Important Notes

- **Master Orchestrator**: This skill coordinates all other skills
- **State Management**: Maintains workflow-state.md throughout entire process
- **Error Propagation**: Fails loudly if any skill missing or phase fails
- **Human Gate**: Requires human approval after issue creation
- **Automatic Continuation**: Phases 3-6 run automatically once approved
- **No Manual Intervention**: Once approved, workflow runs to completion or error
- **Resume Capability**: Can resume from workflow-state.md if interrupted
