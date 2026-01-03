---
name: ghflow-pr-creator
description: This skill should be used when users want to create a pull request with proper branch naming (feature/issue-X-desc), commit formatting (feat/fix/etc description, Closes #X), and structured PR template via GitHub CLI.
---

# GitHub Flow PR Creator

## Overview

Create well-formatted pull requests following project conventions for branch naming, commit messages, and PR descriptions. Automatically invoke code review after PR creation.

## Workflow

### Step 1: Validate Branch Name

Ensure current branch follows naming convention: `feature/issue-X-description`

```bash
scripts/validate_branch.sh $(git branch --show-current)
```

Expected format:
- Prefix: `feature/`
- Issue reference: `issue-X` (where X is the issue number)
- Description: lowercase with hyphens (e.g., `add-user-authentication`)

**Example:** `feature/issue-42-add-dark-mode`

### Step 2: Stage and Commit Changes

Commit all changes with proper formatting:

```bash
scripts/commit_changes.sh <issue_number> <type> "<description>"
```

**Commit Message Format:**
```
<type>: <description>

Closes #<issue_number>

🤖 Generated with Claude Code
Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code refactoring
- `docs`: Documentation changes
- `test`: Test additions/modifications
- `chore`: Build process or auxiliary tool changes

### Step 3: Create Pull Request

Generate PR using template and create via GitHub CLI:

```bash
scripts/create_pr.sh <issue_number> <pr_title>
```

The script will:
1. Read PR template from `assets/pr-template.md`
2. Generate PR body with:
   - Summary of changes
   - Link to issue (`Closes #X`)
   - Test plan
   - Claude Code attribution
3. Create PR via `gh pr create`
4. Return PR number and URL

### Step 4: Update Workflow State

Record PR creation in workflow state:

```bash
scripts/update_workflow_state.sh "Phase 4" "pr_number" "$pr_number"
scripts/update_workflow_state.sh "Phase 4" "pr_url" "$pr_url"
```

### Step 5: Invoke Code Reviewer

**CRITICAL**: After PR is created, immediately invoke the `ghflow-code-reviewer` skill.

```
Invoke the `ghflow-code-reviewer` skill to aggregate and address code review feedback.

**If `ghflow-code-reviewer` skill is not found, STOP and report error to user.**
```

The code reviewer will:
- Wait for automated reviews (CodeRabbit)
- Aggregate feedback
- Apply fixes iteratively until approval

### Step 6: Report Completion

Inform user:
- PR number and URL
- Branch name
- Commit summary
- Next step: Code review initiated

## Branch Naming Convention

**Format:** `feature/issue-<number>-<short-description>`

**Rules:**
- All lowercase
- Use hyphens for spaces
- Include issue number
- Keep description concise (3-5 words max)

**Valid Examples:**
- `feature/issue-42-add-authentication`
- `feature/issue-100-fix-memory-leak`
- `feature/issue-7-update-readme`

**Invalid Examples:**
- `feature-42` (missing issue prefix)
- `feature/42-add-auth` (missing "issue-" prefix)
- `feature/issue-42-Add-Auth` (uppercase not allowed)
- `add-authentication` (missing feature/ prefix)

## Commit Message Format

**Structure:**
```
<type>: <imperative description>

Closes #<issue_number>

🤖 Generated with Claude Code
Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

**Rules:**
- First line: type + colon + space + lowercase description
- Imperative mood ("add feature" not "adds feature" or "added feature")
- No period at end of first line
- Blank line before body
- Body includes issue reference
- Attribution footer

**Example:**
```
feat: add dark mode toggle to settings

Closes #42

🤖 Generated with Claude Code
Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

## Scripts

### scripts/validate_branch.sh
Validates branch name format. Exits with error if invalid.

### scripts/commit_changes.sh
Stages and commits all changes with proper formatting.

**Usage:**
```bash
scripts/commit_changes.sh <issue_number> <type> "<description>"
```

### scripts/create_pr.sh
Creates PR using template and GitHub CLI.

**Usage:**
```bash
scripts/create_pr.sh <issue_number> "<pr_title>"
```

**Returns:** PR number and URL

### scripts/update_workflow_state.sh
Updates workflow-state.md with PR information.

## Assets

### assets/pr-template.md
Template structure for PR descriptions with sections for summary, testing, and attribution.

### assets/commit-template.txt
Commit message template with placeholders for type, description, and issue number.

## Important Notes

- **Skill Dependency**: MUST invoke `ghflow-code-reviewer` after PR creation
- **Fail Loudly**: If ghflow-code-reviewer not found, stop and report error
- **Consistency**: Follow conventions strictly for project uniformity
- **Attribution**: Always include Claude Code attribution in commits and PRs
