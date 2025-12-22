# QUICKREF.md - Essential Technical Reference

## Core Stack
```yaml
Framework: LangGraph 0.6.2 + LangChain 0.3.27
Testing: pytest 8.4 + ruff 0.12
Python: 3.12+ (via uv)
Server: http://localhost:8080
```

## Key Paths
```bash
src/graph_*.py                   # Graph workflows
src/schemas.py                   # State definitions
src/prompts.py                   # LLM prompts
src/tools/                       # Custom tools
tests/unit_tests/                 # Test files
```

## Commands
```bash
# Quick Start
make install                      # Setup
npm run dev:agent                 # Start server (port 8080)

# Development
make test                         # Unit tests
make lint                         # Linting
make format                       # Auto-format
make test_all                     # All tests

# Validation
make test -k test_name            # Specific test
curl localhost:8080/health        # Health check
```

## Available Graphs
- `astrology` - Natal chart analysis

## Implementation Pattern
```python
# Standard graph structure
def create_graph():
    workflow = StateGraph(StateSchema)
    workflow.add_node("node_name", node_function)
    workflow.add_edge(START, "node_name")
    return workflow.compile()
```

## Testing Pattern
```python
def test_feature():
    result = function(valid_input)
    assert result.status == "success"

def test_error_handling():
    result = function(invalid_input)
    assert "error" in result
```

## Dependencies
See `pyproject.toml` for full list

## Environment
See `.env.local.example` for required API keys