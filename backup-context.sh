#!/bin/bash
# Back up Claude context before a container rebuild.
# Run from inside the container (VS Code terminal).
# Backup lands in /workspaces/<project>/.context-backup/ which maps to your Mac.

set -e

BACKUP_DIR="/workspaces/$(basename $(pwd))/.context-backup"
mkdir -p "$BACKUP_DIR"

echo "Backing up to $BACKUP_DIR..."

[ -d ~/.claude-mem ] && cp -r ~/.claude-mem "$BACKUP_DIR/claude-mem" && echo "  claude-mem ✓"
[ -f ~/.claude/settings.json ] && cp ~/.claude/settings.json "$BACKUP_DIR/settings.json" && echo "  settings.json ✓"
[ -d ~/.claude/memory ] && cp -r ~/.claude/memory "$BACKUP_DIR/claude-memory" && echo "  claude memory ✓"

echo "Done. Backup at $BACKUP_DIR"
echo "Run restore-context after rebuilding the container."
