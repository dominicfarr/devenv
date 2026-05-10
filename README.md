# devenv

A Docker-based development sandbox that runs all code, tools, and AI agents inside an isolated container, keeping your Mac host clean and secure.

Built to prevent supply-chain packages, secrets leakage, and agentic tools from touching your host filesystem or credentials.

---

## How it works

Your Mac
┌─────────────────────────────────────────────────────┐
│ VS Code (UI only) │
│ ┌─────────────────────┐ │
│ │ Window / Renderer │◄──── what you see & click │
│ └────────┬────────────┘ │
│ │ JSON-RPC over socket │
└───────────┼─────────────────────────────────────────┘
│
┌───────────▼─────────────────────────────────────────┐
│ OrbStack (Linux VM) │
│ ┌───────────────────────────────────────────────┐ │
│ │ devbox container │ │
│ │ VS Code Server, Extensions, Terminal, │ │
│ │ Node, Python, Claude Code — all run here │ │
│ └───────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────┘

The VS Code window on your Mac is a thin UI shell. Every meaningful action — terminals, linters, extensions, file I/O — runs inside the container.

---

## Prerequisites

- [OrbStack](https://orbstack.dev) installed on macOS
- VS Code or Cursor with the **Dev Containers** extension

---

## Build the devbox image

Run once (and again after any `Dockerfile` change):

```bash

cd ~/Projects/devenv
docker build -t devbox .

---
Create a new project

~/Projects/devenv/new-project.sh my-project

This creates ~/Projects/my-project/, initialises a git repo, and copies the Dev Containers config.

---
Open in VS Code / Cursor

1. Open the project folder in VS Code
2. When prompted, click Reopen in Container — or use the command palette: Dev Containers: Reopen in Container
3. Wait for the container to start (fast after first build)
4. The blue banner Dev Container: devbox confirms you are inside the container

All terminals, extensions, and tools now run inside the isolated environment.
```
