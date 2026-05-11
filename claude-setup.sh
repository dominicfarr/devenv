#!/bin/bash
# Run once after container creation to install baseline skills and plugins.
set -e

echo "Checking Claude authentication..."
if ! claude auth status &>/dev/null; then
    echo "Not authenticated. Starting auth flow..."
    claude auth login
fi

echo "Installing Claude plugins and skills..."
claude /plugin install skill-creator@claude-plugins-official
claude /plugin install superpowers@claude-plugins-official
claude /plugin install claude-mem
claude /plugin install frontend-design@claude-plugins-official

echo "Done. Run 'claude' to verify."
