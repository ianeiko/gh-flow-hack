---
name: ghflow-project-setup
description: This skill should be used during project initialization to analyze the codebase, identify patterns and conventions, and populate the Feature Implementation Guide section in CLAUDE.md for use by ghflow-feature-implementer.
---

# GitHub Flow Project Setup

## Overview

Analyze project structure, identify patterns and conventions, and create comprehensive implementation guidance in CLAUDE.md. This skill sets up the "Feature Implementation Guide" section that ghflow-feature-implementer uses instead of exploring the entire codebase.

## When to Use

Run this skill when:
- Starting a new project with ghflow
- Project architecture has changed significantly
- Adding new patterns or conventions
- Onboarding new developers/agents to the project
- Feature implementer reports missing context

## Workflow

### Step 1: Analyze Project Structure

Examine the project to identify:

**Code Organization:**
- Directory structure and module organization
- Where different types of code live (models, views, utils, etc.)
- Configuration file locations
- Entry points and main modules

**Key Patterns:**
- Common abstractions and base classes
- Decorator patterns used
- Dependency injection approach
- Error handling patterns
- Logging conventions

**Architecture:**
- Framework used (if any)
- Design patterns employed
- Layer separation (presentation, business, data)
- Plugin/extension mechanisms

### Step 2: Identify Testing Conventions

Document testing approach:

**Test Organization:**
- Test directory structure
- Test file naming conventions
- Where unit vs integration vs E2E tests live

**Testing Patterns:**
- Fixture usage
- Mocking conventions
- Test data setup/teardown
- Assertion styles

**Test Requirements:**
- Coverage expectations
- What must be tested
- When to write unit vs integration tests

### Step 3: Document Common Utilities

Identify reusable helpers:

**Utilities and Helpers:**
- Common utility modules
- Shared functions and classes
- Configuration loaders
- Database helpers
- API clients

**Integration Points:**
- How modules connect
- Event systems
- Message queues
- External service integrations

### Step 4: Capture Type and Style Conventions

Document coding standards:

**Type Conventions:**
- Type hint requirements
- Custom types and TypedDicts
- Generic usage patterns
- Optional vs None handling

**Style Guide:**
- Naming conventions (files, classes, functions, variables)
- Import organization
- Docstring format
- Comment style

### Step 5: Generate Implementation Guide

Create comprehensive guide for CLAUDE.md:

```bash
scripts/generate_implementation_guide.sh > /tmp/implementation_guide.md
```

The guide should include:

1. **Project Overview** (2-3 sentences)
2. **Architecture Summary** (key patterns and design)
3. **Code Organization** (directory structure guide)
4. **Common Patterns** (abstractions and conventions)
5. **Testing Requirements** (when/what/how to test)
6. **Utilities Reference** (commonly used helpers)
7. **Integration Points** (how to connect new code)
8. **Type Conventions** (typing requirements and patterns)
9. **Example Implementations** (1-2 typical features)

### Step 6: Update CLAUDE.md

Insert or update the "Feature Implementation Guide" section:

```bash
scripts/update_claude_md.sh /tmp/implementation_guide.md
```

The script will:
- Locate existing "Feature Implementation Guide" section (if present)
- Replace with new content or insert after "Development Principles"
- Preserve other sections unchanged
- Create backup before updating

### Step 7: Validate Guide Quality

**Quality Checklist:**

- [ ] Guide is specific to THIS project (not generic)
- [ ] Includes concrete examples from actual codebase
- [ ] Covers all major code areas (models, views, services, etc.)
- [ ] Testing approach clearly explained
- [ ] Common utilities documented with usage examples
- [ ] Type conventions specific and actionable
- [ ] Integration points clearly mapped
- [ ] Under 500 lines (concise but comprehensive)

### Step 8: Report Completion

Inform user:
- Section added/updated in CLAUDE.md
- Key patterns identified
- Implementation guide ready for feature-implementer
- Location: CLAUDE.md "Feature Implementation Guide" section

## Implementation Guide Template

The generated guide should follow this structure:

```markdown
## Feature Implementation Guide

### Project Overview
[2-3 sentence description of what this project does and its tech stack]

### Architecture
**Pattern**: [e.g., MVC, Clean Architecture, Hexagonal]
**Key Abstractions**: [Main classes/interfaces that define the architecture]

**Directory Structure:**
```
project/
├── src/
│   ├── models/      # Data models and schemas
│   ├── services/    # Business logic
│   ├── api/         # API endpoints
│   └── utils/       # Shared utilities
├── tests/           # Test files mirroring src/
└── config/          # Configuration files
```

### Common Patterns

**[Pattern Name 1]:** [Brief description]
- When to use: [Specific scenarios]
- Example: [Code snippet or reference]

**[Pattern Name 2]:** [Brief description]
- When to use: [Specific scenarios]
- Example: [Code snippet or reference]

### Testing Requirements

**What to Test:**
- All public API methods
- Business logic edge cases
- Integration with external services

**Test Structure:**
```python
def test_feature_name():
    # Arrange: Set up test data
    # Act: Execute the code
    # Assert: Verify results
```

**Test Location:**
- Unit tests: `tests/unit/test_<module>.py`
- Integration: `tests/integration/test_<feature>.py`

### Common Utilities

**`utils.database`:**
- `get_connection()`: Get database connection
- `execute_query(sql, params)`: Safe parameterized queries

**`utils.validation`:**
- `validate_email(email)`: Email validation
- `sanitize_input(text)`: Input sanitization

**`utils.auth`:**
- `require_auth(func)`: Authentication decorator
- `get_current_user()`: Get authenticated user

### Integration Points

**Adding New API Endpoint:**
1. Create route in `src/api/routes/<module>.py`
2. Implement handler in `src/services/<module>_service.py`
3. Add tests in `tests/integration/test_<module>_api.py`

**Adding New Model:**
1. Define schema in `src/models/<name>.py`
2. Add migrations in `migrations/`
3. Create repository in `src/repositories/<name>_repo.py`

### Type Conventions

- All functions must have type hints for parameters and return values
- Use `typing.Optional[T]` for nullable types
- Custom types in `src/types/<module>_types.py`
- Use TypedDict for structured dictionaries

**Example:**
```python
from typing import Optional, List
from src.types.user_types import UserDict

def get_user(user_id: int) -> Optional[UserDict]:
    """Retrieve user by ID."""
    ...
```

### Example Implementation

**Adding a Simple CRUD Endpoint:**

1. **Model** (`src/models/item.py`):
   ```python
   from dataclasses import dataclass

   @dataclass
   class Item:
       id: int
       name: str
       price: float
   ```

2. **Service** (`src/services/item_service.py`):
   ```python
   def create_item(name: str, price: float) -> Item:
       # Business logic here
       ...
   ```

3. **API Route** (`src/api/routes/items.py`):
   ```python
   @router.post("/items")
   def create_item_endpoint(item_data: ItemCreate):
       return item_service.create_item(**item_data.dict())
   ```

4. **Tests** (`tests/integration/test_items_api.py`):
   ```python
   def test_create_item():
       response = client.post("/items", json={"name": "Test", "price": 9.99})
       assert response.status_code == 200
   ```
```

## Scripts

### scripts/generate_implementation_guide.sh
Analyzes project and generates implementation guide markdown.

**Usage:**
```bash
scripts/generate_implementation_guide.sh > /tmp/guide.md
```

**Output:** Markdown formatted implementation guide

### scripts/update_claude_md.sh
Updates CLAUDE.md with new implementation guide section.

**Usage:**
```bash
scripts/update_claude_md.sh <guide_file>
```

**Actions:**
- Backs up CLAUDE.md
- Inserts/updates "Feature Implementation Guide" section
- Preserves all other content

## Assets

### assets/implementation-guide-template.md
Complete template for Feature Implementation Guide with placeholders for project-specific content.

## Important Notes

- **Run During Setup**: This should be first skill run when setting up ghflow on a project
- **Keep Updated**: Re-run when architecture changes significantly
- **Be Specific**: Guide must be project-specific, not generic advice
- **Concise**: Keep under 500 lines - feature-implementer needs quick reference
- **Examples**: Include real code patterns from the actual project
- **No Duplication**: Don't repeat what's in other CLAUDE.md sections
- **For Agents**: Written for AI consumption, not human documentation
- **Standalone Skill**: Does not invoke other skills
