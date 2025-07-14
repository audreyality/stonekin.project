# Contributing to Stonekin Project

## Build Environment Setup

**⚠️ IMPORTANT: The Stonekin project requires a containerized development environment. All development must be done inside the provided DevContainer. Host-based development is not supported.**

### Prerequisites

- **Docker Desktop** - Required for the development container
- **VSCode** (recommended) - For the best development experience
- **Symlink Support** (Windows users) - Ensure symlinks are enabled for git clone

#### Windows Symlink Setup

> **⚠️ Windows Users**: This repository contains symlinks that are required for proper operation. Ensure symlinks are enabled before cloning:

```bash
# Enable developer mode in Windows Settings, OR
# Run git with symlink support:
git clone -c core.symlinks=true <repository-url>

# Verify symlinks work:
git config core.symlinks true
```

Without symlink support, the development environment may not function correctly.

### Environment Variables

**Required for Multi-User Development:**

```bash
# Set your user identifier for container isolation
export CLAUDE_USER=your-identifier

# Add to your shell profile for persistence
echo 'export CLAUDE_USER=your-identifier' >> ~/.bashrc
```

**Note:** This variable enables multiple developers to use separate container environments without conflicts.

### Multi-User Container Usage

The project supports multiple development identities through parameterized containers:

```bash
# Initialize new user environment
CLAUDE_USER=your-name CLAUDE_EMAIL=your@email.com ./scripts/init-dev.sh

# Start container for specific user
CLAUDE_USER=your-name npm run dev:up

# Enter the container
CLAUDE_USER=your-name npm run dev:shell

# Stop the container
CLAUDE_USER=your-name npm run dev:down
```

Each user gets:
- Isolated container: `{username}-stonekin-dev`
- User-specific credentials from `.claude/{username}/`
- Isolated memory at `/memory/{username}/`
- Fixed container user: `claudreyality`

### Initial Setup

1. **Install Docker Desktop**

   Download and install [Docker Desktop](https://www.docker.com/products/docker-desktop/) for your platform.

2. **Clone and Initialize**

   ```bash
   git clone <repository-url>
   cd stonekin.project
   
   # Initialize development environment
   CLAUDE_EMAIL=claude@yourdomain.com npm run init:dev
   ```

### Available Commands

#### Container Management (DevContainer)

```bash
# Start the development container
npm run dev:up

# Enter the container shell (zsh)
npm run dev:shell

# View container logs
npm run dev:logs

# Rebuild container from scratch
npm run dev:rebuild

# Stop the container
npm run dev:down

# Remove container and volumes
npm run dev:clean

# Check container status
npm run dev:status
```

#### Development Commands (inside container)

```bash
# Lint all markdown files
npm run lint:md

# Lint and fix auto-fixable issues  
npm run lint:md:fix

# Type check the core module
cd code/core && npx tsc --noEmit

# Build TypeScript files
cd code/core && npx tsc

# Watch mode for development
cd code/core && npx tsc --watch
```

**Note**: All development commands must be run inside the DevContainer. Git hooks will run automatically on commits.

## DevContainer Workflow

The project uses a fully configured development container with Claude Code, MCP servers, and all development tools:

1. **Using VSCode** (Recommended)
   - Open the project in VSCode
   - When prompted, click "Reopen in Container"
   - VSCode will build and connect to the container
   - Terminal opens with zsh at `/workspace`

2. **Using Command Line**

   ```bash
   # Start container
   npm run dev:up
   
   # Enter container
   npm run dev:shell
   ```

3. **Automated Development Setup**

   Run the initialization script to set up all credentials and check requirements:

   ```bash
   # Basic setup (email required)
   CLAUDE_EMAIL=claude@yourdomain.com npm run init:dev
   
   # Advanced setup with custom parameters
   CLAUDE_EMAIL=claude@yourdomain.com \
   CLAUDE_NAME="Claude Assistant" \
   GIT_EDITOR=vim \
   DEFAULT_BRANCH=main \
   ./scripts/init-dev.sh
   ```

   **Configuration Parameters:**
   - `CLAUDE_EMAIL` (required): Email for Claude's git commits
   - `CLAUDE_NAME` (optional): Git user name (default: "Claude (AI Assistant)")  
   - `GIT_EDITOR` (optional): Git editor preference (default: "nano")
   - `DEFAULT_BRANCH` (optional): Default git branch name (default: "main")

   **The script will:**
   - Create `.gitconfig-claude` with Claude's git identity
   - Generate SSH keys in `.ssh-claude/` directory
   - Create the memory directory
   - Verify Docker is running

   **Note**: All credential files are automatically excluded from git commits via `.gitignore`.

## Security Files and Git Exclusions

The project includes several files that contain sensitive information and are automatically excluded from version control:

### Excluded Files (.gitignore)

```bash
# Claude's credentials (security)
.gitconfig-claude       # Git identity configuration (email configurable)
.ssh-claude/            # SSH keys directory

# Memory system temporary files
memory/.tmp/
memory/*.tmp
memory/*.swp
```

### Manual Setup (fallback only)

If the automated script `./scripts/init-dev.sh` doesn't work, you can manually create these files:

1. **Create Git Config** (`.gitconfig-claude`):

   ```ini
   [user]
       name = Claude (AI Assistant)
       email = your-claude-email@domain.com
   [core]
       editor = nano
   [init]
       defaultBranch = main
   ```

2. **Generate SSH Keys** (`.ssh-claude/`):

   ```bash
   mkdir -p .ssh-claude
   ssh-keygen -t ed25519 -f .ssh-claude/id_ed25519 -C "your-claude-email@domain.com" -N ""
   chmod 700 .ssh-claude
   chmod 600 .ssh-claude/id_ed25519
   chmod 644 .ssh-claude/id_ed25519.pub
   ```

**Important**: Never commit these files to version control. They are already excluded in `.gitignore`.

## Development Guidelines

- **Prettier is BANNED** - This project does not use Prettier for code formatting
- Follow existing patterns and conventions when making changes
- Ensure all linting passes before committing
- See `CLAUDE.md` for detailed project guidelines and tooling information

## Project Structure

- `/.devcontainer` - Development container configuration
- `/code` - Programming implementations and SDK code
- `/docs` - Documentation including ADRs and known unknowns
- `/memory` - Knowledge management system (excluded from commits)
- `/scripts` - Development automation scripts
- Root level - Project configuration and documentation

**Important**: All development work happens inside the DevContainer at `/workspace`. See `CLAUDE.md` for detailed guidelines.
