---
allowed-tools: [Read, Grep, Glob, Bash, Write]
description: "Generate comprehensive project documentation and knowledge base"
---

# /sc:index - Project Documentation

## Purpose
Create and maintain comprehensive project documentation, indexes, and knowledge bases.

## Usage
```
/sc:index [target] [--type docs|api|structure|readme] [--format md|json|yaml]
```

## Arguments
- `target` - Project directory or specific component to document
- `--type` - Documentation type (docs, api, structure, readme)
- `--format` - Output format (md, json, yaml)
- `--update` - Update existing documentation

## Execution
1. Analyze project structure and identify key components
2. Extract documentation from code comments and README files
3. Generate comprehensive documentation based on type
4. Create navigation structure and cross-references
5. Output formatted documentation with proper organization

## LangGraph Multi-Agent Commands

### Core Workflow Command
- `/sc:langgraph` - Main multi-agent development workflow orchestration

### Sub-Agent Commands (geliz/* subfolder)
- `/geliz:workflow` - Complete feature development lifecycle orchestration
- `/geliz:issue-creator` - GitHub issue creation and approval monitoring
- `/geliz:dev-agent` - Autonomous feature implementation with testing
- `/geliz:qa-agent` - Comprehensive quality assurance and testing analysis
- `/geliz:orchestrator` - Central workflow coordination and state management
- `/geliz:github` - GitHub integration operations (issues, PRs, branches)
- `/geliz:state` - Workflow state management and cross-session continuity

### Human Gates & Approval Process
- **Issue Approval:** Comment `@langgraph approve` to start development
- **PR Review:** Standard GitHub review process with QA recommendations
- **Emergency Stop:** Comment `@langgraph halt` to pause workflow

### Branch Naming Convention
- **Pattern:** `feature/lg-{issue-number}-{kebab-case-title}`
- **Labels:** `langgraph-workflow`, `enhancement`

## Claude Code Integration
- Uses Glob for systematic file discovery
- Leverages Grep for extracting documentation patterns
- Applies Write for creating structured documentation
- Maintains consistency with project conventions