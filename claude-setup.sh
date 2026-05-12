#!/bin/bash
# Run once after container creation to authenticate Claude and configure baseline plugins.
set -e

echo "Checking Claude authentication..."
if ! claude auth status &>/dev/null; then
    echo "Not authenticated. Starting auth flow..."
    claude auth login
fi

echo "Writing Claude plugin configuration..."
mkdir -p ~/.claude
cat > ~/.claude/settings.json << 'EOF'
{
  "includeCoAuthoredBy": false,
  "enabledPlugins": {
    "skill-creator@claude-plugins-official": true,
    "context-mode@context-mode": true,
    "claude-mem@thedotmack": true,
    "frontend-design@claude-plugins-official": true,
    "superpowers@claude-plugins-official": true
  },
  "extraKnownMarketplaces": {
    "context-mode": {
      "source": {
        "source": "github",
        "repo": "mksglu/context-mode"
      }
    },
    "thedotmack": {
      "source": {
        "source": "github",
        "repo": "thedotmack/claude-mem"
      }
    }
  },
  "effortLevel": "medium",
  "skipDangerousModePermissionPrompt": true,
  "theme": "dark-daltonized"
}
EOF

echo "Done. Run 'claude' to verify plugins are listed."
