# DevContainer Architecture Domain

## Problem Domain

The Stonekin project requires a consistent, isolated development environment that supports:

1. **Claude Code**: An AI coding assistant that runs as a CLI tool
2. **MCP Servers**: Model Context Protocol servers that extend Claude's capabilities
3. **Multiple Language Runtimes**: Node.js for JavaScript/TypeScript, Python for data tools
4. **Memory Persistence**: A knowledge management system that survives container rebuilds
5. **Multi-User Development**: Support for multiple development identities with complete isolation

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
- **Multi-User Isolation**: Each developer needs isolated containers and memory without conflicts

## Solution Architecture

### Single Container Design with Multi-User Support

We implement a unified container where all components run together, with user parameterization for isolation:

```text
┌─────────────────────────────────────────┐
│   ${CLAUDE_USER}-stonekin-dev Container │
│                                         │
│  Claude Code (CLI)                      │
│      ↓ stdio                           │
│  Basic Memory (Python MCP)              │
│      ↓ storage: /memory/${CLAUDE_USER} │
│  Sequential Thinking (Node.js MCP)      │
│                                         │
│  Runtime Environment:                   │
│  - Ubuntu 22.04 LTS                    │
│  - Fixed User: claudreyality           │
│  - zsh + oh-my-zsh                     │
│  - Node.js 23.11 (via nvm)             │
│  - Python 3.11 + UV                    │
│  - User-specific credentials mounted   │
│                                         │
│  Mount Points:                          │
│  - /workspace (project files)          │
│  - /memory/${CLAUDE_USER} (agent mem)  │
│  - /home/claudreyality (user config)   │
└─────────────────────────────────────────┘
```

### Multi-User Architecture

Each developer gets their own isolated container environment with user-specific parameterization. For detailed setup and usage instructions, see [CONTRIBUTING.md](../CONTRIBUTING.md#multi-user-container-usage).

**Key Isolation Principles:**
- Container isolation: `${CLAUDE_USER}-stonekin-dev` naming
- Memory isolation: `/memory/${CLAUDE_USER}` paths
- Credential isolation: User-specific mounting (see [.claude/_DOMAIN.md](../.claude/_DOMAIN.md))

### Why Docker Compose?

Even though we use a single container, Docker Compose provides:

1. **Future Scalability**: Easy to add services (databases, APIs) later
2. **Volume Management**: Named volumes for data persistence
3. **Network Preparation**: Ready for when MCP supports HTTP transport
4. **Consistent Commands**: Same interface regardless of complexity

### Memory Storage Design

Memory is stored in user-isolated directories outside the workspace:

```text
Container Layout
├── /workspace/                    # Project files (shared)
├── /memory/                      # Agent memory root
│   ├── ${CLAUDE_USER}/          # User-specific memory
│   └── other-user/              # Another user's memory
├── /home/claudreyality/         # Container user home
│   ├── .gitconfig              # User's git config
│   ├── .ssh/                   # User's SSH keys
│   └── .history                # User's shell history
└── /code/                       # Programming constraints
    └── CLAUDE.md               # Code-specific rules
```

**Key Design Decisions:**
- **Memory Isolation**: Each user gets `/memory/${CLAUDE_USER}/` directory
- **Workspace Sharing**: Project files in `/workspace/` are shared (read-only in some cases)
- **Credential Separation**: User configs mounted from host `.claude/${CLAUDE_USER}/`
- **Agent Boundaries**: Memory separate from workspace to avoid code constraints

## Technical Decisions

### Technical Implementation

For detailed rationale on shell environment, package management, and container user choices, see `Dockerfile.memory`.

### Git Configuration

User-specific git credentials with complete isolation. For detailed credential management, see [.claude/_DOMAIN.md](../.claude/_DOMAIN.md).

### Volume Strategy

**Bind Mount Approach** (chosen over named volumes for user isolation):

```yaml
volumes:
  # Project workspace (shared across users)
  - ..:/workspace:cached
  
  # User-specific credential mounting (see .claude/_DOMAIN.md)
  - ../.claude/${CLAUDE_USER}/.gitconfig:/home/claudreyality/.gitconfig:ro
  - ../.claude/${CLAUDE_USER}/.ssh:/home/claudreyality/.ssh:ro
  - ../.claude/${CLAUDE_USER}/.history:/home/claudreyality/.history
  
  # Agent memory (user-isolated)
  - ../memory:/memory:cached
```

**Key Decision: Bind Mounts vs Named Volumes**
- **Problem**: Docker Compose doesn't support variable substitution in volume declarations
- **Solution**: Use bind mounts for user-specific files
- **Benefits**: Direct file access, easier backup, user isolation
- **Trade-offs**: Requires host directory structure, Windows symlink considerations

## Developer Workflow

For complete development workflow including container management commands, environment setup, and multi-user usage, see [CONTRIBUTING.md](../CONTRIBUTING.md).

**Package Management Validation:**
- **Required Script Validation**: Systematically checks for essential development scripts:
  - `dev:up`, `dev:shell`, `dev:down` (container lifecycle management)
  - `doctor` (environment validation)
  - Validates scripts are accessible via `npm run` interface
- **Package.json Syntax Validation**: Comprehensive JSON syntax checking and npm compatibility testing
- **Script Functionality Testing**: Active testing of npm script accessibility and execution
- **User Parameterization Validation**: Verifies all container scripts properly handle CLAUDE_USER environment variable
- **Integration with Doctor Framework**: Package validation fully integrated into progressive validation system
- **Script Isolation Testing**: Validates that user-specific parameterization works correctly for multi-user environments

### VSCode Integration

VSCode Remote Containers support user-specific configuration with dynamic container naming. For setup instructions, see [CONTRIBUTING.md](../CONTRIBUTING.md#devcontainer-workflow).

**Technical Implementation:**
- VSCode uses `${localEnv:CLAUDE_USER}` for dynamic container naming
- Each developer gets their own container instance
- All containers use the same `claudreyality` user internally

## Validation Framework

For comprehensive validation framework documentation including doctor scripts, MCP server validation, and VSCode integration, see [scripts/_DOMAIN.md](scripts/_DOMAIN.md).

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

### Multi-User Isolation

1. **Container Isolation**: Each user gets separate container (`${CLAUDE_USER}-stonekin-dev`)
2. **Memory Isolation**: User-specific memory paths (`/memory/${CLAUDE_USER}`)
3. **Credential Isolation**: User-specific credential directories (see [.claude/_DOMAIN.md](../.claude/_DOMAIN.md))
4. **Fixed Container User**: All containers use `claudreyality` user (prevents host UID conflicts)

### System Security

1. **Environment Isolation**: Container isolation from host system
2. **Permission Management**: SSH keys maintain 600/700 permissions through mounting
3. **Network Isolation**: Custom bridge network for container communication
4. **Credential Protection**: Comprehensive .gitignore patterns prevent credential exposure

### Windows Considerations

1. **Symlink Requirements**: Windows users must enable symlinks for proper operation
2. **Git Configuration**: Must use `git clone -c core.symlinks=true` for Windows
3. **Permission Mapping**: NTFS permissions may require additional configuration

## Troubleshooting Architecture

For troubleshooting commands and common issues, see [CONTRIBUTING.md](../CONTRIBUTING.md). The validation framework uses [scripts/doctor.sh](../scripts/doctor.sh) for comprehensive environment validation.

## Conclusion

This multi-user single-container architecture elegantly solves multiple challenges:

1. **MCP stdio Communication**: All services coexist in a single container for proper stdio communication
2. **User Isolation**: Complete separation between developers while sharing the same base environment
3. **Credential Security**: Read-only credential mounting with user-specific directories
4. **Memory Isolation**: Per-user memory storage for agent persistence
5. **Future Scalability**: Docker Compose structure ready for additional services
6. **Complete Validation**: Comprehensive testing framework ensures environment stability

The architecture balances simplicity with powerful multi-user capabilities, providing a foundation for collaborative development while maintaining security and isolation. For comprehensive validation framework details, see [scripts/_DOMAIN.md](scripts/_DOMAIN.md).
