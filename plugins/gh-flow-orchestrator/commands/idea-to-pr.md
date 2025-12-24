---
description: Transform idea from idea.md into GitHub issue and optionally implement it end-to-end
---

# GitHub Flow Orchestrator - Idea to PR

You are the orchestrator for the complete Software Factory workflow starting from an idea.

## Your Task

Read the idea from `idea.md`, expand it into a GitHub issue, create the issue, and either wait for human review or proceed directly to implementation based on user preference.

## Step 1: Read Idea

Read `/Users/jneiku/code/gh-flow-hack/idea.md` to get the raw idea.

## Step 2: Expand Idea to Issue

Use the template from `/Users/jneiku/code/gh-flow-hack/prompts/01_issue_expansion.md` to transform the idea into a comprehensive issue specification.

**Apply our standards**:
- YAGNI, KISS, DRY (see `.claude/PRINCIPLES.md`)
- Focus on requirements, not implementation details
- Be specific and testable

**Generate**:
- Problem statement
- User story (As a... I want... so that...)
- Requirements checklist
- Acceptance criteria checklist
- Verification & testing steps

## Step 3: Create GitHub Issue

Use GitHub MCP tool `mcp__github__create_issue` to create the issue:

**Parameters**:
- `title`: Feature name from expanded content
- `body`: Full markdown content from Step 2
- `labels`: `["HF-required"]` (blocks implementation until human reviews)

**Save locally**:
- Write expanded content to `docs/issues/issue_{number}.md`

**Update state tracker**:
- Update `workflow-state.md`:
  - Issue number
  - Issue URL
  - Issue file path
  - Check Phase 1 items

## Step 4: Report to User

Announce the created issue:
```
Created GitHub issue for implementation:
- Issue #{number}: {title}
- URL: {url}
- Local file: docs/issues/issue_{number}.md

Next steps:
1. Review the issue on GitHub
2. Remove "HF-required" label when ready to implement
3. Run /gh-flow-orchestrator:check-and-implement to start implementation

Or to auto-implement without review, run:
/gh-flow-orchestrator:idea-to-pr --auto-implement
```

## Step 5: Optional Auto-Implementation

If user provided `--auto-implement` flag or explicitly requested it:

1. **Remove HF-required label** via GitHub MCP `mcp__github__remove_label`
2. **Spawn issue-implementer subagent** with phrasing:
   ```
   Use the issue-implementer subagent to implement issue #{number}
   ```

## Input Parameters

- `--auto-implement` (optional): Skip human review and implement immediately
- `--no-label` (optional): Don't add HF-required label (equivalent to auto-implement)

## Critical Guidelines

- **Use GitHub MCP tools** for all GitHub operations
- **Follow our templates** from `/prompts/01_issue_expansion.md`
- **Apply our principles** from `.claude/PRINCIPLES.md`
- **Update workflow state** in `workflow-state.md`
- **Default to human review** unless explicitly told to auto-implement

## GitHub MCP Tools Reference

**Available MCP Functions**:
- `mcp__github__create_issue` - Create new issue
- `mcp__github__remove_label` - Remove label from issue (for auto-implement)
- File tools: Read, Write (for local file operations)

## Success Criteria

You have succeeded when:
1. ✅ Idea read from `idea.md`
2. ✅ Issue expanded using our template
3. ✅ GitHub issue created with correct label
4. ✅ Local file saved to `docs/issues/issue_{number}.md`
5. ✅ `workflow-state.md` updated with issue details
6. ✅ User informed of next steps
7. ✅ (If auto-implement) Subagent spawned for implementation

## Example Usage

### Manual Review (Default)
```
/gh-flow-orchestrator:idea-to-pr
```
Creates issue with HF-required label, waits for human review.

### Auto-Implement (No Review)
```
/gh-flow-orchestrator:idea-to-pr --auto-implement
```
Creates issue and immediately implements without human review.

## Integration with Workflow

This command automates **Phases 1-2** of our workflow:
- Phase 1: Issue Expansion (from `plan.md`)
- Phase 2: GitHub Issue Creation (from `plan.md`)
- (Optional) Phase 3: Skip human review gate
- (Optional) Phases 4-6: Trigger implementation (from `implement.md`)
