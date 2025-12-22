# PRINCIPLES.md

### Core Design Principles
- **YAGNI**: Implement only current requirements, avoid speculative features
- **KISS**: Prefer simplicity over complexity in all design decisions.
    - *Simplicity First*: Always choose the simplest solution that satisfies the requirements.
    - *Avoid Over-Engineering*: Resist the urge to add features or abstractions "just in case".
- **DRY**: Abstract common functionality, eliminate duplication.
    - *Post-Implementation Cleanup*: After features are implemented and reviewed (e.g., by Code Rabbit), perform a final "simplification pass".
        - *Objective*: Slim down the code while maintaining functionality and passing tests.
        - *Artifact Removal*: specific instructions to remove any redundant artifacts or boilerplate remaining from the generation process.
        - *Elegance*: Optimize for human readability and elegance as the final step before human review.
## AI-Driven Development and Senior Developer Mindset

### Testing Philosophy
- **Test-Driven Development**: Write tests before implementation to clarify requirements
- **Testing Pyramid**: Emphasize unit tests, support with integration tests, supplement with E2E tests
- **Tests as Documentation**: Tests should serve as executable examples of system behavior
- **Comprehensive Coverage**: Test all critical paths and edge cases thoroughly

### Code Generation Philosophy
- **Present-Focused Comments**: Comments describe current implementation only - never reference removed code or past versions

### Tool Selection and Coordination
- **Capability Mapping**: Match tools to specific capabilities and use cases rather than generic application
- **Parallel Optimization**: Execute independent operations in parallel to maximize efficiency
- **Fallback Strategies**: Implement robust fallback mechanisms for tool failures or limitations
- **Evidence-Based Selection**: Choose tools based on demonstrated effectiveness for specific contexts

### Error Handling
- **Fail Fast, Fail Explicitly**: Detect and report errors immediately with meaningful context
- **Never Suppress Silently**: All errors must be logged, handled, or escalated appropriately
- **Context Preservation**: Maintain full error context for debugging and analysis
- **Recovery Strategies**: Design systems with graceful degradation

### Dependency Management
- **Transparency**: Every dependency must be justified and documented