# /sc:speed-code - Rapid Development Workflow

## Purpose
Execute rapid development workflows optimized for speed, prototyping, and MVP creation with the speed-coder persona.

## Usage
```
/sc:speed-code [target] [--type prototype|mvp|demo|hack] [--framework <name>] [--template <template>]
```

## Arguments
- `target` - Feature, component, or project to rapidly develop
- `--type` - Type of rapid development (prototype, mvp, demo, hack)
- `--framework` - Target framework (react, vue, node, express, etc.)
- `--template` - Use specific template or boilerplate
- `--fast` - Maximum speed mode with minimal validation
- `--deploy` - Auto-deploy after completion

## Execution Strategy

### 1. Speed Assessment
- Analyze requirements for minimum viable implementation
- Identify existing templates, boilerplates, or similar code
- Choose fastest technology stack and libraries
- Set aggressive time targets based on complexity

### 2. Rapid Implementation
- Leverage Magic MCP for quick UI component generation
- Use Context7 for framework patterns and quick setup
- Copy-paste-modify from existing working code
- Prioritize functional over perfect code

### 3. MVP Validation
- Ensure basic functionality works as intended
- Quick smoke tests for critical paths
- Deployable state verification
- Document known limitations/tech debt

### 4. Speed-Coding Techniques
- **Boilerplate First**: Start with closest working template
- **Progressive Enhancement**: Build incrementally from core functionality
- **Library Over Custom**: Use established libraries vs custom solutions
- **Convention Over Config**: Accept defaults, avoid customization
- **Deploy Early**: Get something working online quickly

## Persona Integration
- **Auto-Activates**: speed-coder persona for rapid development mindset
- **MCP Priority**: Magic (UI/components) → Context7 (patterns) → Sequential (problem-solving)
- **Quality Trade-offs**: Functional > Readable > Optimal
- **Time Pressure**: Aggressive deadlines with iteration mindset

## Examples

### Rapid Prototype
```bash
# Create a quick user dashboard prototype
/sc:speed-code "user dashboard with auth" --type prototype --framework react

# Quick API prototype for mobile app
/sc:speed-code "REST API for todo app" --type prototype --framework express
```

### MVP Development
```bash
# Build minimal viable product
/sc:speed-code "e-commerce checkout flow" --type mvp --deploy

# Quick demo for stakeholder presentation
/sc:speed-code "data visualization dashboard" --type demo --framework vue
```

### Hackathon Mode
```bash
# Maximum speed development
/sc:speed-code "social media integration" --type hack --fast --template social-starter
```

## Claude Code Integration
- Uses Write for rapid file creation with templates
- Leverages Magic for instant UI component generation
- Applies Context7 for framework setup and common patterns
- Maintains TodoWrite for tracking rapid development milestones
- Uses Bash for quick setup, testing, and deployment commands

## Speed Optimization Features
- **Template Library**: Quick access to common project templates
- **Snippet Injection**: Rapid insertion of common code patterns
- **Auto-Setup**: Automatic dependency installation and configuration
- **Hot Deployment**: Instant deployment for quick validation
- **Iteration Loops**: Built-in feedback cycles for rapid improvement

## Quality Gates (Minimal)
- **Functional**: Does it work for the intended use case?
- **Deployable**: Can it be deployed and demonstrated?
- **Readable**: Is it understandable for next iteration?
- **Documented**: Are key decisions and limitations noted?

## Performance Targets
- **Setup**: <5 minutes for new projects
- **Feature**: <30 minutes for basic functionality
- **Iteration**: <10 minutes per change cycle
- **Deploy**: <5 minutes from working code to live

## Integration Points
- Works with all standard SuperClaude flags
- Optimized for `--fast`, `--quick`, `--uc` modes
- Compatible with `--magic` and `--c7` for enhanced speed
- Supports `--loop` for rapid iteration cycles