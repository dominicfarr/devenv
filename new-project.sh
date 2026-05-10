#!/bin/bash
  set -e

  if [ -z "$1" ]; then
    echo "Usage: new-project <project-name>"
    exit 1
  fi

  PROJECT_NAME="$1"
  PROJECT_DIR="$HOME/Projects/$PROJECT_NAME"
  DEVENV_DIR="$(cd "$(dirname "$0")" && pwd)"

  if [ -d "$PROJECT_DIR" ]; then
    echo "Error: $PROJECT_DIR already exists"
    exit 1
  fi

  mkdir -p "$PROJECT_DIR"
  cp -r "$DEVENV_DIR/.devcontainer" "$PROJECT_DIR/"
  cd "$PROJECT_DIR"
  git init
  echo ".DS_Store" > .gitignore

  echo "Project created at $PROJECT_DIR"
  echo "Open in VS Code with: code $PROJECT_DIR"