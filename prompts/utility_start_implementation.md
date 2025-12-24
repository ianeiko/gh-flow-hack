# Implementation Gate Standards

## Delegation
**Use `/github` plugin for label management.**

## Our Standards
### Label: `HF-required` (Human Feedback Required)
- Added automatically when issue created
- Blocks implementation until removed
- Human reviews issue and removes label when ready
- Agent checks for label before starting implementation

### Starting Implementation
1. Verify `HF-required` label removed
2. Create feature branch: `feature/issue-{number}-{description}`
3. Save task description to `docs/tasks/{task-name}.md`
4. Update `workflow-state.md` Phase 2 checklist
5. Begin implementation using `/feature-dev` plugin
