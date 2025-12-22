## Usage
```
/g:generate-task [task]
```

Generate a focused implementation task using @docs/task-template.md for: [task]

**Execution Steps**:
1. Parse task requirements and identify core technical objective
2. Generate concrete pseudocode/pattern
3. Include specific file paths from project structure
4. Output only actionable content (remove template placeholders)
5. DO NOT IMPLEMENT the TASK. only save description to docs (see below)

**Technical Context** (auto-loaded from .claude/):
- Framework: LangGraph 0.6.2 with existing graphs in `agent/src/agent/graph_*.py`
- Testing: pytest with `make test` validation
- Key paths: schemas.py, prompts.py, tools/

**Implementation Focus**:
- MVP pattern with concrete code examples
- Error handling with fallback responses
- Unit test with success + error cases
- Use `--c7` flag for LangGraph best practices lookup

**Output**: Save to `docs/tasks/[task-name].md` with:
- Solution pattern (pseudocode)
- Exact files to modify
- Test validation commands