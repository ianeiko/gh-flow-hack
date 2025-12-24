# GitHub Flow Orchestrator Plugin

A Claude Code plugin that automatically implements GitHub issues following the Software Factory workflow using GitHub MCP and git.

## Overview

This plugin provides autonomous GitHub issue implementation:
- **Automatic Discovery**: Finds eligible issues on SessionStart
- **Autonomous Implementation**: Spawns subagent to implement features end-to-end
- **Hybrid Integration**: GitHub MCP for API operations, git for version control
- **Workflow Aligned**: Follows the Software Factory 10-step process

## Features

- ✅ Automatic issue discovery (oldest eligible issue without "HF-required" label and no PR)
- ✅ Autonomous implementation using issue-implementer subagent
- ✅ Complete workflow: analyze → branch → implement → test → commit → push → PR
- ✅ GitHub MCP for GitHub operations (issues, PRs, comments)
- ✅ Git commands for version control (branch, commit, push)
- ✅ Follows project architecture (`docs/tech_implementation.md`)
- ✅ Adheres to development principles (YAGNI, KISS, DRY)

## Architecture

```
gh-flow-orchestrator/
├── .claude-plugin/
│   └── plugin.json              # Plugin manifest
├── hooks/
│   └── hooks.json               # SessionStart hook
├── agents/
│   └── issue-implementer.md     # Implementation subagent (uses GitHub MCP + git)
└── commands/
    └── check-and-implement.md   # Orchestrator command (uses GitHub MCP)
```

## Prerequisites

### 1. GitHub MCP Server

The plugin requires a GitHub MCP server to be configured. Ensure you have GitHub MCP enabled in Claude Code.

**Check if GitHub MCP is available**:
```bash
# GitHub MCP tools should be available in your Claude Code session
# Look for tools starting with mcp__github__*
```

**If not configured**, add GitHub MCP server to your Claude Code MCP configuration (typically in `~/.claude/mcp.json` or project's `.mcp.json`):

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

**Set your GitHub token**:
```bash
export GITHUB_TOKEN="your-github-personal-access-token"
```

### 2. Git Configuration

Ensure git is configured:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### 3. Repository Access

You need push access to the target GitHub repository.

## Installation

### Option 1: Local Development (Recommended for Testing)

```bash
cd /Users/jneiku/code/gh-flow-hack
claude --plugin-dir ./plugins/gh-flow-orchestrator
```

### Option 2: Project-Level Installation

```bash
# Copy plugin to project plugins directory
mkdir -p .claude/plugins
cp -r ./plugins/gh-flow-orchestrator .claude/plugins/

# Claude Code will automatically load it
```

### Option 3: User-Level Installation

```bash
# Copy plugin to user plugins directory
mkdir -p ~/.claude/plugins
cp -r ./plugins/gh-flow-orchestrator ~/.claude/plugins/

# Available in all Claude Code sessions
```

## How It Works

### Issue Eligibility Criteria

An issue is eligible for automatic implementation if:
1. **State**: Open
2. **Label**: Does NOT have "HF-required" label
3. **PR**: No associated Pull Request exists (no PR mentions the issue number)

### Workflow on SessionStart

1. **Hook Triggers**: When Claude Code starts (matcher: "startup")
2. **Execute Command**: `/gh-flow-orchestrator:check-and-implement`
3. **Find Issues**: Use GitHub MCP (`mcp__github__list_issues`) to list open issues
4. **Filter Issues**:
   - Remove issues with "HF-required" label
   - Remove issues with associated PRs (using `mcp__github__list_pull_requests`)
   - Select oldest remaining issue
5. **Spawn Subagent**: Invoke `issue-implementer` subagent
6. **Autonomous Implementation**:
   - Fetch issue details via GitHub MCP (`mcp__github__get_issue`)
   - Read architecture docs
   - Create feature branch (`git checkout -b`)
   - Implement in `/app` directory
   - Write tests
   - Commit with conventional format (`git commit`)
   - Push to remote (`git push`)
   - Create PR via GitHub MCP (`mcp__github__create_pull_request`)
7. **Report**: PR URL and summary to user

### Manual Usage

You can also manually trigger the orchestrator:

```bash
# In Claude Code session:
/gh-flow-orchestrator:check-and-implement
```

Or manually invoke the subagent for a specific issue:

```bash
# In Claude Code session:
Use the issue-implementer subagent to implement issue #42
```

## Tools Used

The plugin uses a hybrid approach:

### GitHub MCP Tools (for GitHub API operations)
- **`mcp__github__list_issues`** - List open issues with filters
- **`mcp__github__list_pull_requests`** - Find associated PRs
- **`mcp__github__get_issue`** - Fetch full issue details
- **`mcp__github__create_pull_request`** - Create PR with description

### Git Commands (for version control)
- **`git checkout -b`** - Create and switch to feature branch
- **`git add`** - Stage changes
- **`git commit`** - Commit with conventional format
- **`git push`** - Push branch to remote

## Configuration

### Customizing Hook Behavior

Edit `hooks/hooks.json` to change when the hook triggers:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup",  // Options: startup, resume, startup|resume
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Execute the /gh-flow-orchestrator:check-and-implement command..."
          }
        ]
      }
    ]
  }
}
```

**Matchers**:
- `"startup"` - Only on initial Claude Code startup (recommended)
- `"resume"` - When resuming from pause
- `"startup|resume"` - On both startup and resume

### Customizing Subagent

Edit `agents/issue-implementer.md` to modify:
- System prompt and instructions
- Tool access permissions
- Model selection (default: sonnet)
- Permission mode (default: default)

## Troubleshooting

### No Issue Selected

**Symptom**: Session starts with no issue mentioned

**Possible Causes**:
1. No eligible issues exist
2. All open issues have "HF-required" label
3. All open issues have associated PRs
4. GitHub MCP not configured

**Solution**:
```bash
# Check GitHub MCP is available
# In Claude Code, GitHub MCP tools should be visible

# Manually check issues using GitHub MCP
# In Claude Code session:
Use GitHub MCP to list all open issues in this repository
```

### Hook Not Triggering

**Symptom**: Plugin loaded but hook doesn't run on startup

**Possible Causes**:
1. Plugin not loaded correctly
2. Hook configuration malformed
3. Wrong matcher (using "resume" instead of "startup")

**Solution**:
1. Verify plugin loaded: Check Claude Code startup messages
2. Check `hooks/hooks.json` syntax is valid JSON
3. Ensure matcher is set to "startup"

### GitHub MCP Not Working

**Symptom**: "mcp__github__* tool not found" errors

**Possible Causes**:
1. GitHub MCP server not configured
2. GitHub token not set
3. MCP server failed to start

**Solution**:
1. Add GitHub MCP configuration to `.mcp.json`
2. Set `GITHUB_TOKEN` environment variable
3. Restart Claude Code
4. Check MCP server logs

### Subagent Not Spawning

**Symptom**: Command runs but subagent doesn't start

**Possible Causes**:
1. Subagent file missing or malformed
2. YAML frontmatter syntax error
3. Claude didn't recognize subagent invocation

**Solution**:
1. Verify `agents/issue-implementer.md` exists
2. Check frontmatter has valid YAML (triple dash delimiters)
3. Manually invoke: "Use the issue-implementer subagent to test"

### Implementation Fails

**Symptom**: Subagent starts but errors during implementation

**Debug Steps**:
1. Check issue requirements are clear and actionable
2. Verify `/app` directory structure exists
3. Check git working directory is clean (`git status`)
4. Verify GitHub MCP tools work: Try listing issues with MCP
5. Check if architecture docs are accessible at `/Users/jneiku/code/gh-flow-hack/docs/tech_implementation.md`

## Integration with Software Factory

This plugin automates **steps 5-6** of the 10-step Software Factory workflow:

| Step | Description | Plugin |
|------|-------------|--------|
| 1-3 | Idea → Issue creation | Manual |
| 4 | Remove "HF-required" label | Manual gate |
| **5** | **Implementation** | **✅ Automated** |
| **6** | **PR Creation** | **✅ Automated** |
| 7-10 | Code review → Refinement | Manual |

The plugin focuses on the "build and ship" phase, leaving ideation and refinement to human oversight.

## Development

### Testing the Plugin

1. **Test command directly**:
   ```bash
   # In Claude Code:
   /gh-flow-orchestrator:check-and-implement
   ```

2. **Test subagent directly**:
   ```bash
   # Create a test issue first, then:
   Use the issue-implementer subagent to implement issue #[number]
   ```

3. **Test full workflow**:
   - Create test issue without "HF-required" label
   - Start Claude Code with plugin
   - Hook should trigger automatically
   - Verify issue is discovered and implemented

### Plugin Structure

- **Commands** (`commands/`): Prompt-based commands invokable via `/plugin-name:command`
- **Agents** (`agents/`): Specialized subagents with specific prompts and tool access
- **Hooks** (`hooks/`): Event-based triggers (SessionStart, PostToolUse, etc.)
- **Manifest** (`.claude-plugin/plugin.json`): Plugin metadata and configuration

## Contributing

Follow the project's [PRINCIPLES.md](../../.claude/PRINCIPLES.md):
- **YAGNI**: Only add features when needed
- **KISS**: Keep solutions simple
- **DRY**: Eliminate duplication

## References

- [Software Factory PRD](../../docs/prd.md) - Complete workflow specification
- [Technical Architecture](../../docs/tech_implementation.md) - DeepAgents implementation guide
- [Development Principles](../../.claude/PRINCIPLES.md) - YAGNI, KISS, DRY guidelines

## License

MIT

## Support

For issues or questions:
- Check [Troubleshooting](#troubleshooting) section above
- Review [GitHub MCP documentation](https://github.com/modelcontextprotocol/servers/tree/main/src/github)
- Open an issue in the repository
