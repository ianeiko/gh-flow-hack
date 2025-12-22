# Multi-Service Testing Guide

## Overview

This document provides comprehensive testing guidance for the Built-to-Win multi-service application, covering Test-Driven Development (TDD) practices and testing strategies for all three services:

- **Frontend** (Next.js 15, React 19, TypeScript)
- **Backend** (FastAPI, SQLModel, PostgreSQL)
- **Agent** (LangGraph, AI workflows)

Each service has specific testing requirements and tools, but all follow TDD principles for reliable, maintainable code.

## Test-Driven Development (TDD) Methodology

### TDD Cycle

Follow the **Red-Green-Refactor** cycle across all services:

1. **Red** - Write a failing test first
2. **Green** - Write minimal code to make the test pass
3. **Refactor** - Improve code while keeping tests passing

### TDD Benefits

- **Design-first approach** - Tests drive API and component design
- **Confidence in changes** - Comprehensive test coverage prevents regressions
- **Documentation** - Tests serve as living documentation
- **Faster debugging** - Issues are caught early and isolated quickly

### Service-Specific TDD Practices

#### Frontend TDD
- Start with component behavior tests
- Test user interactions before implementing handlers
- Mock external dependencies (APIs, hooks)
- Test responsive design with viewport tests

#### Backend TDD
- Start with API endpoint tests
- Test database models before implementing business logic
- Test authentication/authorization flows
- Test error handling and edge cases

#### Agent TDD
- Test individual nodes before graph composition
- Mock LLM responses for predictable testing
- Test state transformations and routing logic
- Test human-in-the-loop interactions

---

## Frontend Testing (Next.js 15, React 19, TypeScript)

### Testing Stack

- **Linting**: ESLint 9 with Next.js configuration
- **Type Checking**: TypeScript 5 compiler
- **Future Recommendations**: Consider adding Jest + React Testing Library

### Testing Patterns

#### Component Testing
```typescript
// Example: Testing AgentChat component
import { render, screen, fireEvent } from '@testing-library/react'
import { AgentChat } from '@/components/AgentChat'
import { useAgentChat } from '@/lib/hooks/useAgentChat'

// Mock the hook
jest.mock('@/lib/hooks/useAgentChat')

describe('AgentChat', () => {
  beforeEach(() => {
    (useAgentChat as jest.Mock).mockReturnValue({
      messages: [],
      isConnected: true,
      sendMessage: jest.fn()
    })
  })

  it('should render message input when connected', () => {
    render(<AgentChat />)
    expect(screen.getByPlaceholderText(/type your message/i)).toBeInTheDocument()
  })
})
```

#### Hook Testing
```typescript
// Example: Testing useAgentChat hook
import { renderHook, act } from '@testing-library/react'
import { useAgentChat } from '@/lib/hooks/useAgentChat'

describe('useAgentChat', () => {
  it('should manage connection state', () => {
    const { result } = renderHook(() => useAgentChat())

    expect(result.current.isConnected).toBe(false)

    act(() => {
      result.current.connect()
    })

    expect(result.current.isConnected).toBe(true)
  })
})
```

#### Type Safety Testing
```typescript
// Example: Testing TypeScript interfaces
import type { AgentMessage, AgentState } from '@/lib/types'

// Type tests - these should compile without errors
const validMessage: AgentMessage = {
  id: '123',
  content: 'Hello',
  timestamp: new Date(),
  sender: 'user'
}

const validState: AgentState = {
  messages: [validMessage],
  isProcessing: false,
  currentStep: 'waiting'
}
```

### Running Frontend Tests

```bash
# Navigate to frontend directory
cd frontend

# Linting (current setup)
npm run lint                # ESLint checking

# Type checking
npx tsc --noEmit           # TypeScript type checking

# Build test (validates all code)
npm run build              # Production build test

# Future: When test framework is added
npm test                   # Run Jest tests
npm run test:watch         # Watch mode
npm run test:coverage      # Coverage report
```

---

## Backend Testing (FastAPI, SQLModel, PostgreSQL)

### Testing Stack

- **Testing Framework**: pytest 8.4
- **Database**: SQLite for tests (faster than PostgreSQL)
- **HTTP Client**: httpx TestClient
- **Mocking**: unittest.mock
- **Code Quality**: ruff 0.12, mypy 1.17

### Testing Patterns

#### API Endpoint Testing
```python
# Example: Testing user endpoints
from fastapi.testclient import TestClient
from src.api.main import app

client = TestClient(app)

def test_get_user_authenticated():
    # Test with valid session
    response = client.get("/api/user", cookies={"session": "valid_token"})
    assert response.status_code == 200
    assert "email" in response.json()

def test_get_user_unauthenticated():
    # Test without session
    response = client.get("/api/user")
    assert response.status_code == 401
```

#### Database Model Testing
```python
# Example: Testing SQLModel models
from src.api.models import User
from src.api.database import get_test_session

def test_user_model_creation():
    with get_test_session() as session:
        user = User(
            email="test@example.com",
            name="Test User"
        )
        session.add(user)
        session.commit()

        # Verify user was created
        retrieved_user = session.get(User, user.id)
        assert retrieved_user.email == "test@example.com"
```

#### Authentication Testing
```python
# Example: Testing OAuth flow
from unittest.mock import patch
from src.api.auth import verify_session, create_session

def test_session_verification():
    # Test valid session
    user_data = {"email": "test@example.com", "name": "Test"}
    token = create_session(user_data)

    verified_user = verify_session(token)
    assert verified_user["email"] == "test@example.com"

def test_invalid_session():
    # Test invalid session
    invalid_token = "invalid.token.here"

    with pytest.raises(AuthenticationError):
        verify_session(invalid_token)
```

### Running Backend Tests

```bash
# Navigate to backend directory
cd backend

# Run tests
make test                  # Run unit tests

# Code quality
make lint                  # Run ruff linting
make format                # Format code with ruff

# Type checking
mypy src/                  # Run mypy type checking

# Coverage
pytest --cov=src --cov-report=html  # Generate coverage report
```

---

## Agent Testing (LangGraph AI Workflows)

### Why Test Nodes Individually?

LangGraph documentation emphasizes testing nodes individually because:

1. **Faster feedback** - Node tests run quickly without LLM calls
2. **Precise error isolation** - Issues can be pinpointed to specific nodes
3. **Better test coverage** - Edge cases and error conditions are easier to test
4. **Reduced dependencies** - Tests don't depend on external APIs or complex state

## Test Structure

### File Organization

- **`tests/unit_tests/test_graph_nodes.py`** - Individual node testing
- **`tests/unit_tests/test_tools.py`** - Tool-level testing (existing)
- **`tests/integration_tests/`** - Full graph integration tests

### Test Classes

Each node and utility function has its own test class:

- `TestCallModelNode` - Tests the LLM calling node
- `TestToolNode` - Tests the tool execution node
- `TestInterruptHandler` - Tests human-in-the-loop interruption
- `TestShouldContinueEdge` - Tests conditional routing logic
- `TestFormatState` - Tests utility functions
- `TestNodeIntegration` - Tests node interoperability

## Key Testing Patterns

### 1. Proper Mocking Strategy

```python
@patch('src.agent.graph.init_chat_model')
async def test_call_model_basic_functionality(self, mock_init_chat_model, sample_state, sample_config):
    # Mock the model chain properly
    mock_model = Mock()
    mock_model_with_tools = AsyncMock()

    # Setup async mock correctly
    mock_model_with_tools.ainvoke = AsyncMock(return_value=mock_response)
    mock_model.bind_tools = Mock(return_value=mock_model_with_tools)
    mock_init_chat_model.return_value = mock_model
```

**Key Points:**
- Use `Mock()` for synchronous methods
- Use `AsyncMock()` for async methods, but assign them properly
- Mock the entire call chain from `init_chat_model` down

### 2. State-Based Testing

```python
def test_call_model_state_handling(self):
    # Test with minimal state
    minimal_state = {
        "input_text": "Test input",
        "messages": []
    }

    result = await call_model(minimal_state, sample_config)

    # Validate state transformations
    assert "messages" in result
    # Check default values are applied correctly
```

**Key Points:**
- Test with complete, minimal, and edge-case states
- Verify state transformations are correct
- Check default value handling

### 3. Node Interface Testing

```python
def test_tool_node_basic_functionality(self):
    # Validate input/output contracts
    result = tool_node(sample_state_with_tool_call, sample_config)

    # Check return type matches expected ToolUpdate
    assert isinstance(result, dict)
    assert "current_text" in result
    assert "messages" in result
    assert isinstance(result["messages"], list)
```

**Key Points:**
- Verify input/output interfaces match type hints
- Test the node contract, not implementation details
- Validate all required fields are present

### 4. Edge Case Coverage

```python
def test_interrupt_handler_invalid_response(self):
    mock_interrupt.return_value = [{"type": "invalid_type"}]

    with pytest.raises(ValueError, match="Invalid response"):
        interrupt_handler(sample_state)
```

**Key Points:**
- Test error conditions and invalid inputs
- Verify proper error handling and messages
- Test boundary conditions

## Node-Specific Testing Details

### CallModelNode Testing

**What it tests:**
- Model initialization with different configs
- State handling and prompt construction
- Async response processing
- Default value application

**Key validations:**
- Correct model parameters passed to `init_chat_model`
- Prompt contains expected state values
- Response structure matches expected format

### ToolNode Testing

**What it tests:**
- Tool call processing from AI messages
- Different tool types (rewrite vs done)
- State updates from tool responses
- Error handling for malformed tool calls

**Key validations:**
- Tool calls are executed correctly
- State is updated appropriately
- ToolMessage format is correct
- Structured output handling

### InterruptHandler Testing

**What it tests:**
- Human-in-the-loop interruption logic
- Different response types (accept, ignore, edit, response)
- Command generation for graph routing
- State update logic

**Key validations:**
- Correct routing decisions
- State updates match response type
- Command objects are properly formed

## Benefits Achieved

### 1. Fast Test Execution
- All node tests run in ~0.05 seconds
- No external API calls or LLM dependencies
- Immediate feedback during development

### 2. Comprehensive Coverage
- Tests cover normal operation, edge cases, and error conditions
- Each node tested independently and in integration scenarios
- State transformation logic thoroughly validated

### 3. Clear Error Isolation
- When a test fails, the exact node and scenario is immediately apparent
- No need to trace through complex graph execution
- Easier debugging and fixing

### 4. Development Confidence
- Changes to node logic are immediately validated
- Refactoring is safer with comprehensive node coverage
- New features can be tested in isolation

## Integration with Existing Tests

The node tests complement your existing test structure:

- **Unit Tests** (tools + nodes) - Fast, isolated component testing
- **Integration Tests** - Full graph execution with real/mocked LLMs
- **Evaluation Tests** - Quality assessment with LLM-as-judge

This creates a comprehensive testing pyramid following LangGraph best practices.

### Agent Testing Conclusion

This individual node testing implementation follows LangGraph documentation recommendations and provides:

- **Better alignment** with LangGraph testing best practices
- **Faster development** cycle with immediate feedback
- **Higher confidence** in node-level correctness
- **Easier maintenance** and debugging
- **Comprehensive coverage** of edge cases and error conditions

The tests serve as both validation and documentation of how each node should behave in isolation, making the codebase more maintainable and reliable.

### Running Agent Tests

```bash
# Navigate to agent directory
cd agent

# Run all node tests
uv run pytest tests/unit_tests/test_graph_nodes.py -v

# Run specific node test class
uv run pytest tests/unit_tests/test_graph_nodes.py::TestCallModelNode -v

# Run with coverage
uv run pytest tests/unit_tests/test_graph_nodes.py --cov=src.agent.graph

# All test commands from Makefile
make test                  # Run unit tests
make integration_test      # Run integration tests
make test_all              # Run all tests
make lint                  # Run ruff linting
make format                # Format code with ruff
```

---

## Cross-Service Integration Testing

### Integration Test Scenarios

Test complete workflows across all three services:

#### End-to-End User Flow
```bash
# Example integration test scenario
1. User authenticates via Backend OAuth
2. Frontend receives session token
3. Frontend connects to Agent WebSocket
4. User submits text summarization request
5. Agent processes request and returns result
6. Frontend displays result to user
```

#### Service Health Integration
```typescript
// Frontend health check integration
const checkServiceHealth = async () => {
  const [backendHealth, agentHealth] = await Promise.all([
    fetch('http://localhost:8000/health'),
    fetch('http://localhost:8080/health')
  ])

  return {
    backend: backendHealth.ok,
    agent: agentHealth.ok
  }
}
```

#### Database Integration Testing
```python
# Backend + Database integration
def test_user_workflow_integration():
    # Test complete user CRUD operations
    with TestClient(app) as client:
        # Create user via OAuth callback
        auth_response = client.get("/auth/callback?code=test_code")
        session_token = auth_response.cookies["session"]

        # Use session to access user data
        user_response = client.get(
            "/api/user",
            cookies={"session": session_token}
        )
        assert user_response.status_code == 200

        # Update user profile
        update_response = client.put(
            "/api/user",
            json={"name": "Updated Name"},
            cookies={"session": session_token}
        )
        assert update_response.status_code == 200
```

### Integration Test Setup

```bash
# Start all services for integration testing
npm run dev:full           # Start all services concurrently

# Or start individually
npm run dev:frontend       # http://localhost:3000
npm run dev:fastapi        # http://localhost:8000
npm run dev:agent          # http://localhost:8080
```

---

## Test Execution Commands

### Root Level Commands

```bash
# Development environment
npm run dev:full           # Start all services for testing
npm run build:full         # Build and validate all services
npm run stop:all           # Stop all running services
```

### Service-Specific Test Commands

#### Frontend Tests
```bash
cd frontend
npm run lint               # ESLint checking
npm run build              # Production build validation
npx tsc --noEmit           # TypeScript type checking
```

#### Backend Tests
```bash
cd backend
make test                  # Run unit tests
make test_all              # Run all tests
make lint                  # Ruff linting
make format                # Code formatting
mypy src/                  # Type checking
```

#### Agent Tests
```bash
cd agent
make test                  # Run unit tests
make integration_test      # Run integration tests
make test_all              # Run all tests
make lint                  # Ruff linting
make format                # Code formatting
```

### Continuous Integration

```bash
# Full test suite for CI/CD
# Frontend
cd frontend && npm run lint && npm run build

# Backend
cd backend && make lint && make test_all

# Agent
cd agent && make lint && make test_all
```

---

## Best Practices Summary

### TDD Workflow
1. **Write failing test first** - Define expected behavior
2. **Implement minimal code** - Make the test pass
3. **Refactor with confidence** - Tests ensure correctness
4. **Repeat cycle** - Build features incrementally

### Service-Specific Guidelines

#### Frontend
- Test component behavior, not implementation details
- Mock external dependencies (APIs, WebSocket connections)
- Test TypeScript types and interfaces
- Validate responsive design and accessibility

#### Backend
- Test API contracts and HTTP responses
- Test database models and relationships
- Test authentication and authorization flows
- Test error handling and edge cases

#### Agent
- Test individual nodes before graph composition
- Mock LLM responses for predictable testing
- Test state transformations and routing logic
- Test human-in-the-loop interactions

### Code Quality
- **Consistent tooling** - ESLint (Frontend), ruff + mypy (Python)
- **Type safety** - TypeScript and Python type hints
- **Test coverage** - Aim for high coverage with meaningful tests
- **Documentation** - Tests serve as living documentation

---

## Agent Testing Details (LangGraph)

This section contains the detailed LangGraph node testing implementation that follows best practices for testing nodes in isolation before testing the full graph.