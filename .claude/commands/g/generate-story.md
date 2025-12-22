## Usage
```
/g:generate-story [requirements]
```

Generate implementation story from @docs/story-requirements.md using @docs/story-template.md

**Steps**:
1. Parse requirements and identify core objective
2. Search codebase for existing patterns: `graph_*.py`, `schemas.py`
3. Generate concrete implementation tasks with specific file paths
4. Include MVP solution pattern with error handling
5. Output actionable tasks only (no template placeholders)
6. DO NOT IMPLEMENT the STORY. only save description to docs (see below)

**Focus**:
- MVP implementation with fallback responses
- Unit test with success + error cases
- Use `--c7` for LangGraph best practices
- Contract-first: Define interfaces before implementation

**Output**: Save to `docs/stories/[story-name].md` with:
- User story + acceptance criteria
- Solution pattern (pseudocode)
- Exact files to modify
- Test validation commands