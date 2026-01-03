# Hello World Test Project

Simple Python script for testing ghflow workflow.

## Feature Implementation Guide

### Project Overview
Simple hello world Python script for testing. Prints "Hello, World!" to stdout.

### Architecture
**Pattern**: Simple script
**Framework**: None

**Directory Structure:**
```
project/
├── main.py          # Main entry point
└── test_main.py     # Tests
```

### Common Patterns

**Print Output:** Use print() for all output
- When to use: For any new greeting features
- Example: `print("Hello, World!")`

### Testing Requirements

**What to Test:**
- Output matches expected string
- No errors raised

**Test Structure:**
```python
def test_feature(capsys):
    # Call function
    # Capture output with capsys
    # Assert expected value
```

**Test Location:**
- All tests in `test_*.py` files

### Common Utilities

None - simple script with no utilities.

### Integration Points

**Adding New Greeting:**
1. Modify `main()` function in `main.py`
2. Add test in `test_main.py`
3. Run `pytest test_main.py`

### Type Conventions

- Add type hints to all functions: `def func(x: str) -> None:`
- Use built-in types from `typing` module
- Example:
```python
def main() -> None:
    """Print greeting to stdout."""
    print("Hello, World!")
```

### Example Implementation

**Adding a Custom Greeting:**

1. **Update main.py:**
   ```python
   import sys

   def main() -> None:
       name = sys.argv[1] if len(sys.argv) > 1 else "World"
       print(f"Hello, {name}!")
   ```

2. **Add tests:**
   ```python
   def test_custom_greeting(monkeypatch, capsys):
       monkeypatch.setattr(sys, 'argv', ['main.py', 'Alice'])
       main()
       captured = capsys.readouterr()
       assert captured.out == "Hello, Alice!\n"
   ```
