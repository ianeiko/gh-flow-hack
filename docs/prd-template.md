# Hackathon PRD Template - [Feature/Project Name]

> **AI Agent Optimized**: This template is designed for rapid MVP development in hackathons with AI coding agents. Focus on Phase 1-2 for complete MVP (50 mins).

## Overview

### Problem Statement
<!-- 2-3 sentences max. What specific problem are we solving? Why is it critical? -->

### Solution Summary
<!-- MVP in 1 sentence. Full vision in 1 sentence. -->
**MVP**: 
**Vision**: 

### Success Criteria
<!-- 2 MVP metrics, 2-3 enhancement metrics. Must be measurable. -->
**MVP Success** (Phase 2):
- [ ] Core functionality works end-to-end
- [ ] Basic UI displays data correctly
- [ ] Essential error handling and validation
- [ ] Demo-ready stability

## Product Context

### User Stories
<!-- 2 core stories for MVP. -->
**MVP Stories**:
- As a [user], I want [core capability] so that [primary benefit]
- As a [user], I want [essential feature] so that [key value]


## Technical Requirements

### Architecture Overview
<!-- Focus on what AI agent needs to build. Be specific with file paths. -->

#### Frontend Impact (`frontend/`)
**MVP Components**:
- `src/app/[feature]/page.tsx`: Main page component
- `src/components/[Component].tsx`: Core UI component
- `src/lib/hooks/use[Feature].ts`: Business logic hook


#### Backend Impact (`backend/`)
**MVP Endpoints**:
- `GET /api/[resource]`: Fetch data
- `POST /api/[resource]`: Create/update data


#### Agent Impact (`agent/`)
**Evaluation**: First determine if LangGraph agent service is needed for this project:
- Does the project require AI workflows, document processing, or complex human-in-the-loop interactions?
- If NO: **DELETE agent/ directory** and **UPDATE package.json**:
  - Remove `dev:agent` script
  - Update `dev:full` to only run frontend+backend (remove agent from concurrently)
  - Remove agent-related scripts and dependencies

**If Agent IS needed**:
- Graph selection: `[which_graph]`
- State modifications needed

### Service Integration
<!-- One line about critical connections -->
- Frontend ↔ Backend: REST API on port 8000
- Frontend ↔ Agent: WebSocket via @langchain/langgraph-sdk on port 8080

## Interface Contracts

### Data Models (Shared - Defined Collaboratively)
```typescript
// Frontend types (src/lib/types.ts)
interface [ModelName] {
  id: string;
  // essential fields defined upfront by all agents
}

// Backend models (src/api/models.py)
class [ModelName](SQLModel):
    id: int
    # essential fields matching frontend interface

// Agent state (src/agent/schemas.py) - if needed
class [StateName](TypedDict):
    # essential state fields
```

### API Contracts
```typescript
// Backend endpoints (src/api/main.py)
GET /api/[resource] -> [ResponseType]
POST /api/[resource] -> [RequestType] -> [ResponseType]
PUT /api/[resource]/{id} -> [RequestType] -> [ResponseType]
DELETE /api/[resource]/{id} -> void

// Error responses
400/404/500 -> { error: string, details?: any }
```

### Agent Communication Contracts (if needed)
```typescript
// WebSocket connection
ws://localhost:8080/[graph_name]

// Message format
{ type: 'message', content: string, metadata?: any }
{ type: 'interrupt', data: any }
{ type: 'result', output: any }
```

### Mock Data Strategy
```typescript
// Shared mock data for parallel development
const mockData = {
  [resource]: [
    { id: '1', /* sample fields */ },
    { id: '2', /* sample fields */ }
  ]
};
```

## Implementation Plan

### Contract-First Parallel Development Timeline

| Phase | Time | Agents | Focus | Sync Points |
|-------|------|--------|-------|-------------|
| Phase 0: Contracts | 0-10 mins | ALL | Interface definition | ✓ Contracts agreed |
| Phase 1-2: Parallel | 10-50 mins | 3 TRACKS | Independent dev | ✓ 30min, ✓ 50min |
| Integration | 50-60 mins | ALL | Final testing | ✓ Demo ready |

### Phase 0: Contract Definition (0-10 minutes)
**Master agent produce documentation docs/contract_{frontend|backend|agent}.md**:
- [ ] Search official API and example using context7 MCP server (*DO NOT REMOVE OR SKIP THIS STEP!*)
- [ ] Define shared data models and TypeScript interfaces  
- [ ] Define API contracts (endpoints, request/response schemas)
- [ ] Define agent communication protocols (if needed)
- [ ] Create mock data for parallel development
- [ ] Assign file ownership boundaries

### Parallel Development Tracks (10-50 minutes)

#### Frontend Developer Track
**Phase 1 (10-25 mins): Foundation**
- [ ] Set up Next.js components with mock data
- [ ] Implement TypeScript interfaces in `frontend/src/lib/types.ts`
- [ ] Create base UI components and hooks
- [ ] Set up routing and navigation structure

**Phase 2 (25-50 mins): Integration & Polish**
- [ ] Connect to real backend APIs  
- [ ] Implement state management and basic error handling
- [ ] Add data fetching and form submission with loading states
- [ ] Add basic form validation and error display
- [ ] Test frontend independently with API calls

**Independent Testing**: `cd frontend && npm run dev && npm run lint`

#### Backend Developer Track
**Phase 1 (10-25 mins): Foundation**  
- [ ] Set up FastAPI with data models in `backend/src/api/models.py`
- [ ] Create stub API endpoints returning mock data
- [ ] Set up database connections and migrations
- [ ] Initialize authentication if needed

**Phase 2 (25-50 mins): Integration & Stability**
- [ ] Implement real business logic in API endpoints
- [ ] Add database CRUD operations
- [ ] Add essential validation, error handling, and logging
- [ ] Connect to agent service (if needed)
- [ ] Test API endpoints independently

**Independent Testing**: `cd backend && make test && curl localhost:8000/health`

#### AI Engineer Track
**Phase 1 (10-25 mins): Foundation**
- [ ] Evaluate if agent service is needed for requirements
- [ ] Either: Set up LangGraph workflows OR delete agent/ directory  
- [ ] Define agent state and communication contracts
- [ ] Update package.json scripts based on agent decision

**Phase 2 (25-50 mins): Integration & Reliability**
- [ ] Implement agent workflows and tools (if needed)
- [ ] Connect to backend APIs for data access
- [ ] Add basic agent error handling and logging
- [ ] Test agent-to-backend communication
- [ ] Ensure frontend can communicate with agent

**Independent Testing**: `cd agent && make test` OR verify agent removal completed

### Integration Checkpoints
**Sync Point 2 (30 mins)**: Test basic service connectivity  
- [ ] Frontend can call backend APIs
- [ ] Backend responds with expected data format
- [ ] Agent service connects if needed

**Sync Point 3 (50 mins)**: End-to-end workflow validation
- [ ] Complete user flow works across all services
- [ ] Error handling works properly
- [ ] Performance is acceptable for demo

**Final Sync (60 mins)**: Demo preparation and final testing

## Testing Strategy

### MVP Smoke Tests
<!-- Only critical path testing for MVP -->
```bash
# Quick verification commands
curl http://localhost:8000/api/[endpoint]  # API responds
npm run dev:frontend  # UI loads without errors
# Manual test: Core user flow works
```


## Agent Responsibilities & Boundaries

### Frontend Developer Owns:
**Files:**
- `frontend/src/app/[feature]/page.tsx` - Page components and routing
- `frontend/src/components/[Feature].tsx` - Reusable UI components  
- `frontend/src/lib/hooks/use[Feature].ts` - State management and business logic
- `frontend/src/lib/types.ts` - TypeScript interfaces (shared, but owned by frontend)

**Responsibilities:**
- UI/UX implementation and user interactions
- Frontend state management and data flow
- Integration with backend APIs and agent WebSockets
- Responsive design and mobile optimization
- Frontend testing and component validation

**Independent Commands:**
```bash
cd frontend && npm run dev    # Start dev server
cd frontend && npm run lint   # Code quality check
curl http://localhost:3000    # Verify frontend loads
```

### Backend Developer Owns:
**Files:**
- `backend/src/api/main.py` - API endpoints and routing
- `backend/src/api/models.py` - Database models and schemas
- `backend/src/api/[feature].py` - Feature-specific business logic
- `backend/tests/test_[feature].py` - API and integration tests

**Responsibilities:**
- API design and implementation
- Database schema and CRUD operations
- Business logic and data validation
- Integration with agent service (if needed)
- Backend testing and API validation

**Independent Commands:**
```bash
cd backend && make test              # Run test suite
curl http://localhost:8000/health    # Health check
curl http://localhost:8000/api/[endpoint] # API test
```

### AI Engineer Owns:
**Files (if agent is needed):**
- `agent/src/agent/graph_[feature].py` - LangGraph workflows
- `agent/src/agent/schemas.py` - Agent state definitions and types
- `agent/src/agent/tools/[feature]_tools.py` - Agent-specific tools

**OR Deletion Responsibilities (if agent not needed):**
- Delete entire `agent/` directory
- Update `package.json` scripts (remove dev:agent, update dev:full)
- Update `CLAUDE.md` documentation if needed

**Responsibilities:**
- Evaluate AI/agent requirements for the project
- Implement LangGraph workflows and human-in-the-loop patterns
- Agent-to-backend API integration
- Agent performance and reliability
- Agent testing and workflow validation

**Independent Commands:**
```bash
cd agent && make test                 # Run agent tests
curl http://localhost:8080/health     # Agent health check
# OR verify clean agent removal completed
```

### Cross-Agent Dependencies (Minimize These)
**Shared Contracts** (defined in Phase 0):
- TypeScript interfaces in `frontend/src/lib/types.ts`
- API endpoint contracts
- WebSocket message formats (if agent used)
- Mock data structure for parallel development

**Required Coordination Points:**
- Sync Point 1 (10 min): Contract validation
- Sync Point 2 (30 min): Service connectivity testing  
- Sync Point 3 (50 min): End-to-end integration validation

## Acceptance Criteria

### MVP Requirements (Phase 2 Complete)
<!-- Minimum viable functionality -->
- [ ] Core feature works end-to-end
- [ ] Data persists correctly
- [ ] Basic UI displays information
- [ ] No critical errors in console


## Essential Commands

### Quick Start
```bash
# Start everything
npm run dev:full

# Verify services
curl http://localhost:8000/health  # Backend
curl http://localhost:8080/health  # Agent
# Frontend: http://localhost:3000
```

### Environment Variables
```bash
# Only if required for MVP
OPENAI_API_KEY=...  # If using AI features
DATABASE_URL=...    # If not using default SQLite
```

---

## AI Agent Instructions

When implementing this PRD:
1. Start with Phase 1 tasks sequentially
2. Test each phase before moving to next
3. Focus on working code over perfect code
4. Use existing patterns from codebase
5. Skip linting/formatting during MVP
6. Keep console.log for debugging during hackathon
