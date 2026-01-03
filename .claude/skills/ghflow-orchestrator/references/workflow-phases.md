# Workflow Phases Specification

This document describes the 6-phase workflow for the AI-driven development flow.

## Phase 1: Draft Issue Creation
- **Input**: User idea from `idea.md` or direct input
- **Action**: Expand idea into comprehensive GitHub issue
- **Output**: GitHub issue created with "HF-required" label
- **Skill**: `ghflow-issue-expander`

## Phase 2: Human Review Gate
- **Input**: GitHub issue with "HF-required" label
- **Action**: Human reviews and removes label when approved
- **Output**: Issue ready for implementation
- **Trigger**: Manual label removal

## Phase 3: Feature Implementation
- **Input**: Approved GitHub issue (no HF-required label)
- **Action**: Implement feature following Deep Agents framework patterns
- **Output**: Feature implemented on feature branch
- **Skill**: `ghflow-feature-implementer`

## Phase 4: Pull Request Creation
- **Input**: Completed feature implementation
- **Action**: Create PR with proper formatting
- **Output**: GitHub PR created
- **Skill**: `ghflow-pr-creator`

## Phase 5: Automated Code Review
- **Input**: GitHub PR
- **Action**: CodeRabbit performs automated review
- **Output**: Review comments posted to PR
- **Trigger**: Automatic on PR creation

## Phase 6: Review & Fix Cycle
- **Input**: PR review comments
- **Action**: Aggregate feedback, analyze, and apply fixes
- **Output**: PR approved and ready for merge
- **Skill**: `ghflow-code-reviewer`

## State Tracking

All phases update `workflow-state.md` with:
- Current phase
- Issue number
- PR number
- Task details
- Completion checkmarks

## Success Criteria

The workflow is complete when:
- [ ] Issue created and approved
- [ ] Feature implemented
- [ ] PR created
- [ ] Reviews addressed
- [ ] PR approved
- [ ] All tests passing
