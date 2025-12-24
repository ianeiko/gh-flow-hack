#!/bin/bash
# Install gh-flow-orchestrator plugin locally

set -e

PLUGIN_DIR="$HOME/.claude/plugins/gh-flow-orchestrator"
SOURCE_DIR="./plugins/gh-flow-orchestrator"

echo "Installing gh-flow-orchestrator plugin..."

# Create plugins directory if it doesn't exist
mkdir -p "$HOME/.claude/plugins"

# Remove existing plugin if present
if [ -d "$PLUGIN_DIR" ]; then
    echo "Removing existing plugin..."
    rm -rf "$PLUGIN_DIR"
fi

# Copy plugin
echo "Copying plugin files..."
cp -r "$SOURCE_DIR" "$PLUGIN_DIR"

echo "✅ Plugin installed to: $PLUGIN_DIR"
echo ""
echo "Next steps:"
echo "1. Restart Claude Code to load the plugin"
echo "2. Write your idea to idea.md"
echo "3. Run: /gh-flow-orchestrator:idea-to-pr"
echo ""
echo "For auto-implementation without review:"
echo "  /gh-flow-orchestrator:idea-to-pr --auto-implement"
