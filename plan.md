# Issue Creation Workflow

**Track progress in `workflow-state.md`**

## Phase 1: Issue Expansion

**Input**: `idea.md` (simple one-sentence idea)

**Actions**:
1. Read `idea.md`
2. Expand using template from `prompts/01_issue_expansion.md`
3. Apply our standards:
   - YAGNI, KISS, DRY (`.claude/PRINCIPLES.md`)
   - Focus on requirements, not implementation
   - Be specific and testable

**Output**: Expanded issue specification with:
- Problem statement
- User story
- Requirements
- Acceptance criteria
- Verification & testing steps

---

## Phase 2: GitHub Issue Creation

**Delegation**: Use `/github` plugin

**Actions**:
1. Create issue with expanded content
2. Add `HF-required` label (auto-created if doesn't exist)
3. Save to `docs/issues/issue_{number}.md`
4. Update `workflow-state.md`:
   - Issue number
   - Issue URL
   - Issue file path
   - Check Phase 1 items

**Standards**: See `prompts/utility_sync_issue.md`

---

## Phase 3: Human Review Gate

**Manual Step**: Human reviews issue and removes `HF-required` label when ready

**Proceed to**: `implement.md` workflow when label removed

---

## Quick Reference

**Files**:
- Idea: `idea.md`
- Template: `prompts/01_issue_expansion.md`
- Standards: `prompts/utility_sync_issue.md`
- State: `workflow-state.md`

**Plugin**: `/github`
