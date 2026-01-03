# Architecture Blueprint: Deep Agent Application

> **For the Implementation Agent**: This document serves as the architectural standard for building the Target App in `app/`. The app must align with the [`langchain-ai/deepagents`](https://github.com/langchain-ai/deepagents) framework.

## 1. Core Framework: `deepagents`

The application is built using the `deepagents` library, which sits on top of **LangGraph** and **LangChain**.

### Key Concepts
- **DeepAgentState**: The unified state object that tracks:
  - `messages`: Standard chat history.
  - `todo_list`: Utilizing the built-in `write_todos` middleware.
  - `filesystem`: A virtual file system context (if using `FilesystemMiddleware`).
- **Middleware**: Functionality is injected via middleware layers (e.g., `todoListMiddleware`, `subAgentMiddleware`).
- **Sub-Agents**: Complex tasks should be delegated to specialized sub-agents via the `task` tool.

## 2. Default Directory Structure (`app/`)

The agent should respect the following structure:
```text
app/
├── main.py              # Entrypoint: Configures and compiles the graph
├── agent.py             # Defines the main 'Deep Agent' configuration
├── state.py             # Custom state extensions (if needed)
├── tools/               # Custom tools definitions
│   ├── __init__.py
│   └── custom_tool.py
└── subagents/           # Specialized sub-agent definitions
    ├── __init__.py
    └── reviewer.py
```

## 3. Implementation Patterns

### A. Initializing the Agent
In `app/agent.py`, use the factory pattern:

```python
from deepagents import create_deep_agent
from langchain_openai import ChatOpenAI

def build_agent():
    model = ChatOpenAI(model="gpt-4o")

    agent = create_deep_agent(
        model=model,
        # Instructions are crucial for Deep Agents
        system_prompt="You are a specialized software engineer...",
        tools=[...],
        # Middleware enables "Thinking" and "File System" capabilities
        enable_todos=True,
        enable_fs=True
    )
    return agent
```

### B. Creating Custom Tools
All tools must be strictly typed and documented for the LLM.

```python
from langchain_core.tools import tool

@tool
def my_custom_tool(arg1: str) -> str:
    """Description of what this tool does."""
    # Logic
    return "result"
```

### C. Sub-Agent Delegation
For distinct domains (e.g., "Review Code", "Write Documentation"), define a sub-agent.

```python
# app/subagents/reviewer.py
reviewer_agent = create_deep_agent(
    model=ChatOpenAI(model="gpt-4o"),
    system_prompt="You are a strict code reviewer...",
    tools=[lint_code]
)
```

## 4. Development Rules for the Agent

When the **Implementation Agent** (YOU) edits this app:
1.  **Preserve State**: Do not remove `enable_todos` or `enable_fs` unless explicitly strictly required. These are the brain and memory of the Deep Agent.
2.  **Modularize Tools**: Do not clutter `main.py`. Put tools in `app/tools/`.
3.  **Use Factories**: Always use `create_deep_agent` or known patterns from the template. Do not reinvent the graph from scratch unless necessary.
4.  **Testing**: Verify the graph compiles by running `python app/main.py` (ensure it has a `main` block that invokes the graph).

## 5. Integration with "The Flow"

- **Input**: The agent receives tasks via the `messages` entry in the state.
- **Output**: The agent completes the task when it returns a final response to the user.
- **Persistence**: The agent uses the Virtual File System or local disk (via custom tools) to persist work between "Flow Steps".
