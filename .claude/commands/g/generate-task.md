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

**Implementation Focus**:
- MVP pattern with concrete code examples
- Error handling with fallback responses
- Unit test with success + error cases

**Output**: Save to `docs/tasks/[task-name].md` with:
- Solution pattern (pseudocode)
- Exact files to modify
- Test validation commands