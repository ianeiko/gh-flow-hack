use @docs/prd-template.md as prd template, come up with a prd for this project: @docs/prd-requirements.md.

CONTEXT: This PRD will be used in a hackathon event where AI coding agents (ai-engineer) will implement the complete project within ~60 minutes. Optimize all decisions for rapid development, minimal dependencies, and maximum parallelization. 

and ask for clarification when requirements are ambiguous;

first analyze existing tech stack from @CLAUDE.md to understand pre-configured architecture, dependencies, and working patterns;

then recommend tech stack. Do not run WebSearch. Think hard;
- Executive summary of top choices per domain
- Technology stack combinations (minimal, medium, advanced)
- Risk assessment and setup complexity analysis
- Final recommendations for hackathon context;

STOP: DO NOT PROCEED FURTHER WITHOUT USER CONFIRMATION
ONLY continue to PRD generation after user says "yes" or "proceed";

STOP: BEFORE GENERATING PRD
analyze @docs/prd-requirements.md and present major features to implement;
recommend which features to include/exclude based on 60-minute hackathon timeframe;
wait for user confirmation on feature scope before proceeding with PRD generation;
ONLY continue after user approves feature selection;

focus on contract-first development with ai-engineer;

use development approach with clear interface definitions and focused implementation;

include mock data/stub implementations to enable rapid development;

evaluate if agent/ service is needed for this project requirements;

--seq --context7 --websearch --interactive --think --parallel-agents --contract-first --time-box=60 --ai-ready --priority=speed

**File Output**: Save to docs/prd.md or specified path