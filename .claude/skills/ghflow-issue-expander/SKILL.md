---
name: ghflow-issue-expander
description: This skill should be used when users want to transform a simple idea (from idea.md or direct input) into a comprehensive GitHub issue with problem statement, user story, requirements, acceptance criteria, and test plan, then create it via GitHub CLI.
---

# GitHub Flow Issue Expander

## Overview

Transform simple ideas into comprehensive, well-structured GitHub issues following YAGNI/KISS/DRY principles. Create issues via GitHub CLI with proper labeling and local documentation.

## Workflow

### Step 1: Gather Input

Collect the idea from one of these sources:
- Read from `idea.md` file if it exists
- Accept direct user input
- Extract from user message

### Step 2: Expand into Comprehensive Issue

Transform the idea using the issue template format (see `references/issue-template.md`):

1. **Problem Statement**: Articulate the core problem in 2-3 clear sentences
2. **User Story**: Frame as "As a [Role], I want [Feature], so that [Benefit]"
3. **Requirements**: List specific, measurable requirements as checkboxes
4. **Acceptance Criteria**: Define testable criteria for completion
5. **Verification & Testing**:
   - Automated tests (unit, integration)
   - Manual verification steps

**Apply Standards** (from `references/principles.md`):
- **YAGNI**: Only current requirements, no speculative features
- **KISS**: Simplest solution that satisfies requirements
- **DRY**: Eliminate duplication, abstract common functionality
- **Testability**: All criteria must be verifiable and measurable

### Step 3: Create GitHub Issue

Use the GitHub CLI to create the issue:

```bash
# Source helper functions
source scripts/create_issue.sh

# Create issue and capture number
issue_number=$(create_github_issue "Issue Title" "Issue Body")
```

The script will:
- Create the issue on GitHub
- Automatically add the "HF-required" label (indicates human review needed)
- Return the issue number

### Step 4: Save Local Documentation

Save the issue content locally for reference:

```bash
# Save to docs/issues/ directory
scripts/save_issue.sh "$issue_number" "issue-content.md"
```

### Step 5: Report Completion

Inform the user:
- Issue number created
- Link to GitHub issue
- Location of local documentation
- Next step: Human must review and remove "HF-required" label when ready

## Scripts

### scripts/create_issue.sh
Creates a GitHub issue via `gh issue create` and adds the "HF-required" label.

**Usage:**
```bash
create_github_issue "title" "body"
```

**Returns:** Issue number

### scripts/save_issue.sh
Saves issue content to `docs/issues/issue_{number}.md`.

**Usage:**
```bash
scripts/save_issue.sh <issue_number> <content_file>
```

## References

### references/issue-template.md
Complete template structure for GitHub issues with all required sections.

### references/principles.md
YAGNI, KISS, DRY principles and testing philosophy to apply when expanding issues.

## Important Notes

- **Standalone Skill**: This skill does NOT invoke other skills after completion
- **Human Gate**: The "HF-required" label signals human review is needed before implementation
- **Quality Focus**: Take time to create thorough, well-thought-out issues
- **Testability**: Every requirement and criteria must be testable
- **Simplicity**: Avoid over-engineering in the issue specification
