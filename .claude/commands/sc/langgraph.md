---
command: "/sc:langgraph"
category: "Documentation & Planning"
purpose: "Generate PRD using langgraph-expert persona"
wave-enabled: false
performance-profile: "standard"
personas: [langgraph-expert]
mcp-servers: [sequential, context7]
allowed-tools: [Read, Write, Edit, MultiEdit, TodoWrite]
---

# /sc:langgraph - LangGraph PRD Generation

## Purpose
Generate Product Requirements Document (PRD) for planned work using the langgraph-expert persona.

## Usage
```
/sc:langgraph [feature-description] [--output docs/prd.md] [--format standard|detailed]
```

## Arguments
- `feature-description` - Natural language description of the planned work or feature
- `--output` - Output file path (default: docs/prd.md)
- `--format` - PRD format:
  - `standard` (default): Standard PRD structure with essential sections
  - `detailed`: Comprehensive PRD with extended analysis

## Execution Process

The langgraph-expert persona analyzes the feature description and generates a structured PRD document:

1. **Feature Analysis**: Analyze the provided feature description using langgraph-expert domain knowledge
2. **Requirements Extraction**: Identify core requirements and acceptance criteria
3. **Technical Planning**: Define technical approach and architecture considerations  
4. **PRD Generation**: Create structured Product Requirements Document
5. **File Output**: Save to docs/prd.md or specified path

## Persona Integration

- **Primary Persona**: langgraph-expert (ready for usage)
- **Domain Expertise**: Multi-agent workflows, LangGraph systems, autonomous operations
- **Output Quality**: Professional PRD formatting with technical accuracy

## PRD Structure

### Standard PRD Template
```markdown
# Feature Name

## Overview
Brief description and objectives

## Requirements
- Functional requirements
- Non-functional requirements
- Acceptance criteria

## Technical Approach
- Architecture considerations
- Technology choices
- Implementation notes

## Success Criteria
- Measurable outcomes
- Validation methods
```

### Detailed PRD Template
Enhanced version includes additional sections:
- **Stakeholder Analysis**
- **Risk Assessment**
- **Implementation Timeline**
- **Resource Requirements**
- **Dependencies and Constraints**

## Usage Examples

### Standard PRD Generation
```bash
/sc:langgraph "Implement user dashboard with analytics widgets"
```

### Custom Output Location
```bash
/sc:langgraph "Add OAuth integration" --output requirements/oauth-prd.md
```

### Detailed PRD Format
```bash
/sc:langgraph "Real-time chat system" --format detailed --output docs/chat-prd.md
```