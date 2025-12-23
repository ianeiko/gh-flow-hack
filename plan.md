# GitHub Issue Flow Orchestrator

## Overview
This is the main orchestration prompt that takes a simple idea and transforms it through a complete workflow: from concept to GitHub issue to implementation.

## Workflow Sequence

### Phase 1: Issue Expansion
**Input**: `idea.md` (contains a simple one-sentence idea)
**Prompt Template**: `prompts/01_issue_expansion.md`
**Action**:
1. Read the content from `idea.md`
2. Apply the issue expansion template from `prompts/01_issue_expansion.md`
3. Generate a comprehensive GitHub issue specification with:
   - Problem statement
   - User story
   - Requirements
   - Acceptance criteria
   - Verification & testing steps

### Phase 2: GitHub Issue Creation
**Input**: Expanded issue content from Phase 1
**Prompt Template**: `prompts/utility_sync_issue.md`
**Action**:
1. Create a new GitHub issue in the repository using the GitHub MCP tool
2. Set the title to the feature name from the expanded content
3. Set the body to the full markdown content generated in Phase 1
4. Add the "HF-required" label to the issue
   - If this is the first issue and the label doesn't exist, GitHub will automatically create it when added to the issue
   - Alternatively, check if the label exists first using `get_label` and handle accordingly
5. Capture the created issue number for reference

### Phase 3: Implementation Preparation
**Output**: GitHub issue URL and issue number
**Action**:
1. Confirm the issue was created successfully
2. Provide the issue URL for tracking
3. Prepare for implementation phase (next workflow stage)

## Execution Instructions

When this prompt is invoked:
1. **Read** `idea.md` to get the raw idea
2. **Expand** the idea using the format from `prompts/01_issue_expansion.md`
3. **Create** a GitHub issue using the GitHub MCP tool with the expanded content
4. **Label** the issue with "HF-required" (will be auto-created if it doesn't exist)
5. **Report** the created issue number and URL
6. **Await** further instructions for implementation

## Repository Context
- **Owner**: Determine from authenticated GitHub user
- **Repo**: `gh-flow-hack`
- **Branch**: `main`

## Notes
- This is a test flow to validate the issue creation pipeline
- All steps should use GitHub MCP tools, not Bash commands
- Issue content should be well-formatted markdown
- Store issue files locally in `docs/issues/` for reference (optional)
