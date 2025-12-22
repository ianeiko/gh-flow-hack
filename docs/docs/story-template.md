# [Story Title]

## User Story
**As a** [user], **I want** [functionality] **so that** [value/outcome]

## Acceptance Criteria
- [ ] [Testable behavior or outcome]
- [ ] [Unit test validates requirement]
- [ ] [Error handling works correctly]

## Dependencies
- [Required library/system/feature/API that must exist]

## Implementation Tasks

### 1. Analysis
- [ ] Search codebase for similar patterns
- [ ] Identify files to modify: `graph_*.py`, `schemas.py`, `tools/`

### 2. Implementation
- [ ] **Graph**: Modify `agent/src/agent/graph_[type].py`
- [ ] **State**: Update `agent/src/agent/schemas.py`
- [ ] **Prompts**: Add to `agent/src/agent/prompts.py`
- [ ] **Tools**: Create in `agent/src/agent/tools/` if needed

### 3. Testing
- [ ] Write unit test with happy path + error case
- [ ] Run: `cd agent && make test`
- [ ] Run: `make lint`

## Solution Pattern
```python
# Pseudocode/implementation pattern
# [Core logic here]
```

## Validation
```bash
cd agent && make test -k test_[feature]
make lint
curl localhost:8080/health
```