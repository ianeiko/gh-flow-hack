# Quick Start - Software Factory Flow

**TL;DR**: Write idea → Run command → Get PR

## Prerequisites

1. **GitHub token** set in environment:
   ```bash
   export GITHUB_TOKEN="your_github_token"
   ```

2. **Git configured**:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your@email.com"
   ```

## Installation

Install the local plugin:

```bash
# Copy plugin to user plugins directory
mkdir -p ~/.claude/plugins
cp -r ./plugins/gh-flow-orchestrator ~/.claude/plugins/

# Restart Claude Code to load the plugin
```

Or use it directly in this project (no installation needed):
```bash
# Claude Code automatically loads plugins from ./.claude/plugins/
# or ./plugins/ in project directory
```

## Usage

### Option 1: Idea to PR (Recommended for Quick Iteration)

1. **Write your idea** in `idea.md`:
   ```markdown
   Add a hello world function to app/main.py
   ```

2. **Run the command**:
   ```
   /gh-flow-orchestrator:idea-to-pr --auto-implement
   ```

3. **Done!** The flow will:
   - Expand idea to detailed issue
   - Create GitHub issue
   - Implement the feature
   - Create PR

### Option 2: Idea to PR with Human Review (Recommended for Production)

1. **Write your idea** in `idea.md`

2. **Create issue for review**:
   ```
   /gh-flow-orchestrator:idea-to-pr
   ```

3. **Review issue on GitHub**, remove `HF-required` label when ready

4. **Implement**:
   ```
   /gh-flow-orchestrator:check-and-implement
   ```

### Option 3: Manual Step-by-Step (Full Control)

Follow the workflow docs:
- `plan.md` - Phases 1-3 (idea → issue)
- `implement.md` - Phases 4-6 (implement → PR → review)

## Commands Reference

| Command | Purpose | Auto-Implement |
|---------|---------|----------------|
| `/gh-flow-orchestrator:idea-to-pr` | Idea → Issue (with review gate) | No |
| `/gh-flow-orchestrator:idea-to-pr --auto-implement` | Idea → Issue → Implementation → PR | Yes |
| `/gh-flow-orchestrator:check-and-implement` | Find eligible issue → Implement | Yes |

## Workflow State

**Always check** `workflow-state.md` to see:
- Current phase
- Active issue/PR
- Task details
- Checklist progress

## File Locations

- **Idea**: `idea.md` (your input)
- **Issues**: `docs/issues/issue_{number}.md` (saved locally)
- **Tasks**: `docs/tasks/{task-name}.md` (implementation details)
- **Reviews**: `docs/coderabbit/{pr_id}.md` (Code Rabbit feedback)
- **State**: `workflow-state.md` (current progress)

## Plugins Used

The installed Claude Code plugins:
- `/github` - GitHub operations (issues, PRs, labels, comments)
- `/feature-dev` - Feature implementation
- `/code-review` - Review analysis and fixes

Our local plugin:
- `/gh-flow-orchestrator` - Workflow automation

## Standards & Conventions

All standards are documented in `/prompts`:
- `01_issue_expansion.md` - Issue template
- `02_implementation.md` - Implementation standards → uses `/feature-dev`
- `03_review_aggregation.md` - Review standards → uses `/github`
- `04_refactor_analysis.md` - Refactoring standards → uses `/code-review`
- `05_fix_application.md` - Fix standards → uses `/code-review`

Our principles:
- **YAGNI** - Only implement current requirements
- **KISS** - Simplest solution that works
- **DRY** - Abstract common functionality

## Examples

### Example 1: Simple Feature
```bash
# Write to idea.md:
echo "Add a function to calculate factorial" > idea.md

# Run:
/gh-flow-orchestrator:idea-to-pr --auto-implement

# Result: PR created with implementation
```

### Example 2: Complex Feature with Review
```bash
# Write to idea.md:
echo "Add user authentication with JWT tokens" > idea.md

# Create issue for review:
/gh-flow-orchestrator:idea-to-pr

# Review on GitHub, remove HF-required label

# Implement:
/gh-flow-orchestrator:check-and-implement

# Result: PR created, Code Rabbit reviews, agent fixes issues
```

## Troubleshooting

### Plugin not found
```bash
# Check if plugin is installed:
ls ~/.claude/plugins/gh-flow-orchestrator

# If not, install it:
cp -r ./plugins/gh-flow-orchestrator ~/.claude/plugins/
```

### GitHub MCP not working
```bash
# Check token is set:
echo $GITHUB_TOKEN

# Restart Claude Code after setting token
```

### Command doesn't run
- Use exact command: `/gh-flow-orchestrator:idea-to-pr`
- Note the colon `:` between plugin name and command

## Next Steps

1. Try the quick example above
2. Read `CLAUDE.md` for full architecture
3. Check `docs/PLUGIN_MIGRATION.md` for how plugins are used
4. Review `docs/tech_implementation.md` for Deep Agents patterns
