# Refactor Analysis Standards

## Delegation
**Use `/code-review` plugin for refactoring analysis.**

## Our Standards (`.claude/PRINCIPLES.md`)
### LLM Antipatterns to Flag
- Excessive comments explaining obvious code
- Redundant error handling for impossible scenarios
- Over-engineered abstractions for simple tasks
- Backwards-compatibility hacks (unused `_vars`, `// removed` comments)
- Premature abstractions (helpers for one-time operations)

### Post-Implementation Cleanup
After features work and pass review:
- Simplification pass to slim down code
- Remove generation artifacts
- Optimize for human readability and elegance

### Output
- If cleanup needed: Task title and description for follow-up issue
- If clean: "NO_ACTION"
