#!/bin/bash
# Restore Claude context after a container rebuild.
# Run from inside the container (VS Code terminal) after claude-setup.

set -e

BACKUP_DIR="/workspaces/$(basename $(pwd))/.context-backup"

if [ ! -d "$BACKUP_DIR" ]; then
    echo "No backup found at $BACKUP_DIR"
    exit 1
fi

echo "Restoring from $BACKUP_DIR..."

[ -d "$BACKUP_DIR/claude-mem" ] && cp -r "$BACKUP_DIR/claude-mem" ~/.claude-mem && echo "  claude-mem ✓"
[ -f "$BACKUP_DIR/settings.json" ] && cp "$BACKUP_DIR/settings.json" ~/.claude/settings.json && echo "  settings.json ✓"
[ -d "$BACKUP_DIR/claude-memory" ] && cp -r "$BACKUP_DIR/claude-memory" ~/.claude/memory && echo "  claude memory ✓"

echo "Done. Run 'claude' then /reload-plugins to activate."
