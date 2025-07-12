# DevContainer Architecture Domain

## Problem Domain

The Stonekin project requires a consistent, isolated development environment that supports:

1. **Claude Code**: An AI coding assistant that runs as a CLI tool
2. **MCP Servers**: Model Context Protocol servers that extend Claude's capabilities
3. **Multiple Language Runtimes**: Node.js for JavaScript/TypeScript, Python for data tools
4. **Memory Persistence**: A knowledge management system that survives container rebuilds

## Key Constraints

### MCP Communication via stdio

The most critical constraint is that MCP (Model Context Protocol) servers communicate with Claude Code through **standard input/output (stdio)**. This means:

- MCP servers must run in the same process space as Claude Code
- Multi-container architectures are not viable
- All services must coexist in a single container

### System Conflicts

- **Python Dependencies**: Basic Memory requires Python, which conflicts with macOS system Python
- **Node.js Versions**: Project requires specific Node.js version (23.11)
- **Tool Isolation**: Development tools shouldn't pollute the host system

## Solution Architecture

### Single Container Design

We implement a unified container where all components run together:

```text
┌─────────────────────────────────────────┐
│          DevContainer                    │
│                                         │
│  Claude Code (CLI)                      │
│      ↓ stdio                           │
│  Basic Memory (Python MCP)              │
│      ↓ stdio                           │
│  Sequential Thinking (Node.js MCP)      │
│                                         │
│  Runtime Environment:                   │
│  - Ubuntu 22.04 LTS                    │
│  - zsh + oh-my-zsh                     │
│  - Node.js 23.11 (via nvm)             │
│  - Python 3.11 + UV                    │
│  - Git with Claude's identity          │
└─────────────────────────────────────────┘
```

### Why Docker Compose?

Even though we use a single container, Docker Compose provides:

1. **Future Scalability**: Easy to add services (databases, APIs) later
2. **Volume Management**: Named volumes for data persistence
3. **Network Preparation**: Ready for when MCP supports HTTP transport
4. **Consistent Commands**: Same interface regardless of complexity

### Memory Storage Design

Memory is stored at the project root (`/workspace/memory/`), NOT under `/code/`:

```text
Project Root
├── memory/          # Fluid, unconstrained memories
├── code/            # Has CLAUDE.md with specific constraints
│   └── CLAUDE.md    # Rules that apply ONLY to code
└── CLAUDE.md        # Project-wide guidelines
```

**Rationale**: The `/code` directory has specialized constraints for programming. Memories need to remain fluid and adaptable, free from code-specific rules.

## Technical Decisions

### Shell Environment

**Choice**: zsh with oh-my-zsh

**Rationale**:

- Superior interactive experience
- Rich plugin ecosystem
- User familiarity
- Better autocompletion

### Package Management

**Python**: UV (modern, fast, reliable)

```bash
uv tool install basic-memory
```

**Node.js**: npm with nvm for version management

```bash
nvm install 23.11
npm install @modelcontextprotocol/server-sequential-thinking
```

### Git Configuration

Claude gets separate git credentials as the primary author:

- Mounted from `~/.gitconfig-claude`
- SSH keys from `~/.ssh-claude`
- User configured as co-author when appropriate

### Volume Strategy

```yaml
volumes:
  - ..:/workspace:cached              # Project files
  - stonekin-memory:/workspace/memory  # Persistent memory
  - ~/.gitconfig-claude:/home/claude/.gitconfig:ro
  - ~/.ssh-claude:/home/claude/.ssh:ro
```

## Developer Workflow

### NPM Scripts

All container operations are wrapped in npm scripts for consistency:

```bash
npm run dev:up      # Start container
npm run dev:shell   # Enter container
npm run dev:rebuild # Rebuild from scratch
npm run dev:down    # Stop container
```

### VSCode Integration

Developers connect via VSCode Remote Containers:

1. Open project in VSCode
2. "Reopen in Container" prompt appears
3. VSCode connects to the container
4. Terminal opens with zsh in `/workspace`

## Future Growth Path

### When MCP Supports HTTP

Once MCP servers support HTTP transport, we can:

1. Split services into separate containers
2. Use Docker networking for communication
3. Scale individual services independently

### Additional Services

The Docker Compose structure is ready for:

- PostgreSQL/Redis databases
- API services for Stonekin framework
- Monitoring/logging infrastructure
- Additional language runtimes

## Security Considerations

1. **Isolated Environment**: Container isolation from host
2. **Read-Only Mounts**: Git credentials mounted read-only
3. **User Permissions**: Non-root user (claude) for operations
4. **Network Isolation**: Custom bridge network

## Troubleshooting Guide

### Common Issues

1. **Container won't start**: Check Docker daemon is running
2. **Permission denied**: Ensure UID/GID match host user
3. **Memory not persisting**: Verify volume mounts
4. **MCP servers not found**: Check stdio paths in .mcp.json

### Debug Commands

```bash
# Check container status
npm run dev:status

# View container logs
npm run dev:logs

# Clean everything and start fresh
npm run dev:clean
npm run dev:rebuild
```

## Conclusion

This single-container architecture elegantly solves the stdio communication requirement while providing a foundation for future growth. By using Docker Compose with a thoughtful structure, we maintain simplicity today while preparing for complexity tomorrow.
