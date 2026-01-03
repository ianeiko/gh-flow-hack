Executive Summary

  Transform current prompt-based workflow into 5 modular skills with "ghflow-" prefix. Eliminate redundant documentation, leverage scripts for GitHub operations (gh CLI), and convert external plugin dependencies to local skills.

  Current State Analysis

  Files to Scrap/Transform

  Primary Orchestration Docs (Redundant):
  - plan.md - High-level orchestration wrapper
  - implement.md - High-level orchestration wrapper

  Prompts Directory (Transform to Skills):
  - prompts/01_issue_expansion.md → ghflow-issue-expander
  - prompts/02_implementation.md → ghflow-feature-implementer
  - prompts/03_review_aggregation.md → ghflow-code-reviewer
  - prompts/04_refactor_analysis.md → ghflow-code-reviewer
  - prompts/05_fix_application.md → ghflow-code-reviewer
  - prompts/utility_*.md (3 files) → Scripts in skills

  Custom Commands (Transform to Skills):
  - .claude/commands/check-and-implement.md → ghflow-orchestrator
  - .claude/commands/idea-to-pr.md → ghflow-orchestrator
  - .claude/commands/g/issue.md → Merge into ghflow-feature-implementer
  - .claude/commands/g/generate-*.md (3 files) → NOT MIGRATING
  - .claude/commands/g/sprint-prd.md → NOT MIGRATING

  Keep as References:
  - docs/tech_implementation.md - Technical blueprint
  - docs/prd.md - PRD specification
  - .claude/PRINCIPLES.md - Core principles
  - workflow-state.md - WILL BE MANAGED BY ORCHESTRATOR SCRIPTS

  External Plugin Dependencies (CONVERT TO LOCAL):
  - /feature-dev plugin → ghflow-feature-implementer
  - /code-review plugin → ghflow-code-reviewer

  ---
  Proposed Skill Architecture (5 Skills)

  1. ghflow-issue-expander

  Purpose: Transform ideas → GitHub issues

  SKILL.md:
  - Issue template format
  - YAGNI/KISS/DRY standards application
  - Explicit call to ghflow-pr-creator after completion (fail if not found)

  Scripts:
  - scripts/create_issue.sh - Create GitHub issue via gh CLI
  - scripts/add_label.sh - Add "HF-required" label via gh CLI
  - scripts/save_issue.sh - Save issue to docs/issues/issue_{number}.md

  References:
  - references/principles.md (from .claude/PRINCIPLES.md)
  - references/issue-template.md (template structure)

  Replaces: prompts/01_issue_expansion.md, partial plan.md

  ---
  2. ghflow-feature-implementer

  Purpose: Implement features following project patterns

  SKILL.md:
  - Codebase exploration strategy
  - Implementation workflow
  - Branching strategy
  - Testing requirements
  - Explicit dependency: Calls ghflow-pr-creator when done (fail if not found)

  Scripts:
  - scripts/fetch_issue.sh - Get issue details via gh issue view
  - scripts/create_branch.sh - Create feature branch
  - scripts/save_task.sh - Save to docs/tasks/{task-name}.md
  - scripts/update_workflow_state.sh - Update workflow-state.md

  References:
  - references/tech_blueprint.md (from docs/tech_implementation.md)
  - references/deep_agents_patterns.md (Deep Agents architecture)

  Replaces:
  - prompts/02_implementation.md
  - .claude/commands/g/issue.md
  - /feature-dev plugin (EXTERNAL → LOCAL)
  - Partial implement.md

  Note: This converts the external /feature-dev plugin to local skill with our conventions.

  ---
  3. ghflow-pr-creator

  Purpose: Create PRs with proper formatting

  SKILL.md:
  - Branch naming conventions
  - Commit message format
  - PR template structure
  - Explicit dependency: Calls ghflow-code-reviewer after PR created (fail if not found)

  Scripts:
  - scripts/validate_branch.sh - Check branch name format
  - scripts/commit_changes.sh - Commit with proper format
  - scripts/create_pr.sh - Create PR via gh pr create
  - scripts/update_workflow_state.sh - Update workflow-state.md with PR info

  Assets:
  - assets/pr-template.md
  - assets/commit-template.txt

  Replaces:
  - prompts/utility_create_pr.md
  - Partial implement.md

  ---
  4. ghflow-code-reviewer

  Purpose: Aggregate reviews and apply fixes

  SKILL.md:
  - Review aggregation workflow
  - Refactoring analysis strategy
  - Fix application process
  - Iterative review cycle until approval
  - NO explicit skill dependencies (terminal skill in workflow)

  Scripts:
  - scripts/fetch_pr_reviews.sh - Get CodeRabbit comments via gh api
  - scripts/aggregate_reviews.sh - Save to docs/coderabbit/{pr_id}.md
  - scripts/apply_fixes.sh - Git commit fixes
  - scripts/check_approval.sh - Check if PR approved via gh pr view
  - scripts/update_workflow_state.sh - Mark review phase complete

  Replaces:
  - prompts/03_review_aggregation.md
  - prompts/04_refactor_analysis.md
  - prompts/05_fix_application.md
  - /code-review plugin (EXTERNAL → LOCAL)
  - Partial implement.md

  Note: This converts the external /code-review plugin to local skill with our conventions.

  ---
  5. ghflow-orchestrator

  Purpose: Orchestrate complete idea→PR flow

  SKILL.md:
  - Multi-phase workflow coordination (Phases 1-6)
  - State tracking via scripts
  - Explicit skill invocation chain:
    a. ghflow-issue-expander (fail if not found)
    b. Wait for HF-required label removal
    c. ghflow-feature-implementer (fail if not found)
    d. ghflow-pr-creator (fail if not found)
    e. ghflow-code-reviewer (fail if not found)
  - Error handling: Stop workflow if any skill missing

  Scripts:
  - scripts/init_workflow.sh - Initialize workflow-state.md
  - scripts/check_eligible_issues.sh - Find oldest issue without HF-required label
  - scripts/poll_label.sh - Check if HF-required removed
  - scripts/invoke_skill.sh - Generic skill invocation wrapper with existence check
  - scripts/cleanup_workflow.sh - Archive completed workflow state

  References:
  - references/workflow-phases.md (Phase 1-6 specification from prd.md)

  Replaces:
  - plan.md
  - implement.md
  - .claude/commands/idea-to-pr.md
  - .claude/commands/check-and-implement.md

  ---
  Shared Files Strategy

  Skills can share files across the repo. Scripts modify these shared locations:

  Shared Locations:
  - workflow-state.md - All skills update via scripts/update_workflow_state.sh
  - docs/issues/ - Created by ghflow-issue-expander
  - docs/tasks/ - Created by ghflow-feature-implementer
  - docs/coderabbit/ - Created by ghflow-code-reviewer

  Script Convention:
  Each skill includes scripts/update_workflow_state.sh (can be symlink or duplicate) to modify shared state file.

  ---
  GitHub Integration Strategy

  All GitHub operations use gh CLI via scripts:
  - gh issue create - Create issues
  - gh issue view - Fetch issue details
  - gh issue edit - Add/remove labels
  - gh pr create - Create PRs
  - gh pr view - Check PR status
  - gh api repos/{owner}/{repo}/pulls/{pr}/comments - Fetch reviews

  No MCP GitHub tools required - Pure scripting approach.

  ---
  Skill Invocation Pattern

  Explicit skill calling with failure handling:

  ## Next Step
  Invoke the `ghflow-pr-creator` skill to create the pull request.

  **Critical**: If `ghflow-pr-creator` skill is not found, STOP and report error to user. Do not attempt to create PR manually.

  In SKILL.md:
  ## Workflow Completion
  After completing implementation:
  1. Verify all tests pass
  2. Invoke `ghflow-pr-creator` skill (REQUIRED - fail if not found)
  3. Report completion to user

  This pattern ensures skills are modular but tightly integrated.

  ---
  Migration Strategy (MVP Focus)

  Phase 1: Foundation

  1. Use skill-creator to initialize 5 skill directories with "ghflow-" prefix
  2. Create shared script utilities (update_workflow_state.sh, etc.)
  3. Migrate static content to references/assets

  Phase 2: Core Skills (Sequential Implementation)

  Order matters due to dependencies:

  1. ghflow-issue-expander (no dependencies)
    - Simplest skill
    - Creates issues, adds labels
    - Saves to docs/issues/
  2. ghflow-pr-creator (standalone)
    - PR creation logic
    - Commit formatting
    - Independent of other skills
  3. ghflow-code-reviewer (standalone)
    - Review aggregation
    - Fix application
    - Terminal skill (no calls to others)
  4. ghflow-feature-implementer (depends on pr-creator)
    - Most complex
    - Implements feature
    - Calls ghflow-pr-creator when done
    - Convert from /feature-dev plugin patterns
  5. ghflow-orchestrator (depends on all others)
    - Orchestrates complete flow
    - Manages workflow-state.md
    - Invokes skills in sequence

  Phase 3: Test with Real Workflow

  1. Write idea to idea.md
  2. Run /ghflow-orchestrator
  3. Observe complete flow
  4. Iterate on issues

  Phase 4: Cleanup

  rm -rf prompts/
  rm plan.md implement.md
  rm -rf .claude/commands/g/
  rm .claude/commands/check-and-implement.md
  rm .claude/commands/idea-to-pr.md

  ---
  Skill Descriptions (Auto-Trigger)

  1. ghflow-issue-expander
  description: This skill should be used when users want to transform a simple idea (from idea.md or direct input) into a comprehensive GitHub issue with problem statement, user story, requirements, acceptance criteria, and test plan, then create it via GitHub CLI.

  2. ghflow-feature-implementer
  description: This skill should be used when users want to implement a feature from a GitHub issue, following Deep Agents framework patterns, exploring the codebase for context, creating feature branches, and ensuring YAGNI/KISS/DRY principles are applied throughout.

  3. ghflow-pr-creator
  description: This skill should be used when users want to create a pull request with proper branch naming (feature/issue-X-desc), commit formatting (feat: description, Closes #X), and structured PR template via GitHub CLI.

  4. ghflow-code-reviewer
  description: This skill should be used when users want to aggregate code review feedback from CodeRabbit or other reviewers via GitHub CLI, analyze refactoring needs, and systematically apply fixes until PR approval.

  5. ghflow-orchestrator
  description: This skill should be used when users want to execute the complete AI-driven development flow from idea to merged PR, orchestrating issue creation, human review gate, implementation, PR creation, and review cycles autonomously with state tracking.

  ---
  Key Design Decisions

  1. Script-Heavy Approach

  All GitHub operations, file I/O, and state management via scripts. Benefits:
  - Deterministic execution
  - Token efficient
  - Reusable across skills
  - Easy to debug

  2. Explicit Skill Dependencies

  Skills explicitly invoke each other and fail loudly if dependency missing:
  Invoke `ghflow-pr-creator` skill. If not found, STOP and report error.

  3. State Management in Orchestrator

  - workflow-state.md managed by orchestrator scripts
  - Other skills update via scripts/update_workflow_state.sh
  - Single source of truth for workflow progress

  4. Shared File Locations

  Skills modify shared locations:
  - docs/issues/
  - docs/tasks/
  - docs/coderabbit/
  - workflow-state.md

  5. Converting External Plugins

  - /feature-dev → ghflow-feature-implementer
    - Retain implementation workflow
    - Add our standards (YAGNI, Deep Agents patterns)
    - Use scripts for GitHub ops
  - /code-review → ghflow-code-reviewer
    - Retain review analysis approach
    - Add our fix application strategy
    - Use scripts for review fetching

  ---
  Implementation Checklist

  Phase 1: Foundation
  - Initialize 5 skill directories via skill-creator
  - Create shared scripts/update_workflow_state.sh
  - Create shared scripts/gh_helpers.sh (common GitHub operations)
  - Migrate .claude/PRINCIPLES.md → references
  - Migrate docs/tech_implementation.md → references

  Phase 2: Skills (In Order)
  - Implement ghflow-issue-expander
  - Implement ghflow-pr-creator
  - Implement ghflow-code-reviewer
  - Implement ghflow-feature-implementer
  - Implement ghflow-orchestrator

  Phase 3: Integration Test
  - Test ghflow-issue-expander standalone
  - Test ghflow-pr-creator standalone
  - Test ghflow-code-reviewer standalone
  - Test ghflow-feature-implementer → calls pr-creator
  - Test ghflow-orchestrator → complete flow

  Phase 4: Cleanup
  - Delete prompts/ directory
  - Delete plan.md, implement.md
  - Delete .claude/commands/g/ directory
  - Delete .claude/commands/check-and-implement.md
  - Delete .claude/commands/idea-to-pr.md
  - Update CLAUDE.md to reference skills instead of prompts

  ---
  Next Steps

  Awaiting approval to proceed with implementation.

  Questions addressed:
  1. ✅ GitHub integration via gh CLI scripts (not MCP)
  2. ✅ Explicit skill invocation with failure handling
  3. ✅ State management built into orchestrator scripts
  4. ✅ MVP focus, no tests
  5. ✅ No distribution, just get it working
  6. ✅ All skills prefixed with "ghflow-"
  7. ✅ External plugins converted to local skills

⏺ Plan updated with your requirements:

  Key Changes

  Scope Reduction:
  - 5 skills total (down from 8)
  - Removed 3 utility skills (prd-generator, story-generator, task-specifier)

  Architecture Updates:
  - All skills prefixed "ghflow-"
  - GitHub ops via gh CLI scripts (not MCP)
  - Scripts handle all I/O, state management, GitHub operations
  - Shared files (workflow-state.md, docs/issues/, etc.) modified by skill scripts

  External Plugin Conversion:
  - /feature-dev → ghflow-feature-implementer (local skill with our standards)
  - /code-review → ghflow-code-reviewer (local skill with our patterns)

  Skill Dependencies:
  - Explicit invocation chain
  - Fail loudly if dependency skill not found
  - Pattern: "Invoke ghflow-pr-creator. If not found, STOP and report error."

  State Management:
  - Built into ghflow-orchestrator scripts
  - workflow-state.md updated by all skills via shared script

  MVP Focus:
  - No tests
  - No distribution
  - Just get it working

  Implementation Order

  1. ghflow-issue-expander (standalone)
  2. ghflow-pr-creator (standalone)
  3. ghflow-code-reviewer (standalone)
  4. ghflow-feature-implementer (calls pr-creator)
  5. ghflow-orchestrator (orchestrates all)

  Ready to implement when approved.