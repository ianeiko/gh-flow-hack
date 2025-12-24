# Implementation Standards

## Delegation
**Use `/feature-dev` plugin for implementation workflow.**

## Our Standards
### Code Principles (`.claude/PRINCIPLES.md`)
- **YAGNI**: Implement only current requirements
- **KISS**: Simplest solution that works
- **DRY**: Abstract common functionality

### Tech Blueprint (`docs/tech_implementation.md`)
For Deep Agents app in `/app`:
1. Use `create_deep_agent` factory (don't reinvent graph)
2. Preserve middleware (`enable_todos=True`, `enable_fs=True`)
3. Type all tools with docstrings
4. Modularize tools in `/tools`
5. Test compilation: `python app/main.py`

### Implementation Checklist
1. Read issue requirements
2. Explore codebase for context
3. Plan changes (keep minimal)
4. Implement following our blueprint
5. Add/update tests
6. Verify locally
7. Save task description to `docs/tasks/{task-name}.md`
