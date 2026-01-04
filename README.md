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

Install official Claude Code plugins:

```bash
claude plugin install github
claude plugin install feature-dev
claude plugin install code-review
```

The custom commands and skills are automatically loaded from the project directory.

## Usage

### Option 1: Idea to PR (Recommended for Quick Iteration)

1. **Write your idea** in `idea.md`:
   ```markdown
   Add a hello world function to app/main.py
   ```

2. **Run the command**:
   ```
   /idea-to-pr --auto-implement
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
   /idea-to-pr
   ```

3. **Review issue on GitHub**, remove `HF-required` label when ready

4. **Implement**:
   ```
   /check-and-implement
   ```

### Option 3: Manual Step-by-Step (Full Control)

Follow the workflow docs:
- `plan.md` - Phases 1-3 (idea → issue)
- `implement.md` - Phases 4-6 (implement → PR → review)

## Commands Reference

### Workflow Skills
| Command                        | Purpose                            | Auto-Implement |
| ------------------------------ | ---------------------------------- | -------------- |
| `/idea-to-pr`                  | Idea → Issue (with review gate)    | No             |
| `/idea-to-pr --auto-implement` | Idea → Issue → Implementation → PR | Yes            |
| `/check-and-implement`         | Find eligible issue → Implement    | Yes            |

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

## Architecture

### Official Plugins
- `github` - GitHub operations (issues, PRs, labels, comments)
- `feature-dev` - Feature implementation workflow
- `code-review` - Code review and feedback aggregation

### Skills (Managed)
- `idea-to-pr` - Idea → Issue → (optionally) PR
- `check-and-implement` - Find eligible issue → Implement

### Custom Commands
Located in `.claude/commands/g/` - loaded automatically

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
/idea-to-pr --auto-implement

# Result: PR created with implementation
```

### Example 2: Complex Feature with Review
```bash
# Write to idea.md:
echo "Add user authentication with JWT tokens" > idea.md

# Create issue for review:
/idea-to-pr

# Review on GitHub, remove HF-required label

# Implement:
/check-and-implement

# Result: PR created, Code Rabbit reviews, agent fixes issues
```

## Troubleshooting

### Plugins not found
```bash
# Install official plugins:
claude plugin install github
claude plugin install feature-dev
claude plugin install code-review
```

### Skills not found
Skills are managed in `.claude/skills/` - they should be automatically loaded from the project.

### GitHub MCP not working
```bash
# Check token is set:
echo $GITHUB_TOKEN

# Restart Claude Code after setting token
```

### Command doesn't run
- Skills use slash prefix: `/idea-to-pr`
- Custom commands use namespace: `/g:issue`
- Plugin tools invoked by skills automatically

## Next Steps

1. Try the quick example above
2. Read `CLAUDE.md` for full architecture
3. Check `docs/PLUGIN_MIGRATION.md` for plugin migration details
4. Review `docs/tech_implementation.md` for Deep Agents patterns
# Test change for code review
