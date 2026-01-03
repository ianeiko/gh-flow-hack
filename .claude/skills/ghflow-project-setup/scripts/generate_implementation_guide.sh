#!/bin/bash
# Generate Implementation Guide for CLAUDE.md
# This script analyzes the project and generates project-specific implementation guidance
# Usage: generate_implementation_guide.sh > /tmp/guide.md

set -e

# Get repository root
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")

cat <<'EOF'
## Feature Implementation Guide

### Project Overview
<!-- TODO: Analyze project and fill in 2-3 sentence description -->

### Architecture
<!-- TODO: Identify architecture pattern and key abstractions -->

### Directory Structure
<!-- TODO: Generate actual project directory tree -->

### Common Patterns
<!-- TODO: Extract common patterns from codebase analysis -->

### Testing Requirements
<!-- TODO: Document testing conventions from existing tests -->

### Common Utilities
<!-- TODO: List commonly used utility modules and functions -->

### Integration Points
<!-- TODO: Document how to add new components -->

### Type Conventions
<!-- TODO: Extract type hint patterns from codebase -->

### Example Implementation
<!-- TODO: Provide 1-2 concrete examples from actual codebase -->

EOF

echo "⚠️  This is a placeholder. Manual codebase analysis required." >&2
echo "   Review project structure and populate sections above." >&2
