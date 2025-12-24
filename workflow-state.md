# Workflow State Tracker

**Current Branch:** N/A
**Current Task File:** N/A
**Current Issue:** N/A
**Current PR:** N/A

---

## Quick Commands

**Start from idea:**
- `idea.md` (write your idea) → `/idea-to-pr --auto-implement`

**Or step by step:**
1. `idea.md` → `/idea-to-pr` (creates issue)
2. Review on GitHub, remove `HF-required` label
3. `/check-and-implement` (implements)

---

## Flow Progress

### Phase 1: Issue Creation
- [ ] Idea captured in `idea.md`
- [ ] Issue expanded using `prompts/01_issue_expansion.md` template
- [ ] GitHub issue created (use `/github` plugin)
- [ ] Issue labeled with `HF-required`
- [ ] Issue reviewed by human
- [ ] `HF-required` label removed (ready for implementation)

**Issue Details:**
- Issue Number: N/A
- Issue URL: N/A
- Issue File: N/A

---

### Phase 2: Implementation
- [ ] Feature branch created: `feature/issue-{number}-{description}`
- [ ] Task description saved to `docs/tasks/{task-name}.md`
- [ ] Codebase explored and context gathered
- [ ] Implementation plan created
- [ ] Code implemented following `docs/tech_implementation.md` blueprint
- [ ] Tests added/updated
- [ ] Local verification passed
- [ ] Changes committed with proper format

**Implementation Details:**
- Branch: N/A
- Task File: N/A
- Files Changed: N/A

---

### Phase 3: Pull Request
- [ ] Changes pushed to remote
- [ ] PR created (use `/github` plugin)
- [ ] PR linked to issue (includes `Closes #{issue-number}`)
- [ ] PR includes test plan

**PR Details:**
- PR Number: N/A
- PR URL: N/A

---

### Phase 4: Review & Fix
- [ ] Code Rabbit review received
- [ ] Review feedback aggregated (use `/code-review` plugin)
- [ ] Fixes applied (use `/code-review` plugin)
- [ ] Refactoring analysis completed (use `/code-review` plugin)
- [ ] All review comments addressed
- [ ] Tests passing
- [ ] PR approved

**Review Details:**
- Review File: N/A
- Feedback Items: N/A

---

### Phase 5: Merge & Cleanup
- [ ] PR merged to main
- [ ] Feature branch deleted (optional)
- [ ] Issue closed
- [ ] Workflow state reset for next task

---

## Quick Reference

### Active Files
- **Idea:** `idea.md`
- **Current Task:** See "Task File" above
- **Current Issue:** See "Issue File" above
- **Review Feedback:** `docs/coderabbit/{pr_id}.md`

### Plugin Commands
- `/github` - GitHub operations (issues, PRs, labels)
- `/feature-dev` - Feature development workflow
- `/code-review` - Code review and feedback aggregation

### Our Standards
- **Branch:** `feature/issue-{number}-{description}`
- **Commit:** `feat: {description}\n\nCloses #{issue-number}`
- **Principles:** See `.claude/PRINCIPLES.md` (YAGNI, KISS, DRY)
- **Tech Blueprint:** See `docs/tech_implementation.md` (Deep Agents patterns)

---

## Notes
<!-- Track context, decisions, blockers here -->
