## Feature Implementation Guide

### Project Overview
[2-3 sentence description of what this project does and its tech stack]

### Architecture
**Pattern**: [e.g., MVC, Clean Architecture, Hexagonal, Layered]
**Framework**: [e.g., Django, FastAPI, Flask, Express, None]
**Key Abstractions**: [Main classes/interfaces that define the architecture]

**Directory Structure:**
```
project/
├── [main_dir]/
│   ├── [subdir]/    # [Description]
│   ├── [subdir]/    # [Description]
│   └── [subdir]/    # [Description]
├── tests/           # Test files
└── [config_dir]/    # Configuration
```

### Common Patterns

**[Pattern Name 1]:** [Brief description of pattern]
- **When to use**: [Specific scenarios where this pattern applies]
- **Example**: [Code snippet or file reference from actual codebase]
  ```python
  # Example code
  ```

**[Pattern Name 2]:** [Brief description of pattern]
- **When to use**: [Specific scenarios where this pattern applies]
- **Example**: [Code snippet or file reference from actual codebase]
  ```python
  # Example code
  ```

### Testing Requirements

**What to Test:**
- [Requirement 1]
- [Requirement 2]
- [Requirement 3]

**Test Structure:**
```python
def test_[feature_name]():
    # Arrange: Set up test data and dependencies

    # Act: Execute the code being tested

    # Assert: Verify expected results
```

**Test Organization:**
- Unit tests: `[path/to/unit/tests]`
- Integration tests: `[path/to/integration/tests]`
- E2E tests: `[path/to/e2e/tests]`

**Test Fixtures:**
- [Fixture pattern or location]
- [Common test utilities]

### Common Utilities

**`[module.name]`:**
- `[function_name]([args])`: [Description of what it does]
- `[function_name]([args])`: [Description of what it does]

**`[module.name]`:**
- `[function_name]([args])`: [Description of what it does]
- `[function_name]([args])`: [Description of what it does]

**`[module.name]`:**
- `[function_name]([args])`: [Description of what it does]
- `[function_name]([args])`: [Description of what it does]

### Integration Points

**Adding [Component Type 1]:**
1. [Step 1 with file path]
2. [Step 2 with file path]
3. [Step 3 with file path]
4. [Testing step]

**Adding [Component Type 2]:**
1. [Step 1 with file path]
2. [Step 2 with file path]
3. [Step 3 with file path]
4. [Testing step]

**Connecting to [External System]:**
- [Configuration location]
- [Client/adapter pattern]
- [Error handling approach]

### Type Conventions

- [Typing requirement or convention]
- [Type hint pattern for common cases]
- [Custom type location and usage]
- [Generic usage pattern]

**Example:**
```python
from typing import [imports]

def [function_name]([params]) -> [return_type]:
    """[Docstring with type documentation]."""
    ...
```

### Example Implementation

**[Feature Name - e.g., "Adding a CRUD Endpoint"]:**

1. **[Component 1 Name]** (`[file/path.py]`):
   ```python
   # Concrete example from actual codebase
   ```

2. **[Component 2 Name]** (`[file/path.py]`):
   ```python
   # Concrete example from actual codebase
   ```

3. **[Component 3 Name]** (`[file/path.py]`):
   ```python
   # Concrete example from actual codebase
   ```

4. **[Tests]** (`[test/file/path.py]`):
   ```python
   # Concrete test example from actual codebase
   ```

---

**Note:** This guide should be populated with project-specific information during setup. Replace all placeholders with actual project details.
