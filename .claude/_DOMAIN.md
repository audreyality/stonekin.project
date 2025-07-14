# Claude Agent Credential Management Domain

## Problem Domain

The Stonekin project requires secure management of AI agent credentials across multiple development identities while maintaining isolation and security.

## Solution Architecture

### User-Specific Credential Isolation

Each development identity gets isolated credential storage:
```text
.claude/
├── _DOMAIN.md           # This documentation
├── .gitignore          # Protect sensitive files
└── {username}/         # User-specific credentials
    ├── .gitconfig      # Git identity configuration
    ├── .ssh/           # SSH keys directory
    └── .history        # Shell history persistence
```

### Credential File Types

**Required Files:**
- **`.gitconfig`**: Git user identity (name, email, signing keys)
- **`.ssh/`**: SSH private keys for Git authentication

**Optional Files:**
- **`.history`**: Shell command history (automatically created)
- **`.ssh/config`**: SSH client configuration
- **`.ssh/known_hosts`**: SSH host verification

### Container Mounting Strategy

**Bind Mount Architecture:**
- **Host Path**: `.claude/${CLAUDE_USER}/` (user-specific directory)
- **Container Path**: `/home/claudreyality/` (fixed container user)
- **Mount Type**: Bind mounts (not named volumes)

**Mounting Implementation:**
See [docker-compose.yml](../docker-compose.yml) for volume mounting configuration.

**Design Rationale:**
- **Fixed Container User**: All containers use `claudreyality` user for consistency
- **Dynamic Host Mounting**: User-specific host directories mount to same container location
- **Permission Preservation**: SSH key permissions (600/700) maintained through mounting
- **Read-Only Security**: Git and SSH credentials mounted read-only for security

### User Parameterization Implementation

**Container Naming Strategy:**
- Container name: `${CLAUDE_USER}-stonekin-dev` (e.g., `alice-stonekin-dev`)
- Hostname: `${CLAUDE_USER}-stonekin-dev` for network identification
- Multiple users get completely isolated containers

**Environment Variable Propagation:**
See [docker-compose.yml](../docker-compose.yml) for environment variable configuration.

**VSCode Integration:**
- DevContainer name: `${localEnv:CLAUDE_USER} Stonekin Development`
- Uses host `CLAUDE_USER` environment variable for dynamic configuration
- Each user gets their own VSCode workspace with isolated container

## Security Considerations

### Multi-User Isolation

1. **Complete Separation**: Each user's credentials are completely isolated
2. **Container Isolation**: Different containers for different users (`${CLAUDE_USER}-stonekin-dev`)
3. **No Cross-User Access**: Users cannot access other users' credentials or containers
4. **Environment Variables**: `CLAUDE_USER` controls all user-specific behavior
5. **Memory Isolation**: Each user gets isolated memory path (`/memory/${CLAUDE_USER}`)
6. **MCP Server Isolation**: Basic Memory server uses user-specific storage paths
7. **Network Isolation**: Each container gets its own network stack

### File Security

1. **Read-Only Mounting**: Git configs and SSH keys mounted read-only
2. **Permission Preservation**: SSH directory (700) and keys (600) permissions maintained
3. **Version Control Exclusion**: All user credential directories excluded via .gitignore
4. **Shell History Isolation**: Each user gets separate command history

### Container Security Implementation

1. **Fixed Container User**: All containers use `claudreyality` user (prevents UID conflicts)
2. **Mount Point Security**: User credentials only accessible to their specific container
3. **Process Isolation**: Container processes cannot access host user directories directly
4. **Bind Mount Security**: Direct file access without Docker volume complexity

## Credential Management Architecture

### Initial User Setup

Credential initialization is automated by [scripts/init-dev.sh](../scripts/init-dev.sh). For setup instructions, see [CONTRIBUTING.md](../CONTRIBUTING.md).

### Manual Credential Configuration

For manual setup procedures, see [CONTRIBUTING.md](../CONTRIBUTING.md). The credential structure follows standard SSH and Git conventions with proper isolation.

**Permission Requirements:**
- SSH directory: `700` (owner read/write/execute only)
- Private keys: `600` (owner read/write only)
- Public keys: `644` (owner read/write, others read)
- Git config: `644` (owner read/write, others read)

### Multi-User Development Architecture

Container lifecycle management supports user isolation through parameterized naming and mounting. For workflow commands, see [CONTRIBUTING.md](../CONTRIBUTING.md).

### Credential Lifecycle Management

**Automated Protection:**
- Git hooks prevent credential commits
- Doctor script validates credential isolation (see [scripts/doctor.sh](../scripts/doctor.sh))
- Container startup validates user-specific mounting
- Permission validation ensures security compliance

**Manual Verification:**
For verification commands, see [CONTRIBUTING.md](../CONTRIBUTING.md).

### Integration with DevContainer Architecture

The credential management system integrates seamlessly with the DevContainer architecture:

- **Single Container Design**: All credentials mount into the same container type
- **MCP Communication**: Credentials enable git operations within the stdio-based MCP environment
- **VSCode Integration**: Credentials work with VSCode Remote Containers automatically
- **Memory System**: User-specific credentials pair with user-specific memory isolation

For overall DevContainer architecture details, see [../.devcontainer/_DOMAIN.md](../.devcontainer/_DOMAIN.md).

For usage instructions and development workflows, see [../CONTRIBUTING.md](../CONTRIBUTING.md).

For specific configuration security requirements, see the .memory files adjacent to each configuration file.
