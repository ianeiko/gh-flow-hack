# Implementation & PR Workflow

**Track progress in `workflow-state.md`**

## Prerequisites
- Issue created and reviewed
- `HF-required` label removed
- Ready for implementation

---

## Phase 4: Implementation

**Delegation**: Use `/feature-dev` plugin

**Actions**:
1. Fetch issue via GitHub MCP tools
2. Create feature branch: `feature/issue-{number}-{description}`
3. Save task description to `docs/tasks/{task-name}.md`
4. Explore codebase for context
5. Plan implementation (keep minimal per YAGNI)
6. Implement following our standards
7. Add/update tests
8. Verify locally
9. Update `workflow-state.md` Phase 2 checklist

**Standards**: See `prompts/02_implementation.md`
- Code principles: YAGNI, KISS, DRY
- Tech blueprint: `docs/tech_implementation.md` (for Deep Agents)
- Keep changes focused, avoid over-engineering

---

## Phase 5: Pull Request

**Delegation**: Use `/github` plugin

**Actions**:
1. Review changes: `git status`, `git diff`
2. Commit with proper format (see below)
3. Push to remote
4. Create PR with our template (see below)
5. Link to issue: Include `Closes #{issue-number}`
6. Update `workflow-state.md` Phase 3 checklist

**Standards**: See `prompts/utility_create_pr.md`

### Branch Format
`feature/issue-{number}-{short-description}`

### Commit Format
```
feat: {description}

{detailed description if needed}

Closes #{issue-number}
```

### PR Template
```markdown
## Summary
{Brief description}

## Changes
- {Key changes}
- {Files modified/created}

## Related Issue
Closes #{issue-number}

## Test Plan
{Verification steps}

## Additional Notes
{Context or decisions}
```

---

## Phase 6: Review & Fix

**After PR created, Code Rabbit reviews automatically**

**Delegation**: Use `/code-review` plugin

**Actions**:
1. Aggregate feedback to `docs/coderabbit/{pr_id}.md` (`prompts/03_review_aggregation.md`)
2. Analyze for refactoring needs (`prompts/04_refactor_analysis.md`)
3. Apply fixes (`prompts/05_fix_application.md`)
4. Update `workflow-state.md` Phase 4 checklist
5. Repeat until PR approved

---

## Quick Reference

**Files**:
- Task: `docs/tasks/{task-name}.md`
- Standards: `prompts/02_implementation.md`, `prompts/utility_create_pr.md`
- Tech Blueprint: `docs/tech_implementation.md`
- State: `workflow-state.md`

**Plugins**:
- `/feature-dev` - Implementation
- `/github` - PR operations
- `/code-review` - Review & fixes
