#!/bin/bash
# Update CLAUDE.md with Feature Implementation Guide section
# Usage: update_claude_md.sh <guide_file>

set -e

GUIDE_FILE="$1"

if [ -z "$GUIDE_FILE" ] || [ ! -f "$GUIDE_FILE" ]; then
    echo "Error: Guide file required and must exist"
    echo "Usage: update_claude_md.sh <guide_file>"
    exit 1
fi

# Get repository root deterministically
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR/../../../.."

# Verify we're in a git repository
if [ ! -d "$REPO_ROOT/.git" ]; then
    echo "Error: Could not find repository root (.git directory not found)"
    echo "Expected repo root at: $REPO_ROOT"
    exit 1
fi

CLAUDE_MD="${REPO_ROOT}/CLAUDE.md"

if [ ! -f "$CLAUDE_MD" ]; then
    echo "Error: CLAUDE.md not found at ${CLAUDE_MD}"
    exit 1
fi

# Create backup
BACKUP="${CLAUDE_MD}.backup.$(date +%Y%m%d_%H%M%S)"
cp "$CLAUDE_MD" "$BACKUP"
echo "✅ Created backup: ${BACKUP}"

# Check if Feature Implementation Guide section exists
if grep -q "^## Feature Implementation Guide" "$CLAUDE_MD"; then
    echo "⚠️  Feature Implementation Guide section already exists"
    echo "   Replacing existing section..."

    # Remove existing section (from ## Feature Implementation Guide to next ## or EOF)
    sed -i.tmp '/^## Feature Implementation Guide/,/^## [^F]/d' "$CLAUDE_MD"
    rm "${CLAUDE_MD}.tmp"
fi

# Find insertion point (after Development Principles section)
if grep -q "^## Development Principles" "$CLAUDE_MD"; then
    # Insert after Development Principles section ends
    awk -v guide="$GUIDE_FILE" '
        /^## Development Principles/,/^## / {
            print
            if (/^## / && !/^## Development Principles/) {
                print ""
                while ((getline line < guide) > 0) {
                    print line
                }
                close(guide)
                print ""
            }
            next
        }
        {print}
    ' "$CLAUDE_MD" > "${CLAUDE_MD}.new"
    mv "${CLAUDE_MD}.new" "$CLAUDE_MD"
else
    # Append at end if Development Principles not found
    echo "" >> "$CLAUDE_MD"
    cat "$GUIDE_FILE" >> "$CLAUDE_MD"
    echo "" >> "$CLAUDE_MD"
fi

echo "✅ Updated CLAUDE.md with Feature Implementation Guide"
echo "   Backup saved to: ${BACKUP}"
