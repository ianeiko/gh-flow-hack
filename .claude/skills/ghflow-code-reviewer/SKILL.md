---
name: ghflow-code-reviewer
description: This skill should be used when users want to aggregate code review feedback from CodeRabbit or other reviewers via GitHub CLI, analyze refactoring needs, and systematically apply fixes until PR approval.
---

# GitHub Flow Code Reviewer

## Overview

Aggregate automated code review feedback, analyze refactoring opportunities, and systematically apply fixes until PR is approved. Iterative cycle that continues until all review concerns are addressed.

## Workflow

### Step 1: Wait for Automated Reviews

Allow time for CodeRabbit or other automated reviewers to complete their analysis.

**Strategy:**
- Check PR status periodically
- Wait for review comments to be posted
- Proceed when reviews are available

### Step 2: Fetch PR Reviews

Retrieve all review comments from the PR:

```bash
scripts/fetch_pr_reviews.sh <pr_number>
```

The script fetches:
- Code review comments
- Inline code suggestions
- General feedback
- Change requests

### Step 3: Aggregate Reviews

Process and save review feedback to local documentation:

```bash
scripts/aggregate_reviews.sh <pr_number>
```

This will:
- Parse review comments
- Extract actionable items
- Save to `docs/coderabbit/{pr_id}.md`
- Create categorized feedback (bugs, refactoring, style, etc.)

### Step 4: Analyze Refactoring Needs

Review the aggregated feedback and categorize issues:

**Categories:**
1. **Critical Bugs**: Must fix immediately
2. **Refactoring**: Code quality improvements
3. **Style Issues**: Formatting, naming conventions
4. **Documentation**: Missing or incorrect docs
5. **Testing**: Missing or inadequate tests
6. **Performance**: Optimization opportunities

**Prioritization:**
- Fix critical bugs first
- Address refactoring suggestions second
- Handle style/docs issues third
- Optimize performance last

### Step 5: Apply Fixes

Systematically address each feedback item:

```bash
# For each fix iteration
scripts/apply_fixes.sh <pr_number> "<fix_description>"
```

The script will:
1. Make code changes
2. Run tests to verify fixes
3. Commit changes with proper message format
4. Push to PR branch

**Commit Message Format:**
```
fix: address code review feedback - <specific fix>

Related to PR #<pr_number>
```

### Step 6: Check Approval Status

After each fix iteration, check if PR is approved:

```bash
scripts/check_approval.sh <pr_number>
```

**Possible States:**
- `APPROVED`: PR is approved, ready to merge
- `CHANGES_REQUESTED`: More fixes needed, return to Step 5
- `PENDING`: Still under review, wait and recheck

### Step 7: Iterative Fix Cycle

Continue the fix → push → check cycle until:
- All review feedback addressed
- PR status is `APPROVED`
- All automated checks pass

### Step 8: Update Workflow State

Mark review phase complete:

```bash
scripts/update_workflow_state.sh "Phase 6" "review_status" "approved"
scripts/update_workflow_state.sh "Phase 6" "pr_ready" "true"
```

### Step 9: Report Completion

Inform user:
- Number of review rounds completed
- Number of fixes applied
- PR approval status
- Ready for merge

## Review Analysis Strategy

### Identifying Critical vs Non-Critical Issues

**Critical (Fix Immediately):**
- Security vulnerabilities
- Logic errors
- Breaking changes
- Test failures
- Resource leaks

**Non-Critical (Fix After Critical):**
- Code style inconsistencies
- Minor performance improvements
- Documentation typos
- Optional refactoring suggestions

### Refactoring Priorities

1. **YAGNI Violations**: Remove speculative or unused code
2. **DRY Violations**: Eliminate duplication
3. **KISS Violations**: Simplify overly complex logic
4. **Naming**: Improve clarity and consistency
5. **Structure**: Improve code organization

## Fix Application Process

### Before Applying Fixes

1. Read the entire feedback document
2. Understand the root cause
3. Plan the fix approach
4. Consider impact on other code

### While Applying Fixes

1. Make minimal, targeted changes
2. Test each fix individually
3. Commit fixes separately when possible
4. Include context in commit messages

### After Applying Fixes

1. Run full test suite
2. Verify fix addresses original feedback
3. Check for new issues introduced
4. Update documentation if needed

## Scripts

### scripts/fetch_pr_reviews.sh
Fetches all review comments from PR via `gh api`.

**Usage:**
```bash
scripts/fetch_pr_reviews.sh <pr_number>
```

**Returns:** JSON with all review comments

### scripts/aggregate_reviews.sh
Processes review comments and saves to docs/coderabbit/.

**Usage:**
```bash
scripts/aggregate_reviews.sh <pr_number>
```

**Output:** `docs/coderabbit/{pr_id}.md`

### scripts/apply_fixes.sh
Applies code changes and commits with proper format.

**Usage:**
```bash
scripts/apply_fixes.sh <pr_number> "<fix_description>"
```

### scripts/check_approval.sh
Checks if PR is approved.

**Usage:**
```bash
scripts/check_approval.sh <pr_number>
```

**Returns:** `APPROVED`, `CHANGES_REQUESTED`, or `PENDING`

### scripts/update_workflow_state.sh
Updates workflow-state.md with review phase progress.

## Important Notes

- **Terminal Skill**: This skill does NOT invoke other skills after completion
- **Iterative Process**: May require multiple fix → review → fix cycles
- **Quality Focus**: Prioritize correctness over speed
- **Test Rigorously**: Ensure each fix doesn't introduce new issues
- **Document Changes**: Update docs and comments as fixes are applied
- **Completion Criteria**: PR must be approved before finishing
