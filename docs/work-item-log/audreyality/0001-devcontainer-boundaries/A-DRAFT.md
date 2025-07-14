# DevContainer Boundary Reorganization Plan (DevContainer Standard Compliant)

**Work Order Type:** Audreyality-directed implementation plan  
**Date:** 2025-07-13  
**Objective:** Reorganize directory boundaries following DevContainer standards with clear separation between workspace (`/workspace`), user home (`/home/claudreyality`), and agent memory (`/memory`). Create user-parameterized containers that mount host user configs into the container's home directory.

## Phase 1: Document Planning Process

### 1.1 Create Work Directory Documentation in Audreyality's Folder

- ✅ Create `.work/_PLAN.md` with complete reorganization plan
- Include all phases, configurations, and technical details
- Document as audreyality-directed work plan
- Track in `docs/work-item-log/audreyality/` when work order is created

### 1.2 Research and Validation Phase

- Create `.work/_RESEARCH.md` to validate plan against:
  - Official DevContainer specification documentation
  - Docker Compose best practices for parameterized containers
  - Linux user/home directory mounting conventions
  - MCP server configuration requirements
- Ground the plan with authoritative sources

## Phase 2: Create DevContainer-Standard Directory Structure

### 2.1 Create `.claude/` Directory (User-Specific Files)

- Create `.claude/claudreyality/.gitconfig` (move from `.gitconfig-claude`)
- Create `.claude/claudreyality/.ssh/` (move from `.ssh-claude/`)
- Create `.claude/.gitignore` (protect future sensitive files)
- Create `.claude/_DOMAIN.md` (document agent credential management and claude config files)

### 2.2 Create `.devcontainer/memory/` Structure (Agent Memory)

- Move existing `memory/` contents → `.devcontainer/memory/`
- Move existing `memory/CLAUDE.md` → `.devcontainer/memory/CLAUDE.md` (applies to all mountpoints)
- Create `.devcontainer/memory/claudreyality/.gitkeep` (track Claude agent mountpoint)
- Create `.devcontainer/memory/.markdownlint.json` (dual-purpose config)
- Create `.devcontainer/memory/.gitignore` (prevent accidental commits)

## Phase 3: Create User-Parameterized Container Support

### 3.1 Update DevContainer Configuration for Dynamic Users with Home Mapping

- Update `.devcontainer/docker-compose.yml`:
  ```yaml
  services:
    devcontainer:
      container_name: ${CLAUDE_USER}-stonekin-dev
      hostname: ${CLAUDE_USER}-stonekin-dev
      volumes:
        # Standard workspace mount (project files)
        - ..:/workspace:cached
        
        # User-specific home mounts into container user's home
        - ../.claude/${CLAUDE_USER}/.gitconfig:/home/claudreyality/.gitconfig:ro
        - ../.claude/${CLAUDE_USER}/.ssh:/home/claudreyality/.ssh:ro
        - ${CLAUDE_USER}-stonekin-history:/home/claudreyality/.history
        
        # Agent memory (separate from workspace and home)
        - ../.devcontainer/memory:/memory:cached
      environment:
        - CLAUDE_USER=${CLAUDE_USER}
  volumes:
    ${CLAUDE_USER}-stonekin-history:
      driver: local
  ```

- Update `.devcontainer/devcontainer.json`:
  ```json
  {
    "name": "${CLAUDE_USER} Stonekin Development",
    "remoteUser": "claudreyality",
    "containerEnv": {
      "MEMORY_FILE_PATH": "/memory",
      "CLAUDE_USER": "${CLAUDE_USER}"
    }
  }
  ```

- Update `.devcontainer/Dockerfile` to create `claudreyality` user:
  ```dockerfile
  # Create claudreyality user with home directory
  RUN groupadd --gid 1000 claudreyality \
      && useradd --uid 1000 --gid claudreyality --shell /bin/zsh --create-home claudreyality
  ```

### 3.2 Update MCP Configuration for Fixed Container User

- Update `.devcontainer/.mcp.json`:
  ```json
  {
    "mcpServers": {
      "basic-memory": {
        "command": "/home/claudreyality/.local/bin/basic-memory",
        "args": ["--storage", "/memory/${CLAUDE_USER}"]
      }
    }
  }
  ```

## Phase 4: Add User-Parameterized npm Scripts

### 4.1 Add Dynamic Container Scripts

Add to `package.json`:
```json
{
  "scripts": {
    "dev:up:user": "docker-compose -f .devcontainer/docker-compose.yml up -d",
    "dev:down:user": "docker-compose -f .devcontainer/docker-compose.yml down",
    "dev:shell:user": "docker-compose -f .devcontainer/docker-compose.yml exec devcontainer zsh",
    "dev:rebuild:user": "docker-compose -f .devcontainer/docker-compose.yml build --no-cache",
    "dev:clean:user": "docker-compose -f .devcontainer/docker-compose.yml down -v"
  }
}
```

### 4.2 Usage Examples

- Requires explicit user specification: `CLAUDE_USER=claudreyality npm run dev:up:user`
- Alternative users: `CLAUDE_USER=alice npm run dev:up:user`
- Container always has fixed `claudreyality` user, but mounts different host configs

## Phase 5: Update Project Configuration

### 5.1 Update `.gitignore`

```gitignore
# Claude agent configurations (all users)
.claude/

# DevContainer memory (prevent accidental commits)
.devcontainer/memory/*/
!.devcontainer/memory/.gitkeep
!.devcontainer/memory/*/.gitkeep
!.devcontainer/memory/.markdownlint.json
!.devcontainer/memory/CLAUDE.md
```

### 5.2 Update `scripts/init-dev.sh`

- Remove any hardcoded defaults
- Require CLAUDE_USER environment variable
- Change file creation paths to `.claude/${CLAUDE_USER}/`
- Support multi-user setup without defaults

## Phase 6: Data Migration

### 6.1 Move Files Following DevContainer Standards

- Move `.gitconfig-claude` → `.claude/claudreyality/.gitconfig`
- Move `.ssh-claude/` → `.claude/claudreyality/.ssh/` (preserve 600/644 permissions)
- Move existing `memory/` → `.devcontainer/memory/` (complete move)
- Remove named volume references from docker-compose.yml

## Phase 7: Create Documentation

### 7.1 Create `.claude/_DOMAIN.md`

Document agent credential management with fixed container user and dynamic config mounting

### 7.2 Update `.devcontainer/_DOMAIN.md`

Add section on user parameterization with fixed container user identity

### 7.3 Update Root `CONTRIBUTING.md`

Add section documenting parameterized container usage:
```markdown
## Development Environment

### User-Parameterized Containers

The project supports multiple development identities through parameterized containers:

```bash
# Start container for specific user
CLAUDE_USER=claudreyality npm run dev:up:user

# Enter the container
CLAUDE_USER=claudreyality npm run dev:shell:user

# Stop the container
CLAUDE_USER=claudreyality npm run dev:down:user
```

Each user gets:
- Isolated container: `{username}-stonekin-dev`
- User-specific credentials from `.claude/{username}/`
- Isolated memory at `/memory/{username}/`
- Fixed container user: `claudreyality`

### Setup New User

1. Create `.claude/{username}/` directory
2. Run `CLAUDE_USER={username} npm run init:dev`
3. Add SSH public key to Git provider
4. Start development: `CLAUDE_USER={username} npm run dev:up:user`

## Phase 8: Testing & Validation

### 8.1 Multi-User Container Testing

- Test user-parameterized container creation
- Verify dynamic config mounting into fixed container user home
- Confirm different git identities based on mounted configs

### 8.2 DevContainer Standard Compliance

- Verify workspace, home, and memory separation
- Test fixed container user with dynamic config mounting

## Work Methodology & Tracking

- This is an **audreyality-directed work plan**
- Track work items in `docs/work-item-log/audreyality/` folder structure
- Operator (audreyality) provides direction and guidance throughout execution
- Claude implements according to the plan and operator instructions

## Implementation Notes

### Key Design Decisions

1. **Fixed Container User**: All containers use `claudreyality` as the internal user
2. **Dynamic Config Mounting**: Host-side `.claude/{username}/` directories mount into container home
3. **DevContainer Standard Compliance**: Proper separation of `/workspace`, `/home/claudreyality`, and `/memory`
4. **No Package.json Defaults**: Explicit `CLAUDE_USER` environment variable required

### Success Criteria

- ✅ DevContainer standards compliance
- ✅ Clean directory boundaries
- ✅ Multi-user parameterization support
- ✅ Memory isolation from workspace
- ✅ Fixed container user with dynamic configs
