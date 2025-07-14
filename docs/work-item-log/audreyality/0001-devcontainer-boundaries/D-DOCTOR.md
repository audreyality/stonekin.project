# DevContainer Doctor Script Architecture

**Date:** 2025-07-13  
**Purpose:** Document the enhanced modular doctor script system for DevContainer validation

## Architecture Overview

The doctor script system uses a two-tier architecture:

1. **Host-level validation** - `scripts/devcontainer-doctor.sh` (project root)
2. **Container-level validation** - `.devcontainer/scripts/doctor/` (modular checks)

This separation ensures proper validation at each layer while maintaining modularity and consistency.

## Directory Structure

```text
Project Root
├── scripts/
│   ├── devcontainer-doctor.sh          # Host-level validation orchestration
│   └── doctor/                         # Host validation modules
│       ├── docker.sh                   # Docker installation and daemon
│       ├── docker-compose.sh           # Docker Compose validation
│       ├── vscode.sh                   # VSCode installation (optional)
│       ├── node.sh                     # Node.js version validation
│       ├── required-files.sh           # DevContainer configuration files
│       ├── environment-setup.sh        # Host environment variables
│       └── credential-files.sh         # Git config and SSH key setup
└── .devcontainer/
    └── scripts/
        └── doctor/                      # Container validation modules
            ├── environment.sh           # Environment variable checks
            ├── ssh-permissions.sh       # SSH key permission validation
            ├── multi-user.sh           # Multi-user configuration checks
            ├── vscode-integration.sh   # VSCode DevContainer validation
            ├── mcp-servers.sh          # MCP server configuration checks
            └── memory-system.sh        # Memory system validation
```

## Host-Level Doctor Script

**Location:** `scripts/devcontainer-doctor.sh`

**Responsibilities:**
1. Execute modular host-level validation scripts
2. Start container if host validation passes
3. Execute container-level validation scripts
4. Provide comprehensive status report

**Enhanced Modular Implementation:**
```bash
#!/bin/bash
set -e

echo "🔍 DevContainer Doctor - Host Level Validation"
echo "=============================================="
echo ""

# Execute all host-level doctor scripts
echo "🏠 Running host-level validations..."

if [ -d "scripts/doctor" ]; then
    for script in scripts/doctor/*.sh; do
        if [ -f "$script" ] && [ -x "$script" ]; then
            echo ""
            echo "Running $(basename "$script")..."
            "$script"
        fi
    done
else
    echo "❌ Host doctor scripts directory not found at scripts/doctor"
    exit 1
fi

echo ""
echo "✅ All host-level validations passed"

echo ""
echo "🚀 Starting container for internal validation..."

# Start container if not running
if ! docker-compose -f .devcontainer/docker-compose.yml ps | grep -q "Up"; then
    echo "  Starting DevContainer..."
    npm run dev:up
fi

echo ""
echo "🔍 Running container-level validation..."

# Execute container doctor scripts
docker-compose -f .devcontainer/docker-compose.yml exec -T claude-stonekin bash -c '
    cd /workspace
    echo "Container-level validation starting..."
    
    # Find and execute all doctor scripts
    if [ -d "/workspace/scripts/doctor" ]; then
        for script in /workspace/scripts/doctor/*.sh; do
            if [ -f "$script" ] && [ -x "$script" ]; then
                echo ""
                echo "Running $(basename "$script")..."
                "$script"
            fi
        done
    else
        echo "❌ Doctor scripts directory not found at /workspace/scripts/doctor"
        exit 1
    fi
    
    echo ""
    echo "✅ All container-level validations passed"
'

echo ""
echo "🎉 DevContainer validation complete!"
echo "Ready for development. Use 'npm run dev:shell' to enter container."
```

## Host-Level Doctor Scripts

**Location:** `scripts/doctor/` (project root)

**Pattern:** Each script is self-contained and executable, validates host-level requirements

### Host Script Template

```bash
#!/bin/bash
# Template for host doctor script modules

set -e

echo "🔍 [Check Name] Validation"
echo "=========================="

# Perform specific host-level validation
# Exit with non-zero code on failure
# Use consistent output format:
#   ✓ Success messages
#   ❌ Failure messages  
#   ⚠️  Warning messages
#   ℹ️  Info messages

echo "✅ [Check Name] validation passed"
```

### Individual Host Script Specifications

#### `scripts/doctor/docker.sh`

**Purpose:** Validate Docker installation and daemon status

```bash
#!/bin/bash
set -e

echo "🔍 Docker Installation Validation"
echo "================================="

# Check Docker CLI installation
if command -v docker &> /dev/null; then
    docker_version=$(docker --version)
    echo "✓ Docker CLI installed: $docker_version"
    
    # Extract version number for minimum version check
    version_num=$(echo "$docker_version" | grep -oE '[0-9]+\.[0-9]+' | head -1)
    major_version=$(echo "$version_num" | cut -d. -f1)
    minor_version=$(echo "$version_num" | cut -d. -f2)
    
    # Check minimum version (Docker 20.10+)
    if [ "$major_version" -gt 20 ] || ([ "$major_version" -eq 20 ] && [ "$minor_version" -ge 10 ]); then
        echo "✓ Docker version meets minimum requirements (20.10+)"
    else
        echo "⚠️  Docker version $version_num is below recommended minimum (20.10)"
        echo "   Consider upgrading Docker Desktop"
    fi
else
    echo "❌ Docker CLI not found in PATH"
    echo "   Install Docker Desktop: https://www.docker.com/products/docker-desktop/"
    exit 1
fi

# Check Docker daemon status
echo ""
echo "🔍 Docker Daemon Status"
echo "======================="

if docker info &> /dev/null; then
    echo "✓ Docker daemon is running"
    
    # Check Docker context
    context=$(docker context show 2>/dev/null || echo "default")
    echo "✓ Docker context: $context"
    
    # Check available disk space
    available_space=$(docker system df --format "table {{.Reclaimable}}" 2>/dev/null | tail -n +2 | head -1 || echo "Unknown")
    if [ "$available_space" != "Unknown" ]; then
        echo "ℹ️  Reclaimable space: $available_space"
    fi
else
    echo "❌ Docker daemon is not running"
    echo "   Start Docker Desktop application"
    exit 1
fi

echo "✅ Docker validation passed"
```

#### `scripts/doctor/docker-compose.sh`

**Purpose:** Validate Docker Compose installation and configuration

```bash
#!/bin/bash
set -e

echo "🔍 Docker Compose Validation"
echo "============================"

# Check Docker Compose installation
if command -v docker-compose &> /dev/null; then
    compose_version=$(docker-compose --version)
    echo "✓ Docker Compose installed: $compose_version"
    
    # Extract version for minimum check
    version_num=$(echo "$compose_version" | grep -oE '[0-9]+\.[0-9]+' | head -1)
    major_version=$(echo "$version_num" | cut -d. -f1)
    minor_version=$(echo "$version_num" | cut -d. -f2)
    
    # Check minimum version (Compose 2.0+)
    if [ "$major_version" -ge 2 ]; then
        echo "✓ Docker Compose version meets requirements (2.0+)"
    else
        echo "⚠️  Docker Compose version $version_num is below recommended (2.0+)"
    fi
else
    echo "❌ Docker Compose not found in PATH"
    echo "   Install Docker Desktop or standalone Docker Compose"
    exit 1
fi

# Validate project Docker Compose configuration
echo ""
echo "🔍 Project Configuration Validation"
echo "==================================="

if [ -f ".devcontainer/docker-compose.yml" ]; then
    echo "✓ DevContainer compose file exists"
    
    # Validate compose file syntax
    if docker-compose -f .devcontainer/docker-compose.yml config >/dev/null 2>&1; then
        echo "✓ Docker Compose configuration is valid"
    else
        echo "❌ Docker Compose configuration has errors"
        echo "   Run: docker-compose -f .devcontainer/docker-compose.yml config"
        exit 1
    fi
    
    # Check for required services
    if docker-compose -f .devcontainer/docker-compose.yml config | grep -q "claude-stonekin"; then
        echo "✓ Required service 'claude-stonekin' configured"
    else
        echo "❌ Required service 'claude-stonekin' not found"
        exit 1
    fi
else
    echo "❌ DevContainer compose file not found"
    echo "   Expected: .devcontainer/docker-compose.yml"
    exit 1
fi

echo "✅ Docker Compose validation passed"
```

#### `scripts/doctor/vscode.sh`

**Purpose:** Validate VSCode installation (optional but recommended)

```bash
#!/bin/bash
set -e

echo "🔍 VSCode Installation Validation"
echo "================================="

# Check VSCode installation (optional)
vscode_found=false

# Check common VSCode command names
for cmd in "code" "code-insiders" "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"; do
    if command -v "$cmd" &> /dev/null; then
        vscode_version=$("$cmd" --version 2>/dev/null | head -1 || echo "Unknown")
        echo "✓ VSCode found: $cmd (version: $vscode_version)"
        vscode_found=true
        break
    fi
done

if [ "$vscode_found" = false ]; then
    echo "⚠️  VSCode not found in PATH"
    echo "   VSCode is recommended for DevContainer development"
    echo "   Install from: https://code.visualstudio.com/"
    echo "   Or use: npm run dev:shell to access container directly"
else
    # Check for DevContainer extension
    echo ""
    echo "🔍 VSCode Extension Validation"
    echo "=============================="
    
    if code --list-extensions 2>/dev/null | grep -q "ms-vscode-remote.remote-containers"; then
        echo "✓ DevContainers extension installed"
    else
        echo "⚠️  DevContainers extension not found"
        echo "   Install: ms-vscode-remote.remote-containers"
        echo "   Or install Remote Development extension pack"
    fi
fi

echo "✅ VSCode validation completed (warnings are informational)"
```

#### `scripts/doctor/node.sh`

**Purpose:** Validate Node.js version requirements

```bash
#!/bin/bash
set -e

echo "🔍 Node.js Version Validation"
echo "============================="

# Check Node.js installation
if command -v node &> /dev/null; then
    node_version=$(node --version)
    echo "✓ Node.js installed: $node_version"
    
    # Extract version number
    version_num=$(echo "$node_version" | sed 's/v//')
    major_version=$(echo "$version_num" | cut -d. -f1)
    
    # Check if version matches project requirement (23.11)
    required_major=23
    if [ "$major_version" -eq "$required_major" ]; then
        echo "✓ Node.js version matches project requirement (v23.x)"
    else
        echo "⚠️  Node.js version $node_version differs from project requirement (v23.11)"
        echo "   Project uses containerized Node.js, so this is informational"
        echo "   For local development consistency, consider using nvm:"
        echo "   nvm install 23.11 && nvm use 23.11"
    fi
else
    echo "ℹ️  Node.js not found on host system"
    echo "   This is fine - DevContainer provides Node.js v23.11"
fi

# Check npm if Node.js is available
if command -v npm &> /dev/null; then
    npm_version=$(npm --version)
    echo "✓ npm available: v$npm_version"
    
    # Check if project scripts are available
    if [ -f "package.json" ]; then
        echo "✓ package.json found - npm scripts available"
        
        # Check for required dev scripts
        required_scripts=("dev:up" "dev:shell" "dev:down")
        for script in "${required_scripts[@]}"; do
            if npm run | grep -q "$script"; then
                echo "✓ Required script '$script' available"
            else
                echo "❌ Required script '$script' missing from package.json"
                exit 1
            fi
        done
    else
        echo "❌ package.json not found"
        exit 1
    fi
fi

echo "✅ Node.js validation passed"
```

#### `scripts/doctor/required-files.sh`

**Purpose:** Validate all required DevContainer configuration files exist

```bash
#!/bin/bash
set -e

echo "🔍 Required Files Validation"
echo "============================"

# Define required files and directories
required_files=(
    ".devcontainer/docker-compose.yml"
    ".devcontainer/Dockerfile"
    ".devcontainer/devcontainer.json"
    ".devcontainer/.mcp.json"
    ".devcontainer/_DOMAIN.md"
    "package.json"
    "CLAUDE.md"
    "CONTRIBUTING.md"
)

required_directories=(
    ".devcontainer/scripts/doctor"
    "scripts/doctor"
)

# Check required files
echo "📄 Checking required files..."
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✓ $file exists"
        
        # Additional validation for specific files
        case "$file" in
            "*.json")
                if python3 -c "import json; json.load(open('$file'))" 2>/dev/null; then
                    echo "    ✓ Valid JSON syntax"
                else
                    echo "    ❌ Invalid JSON syntax"
                    exit 1
                fi
                ;;
        esac
    else
        echo "  ❌ $file is missing"
        exit 1
    fi
done

# Check required directories
echo ""
echo "📁 Checking required directories..."
for dir in "${required_directories[@]}"; do
    if [ -d "$dir" ]; then
        echo "  ✓ $dir exists"
        
        # Check if directory has executable scripts
        script_count=$(find "$dir" -name "*.sh" -executable | wc -l)
        if [ "$script_count" -gt 0 ]; then
            echo "    ✓ Contains $script_count executable scripts"
        else
            echo "    ⚠️  No executable scripts found"
        fi
    else
        echo "  ❌ $dir is missing"
        exit 1
    fi
done

# Check file permissions for critical scripts
echo ""
echo "🔐 Checking script permissions..."
for script in scripts/doctor/*.sh; do
    if [ -f "$script" ]; then
        if [ -x "$script" ]; then
            echo "  ✓ $(basename "$script") is executable"
        else
            echo "  ❌ $(basename "$script") is not executable"
            echo "     Run: chmod +x $script"
            exit 1
        fi
    fi
done

echo "✅ Required files validation passed"
```

#### `scripts/doctor/environment-setup.sh`

**Purpose:** Validate host environment variable setup

```bash
#!/bin/bash
set -e

echo "🔍 Host Environment Validation"
echo "=============================="

# Check CLAUDE_USER environment variable
echo "📋 Environment Variables:"
if [ -n "$CLAUDE_USER" ]; then
    echo "  ✓ CLAUDE_USER is set: $CLAUDE_USER"
    
    # Validate CLAUDE_USER format (basic validation)
    if [[ "$CLAUDE_USER" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        echo "    ✓ CLAUDE_USER format is valid"
    else
        echo "    ⚠️  CLAUDE_USER contains special characters"
        echo "       Recommended: use only letters, numbers, hyphens, underscores"
    fi
else
    echo "  ❌ CLAUDE_USER environment variable is required"
    echo "     Set it with: export CLAUDE_USER=your-identifier"
    echo "     Add to shell profile for persistence"
    exit 1
fi

# Check shell profile setup
echo ""
echo "🐚 Shell Profile Setup:"
shell_name=$(basename "$SHELL")
case "$shell_name" in
    "bash")
        profile_file="$HOME/.bashrc"
        if [ -f "$profile_file" ]; then
            if grep -q "CLAUDE_USER" "$profile_file"; then
                echo "  ✓ CLAUDE_USER found in $profile_file"
            else
                echo "  ⚠️  CLAUDE_USER not found in $profile_file"
                echo "     Add: echo 'export CLAUDE_USER=$CLAUDE_USER' >> $profile_file"
            fi
        else
            echo "  ℹ️  $profile_file not found (will be created if needed)"
        fi
        ;;
    "zsh")
        profile_file="$HOME/.zshrc"
        if [ -f "$profile_file" ]; then
            if grep -q "CLAUDE_USER" "$profile_file"; then
                echo "  ✓ CLAUDE_USER found in $profile_file"
            else
                echo "  ⚠️  CLAUDE_USER not found in $profile_file"
                echo "     Add: echo 'export CLAUDE_USER=$CLAUDE_USER' >> $profile_file"
            fi
        else
            echo "  ℹ️  $profile_file not found (will be created if needed)"
        fi
        ;;
    *)
        echo "  ℹ️  Shell profile check skipped for $shell_name"
        ;;
esac

# Check Docker Compose variable substitution
echo ""
echo "🐳 Docker Compose Environment Test:"
if docker-compose -f .devcontainer/docker-compose.yml config >/dev/null 2>&1; then
    echo "  ✓ Environment variables work with Docker Compose"
    
    # Verify user-specific configuration
    if docker-compose -f .devcontainer/docker-compose.yml config | grep -q "$CLAUDE_USER"; then
        echo "  ✓ CLAUDE_USER properly substituted in configuration"
    else
        echo "  ⚠️  CLAUDE_USER not found in Docker Compose output"
    fi
else
    echo "  ❌ Docker Compose configuration fails with current environment"
    echo "     This may indicate environment variable issues"
    exit 1
fi

echo "✅ Host environment validation passed"
```

#### `scripts/doctor/credential-files.sh`

**Purpose:** Validate Git configuration and SSH key setup

```bash
#!/bin/bash
set -e

echo "🔍 Credential Files Validation"
echo "=============================="

# Check Git configuration file
echo "📝 Git Configuration:"
git_config_file="$HOME/.gitconfig-claude"
if [ -f "$git_config_file" ]; then
    echo "  ✓ Claude git config exists: $git_config_file"
    
    # Validate git config content
    if git config -f "$git_config_file" user.name >/dev/null 2>&1; then
        git_name=$(git config -f "$git_config_file" user.name)
        echo "    ✓ Git user name: $git_name"
    else
        echo "    ❌ Git user name not configured"
        exit 1
    fi
    
    if git config -f "$git_config_file" user.email >/dev/null 2>&1; then
        git_email=$(git config -f "$git_config_file" user.email)
        echo "    ✓ Git user email: $git_email"
    else
        echo "    ❌ Git user email not configured"
        exit 1
    fi
else
    echo "  ❌ Claude git config not found: $git_config_file"
    echo "     Create with: npm run init:dev or manual setup"
    echo "     See CONTRIBUTING.md for instructions"
    exit 1
fi

# Check SSH keys
echo ""
echo "🔑 SSH Key Configuration:"
ssh_dir="$HOME/.ssh-claude"
if [ -d "$ssh_dir" ]; then
    echo "  ✓ Claude SSH directory exists: $ssh_dir"
    
    # Check directory permissions
    dir_perms=$(stat -c %a "$ssh_dir" 2>/dev/null || stat -f %A "$ssh_dir" 2>/dev/null)
    if [ "$dir_perms" = "700" ]; then
        echo "    ✓ SSH directory permissions correct ($dir_perms)"
    else
        echo "    ⚠️  SSH directory permissions $dir_perms (should be 700)"
        echo "       Run: chmod 700 $ssh_dir"
    fi
    
    # Check for key files
    private_keys=$(find "$ssh_dir" -name "id_*" -not -name "*.pub" -type f | wc -l)
    public_keys=$(find "$ssh_dir" -name "*.pub" -type f | wc -l)
    
    if [ "$private_keys" -gt 0 ]; then
        echo "    ✓ Private keys found: $private_keys"
        
        # Check private key permissions
        find "$ssh_dir" -name "id_*" -not -name "*.pub" -type f | while read -r key; do
            key_perms=$(stat -c %a "$key" 2>/dev/null || stat -f %A "$key" 2>/dev/null)
            if [ "$key_perms" = "600" ]; then
                echo "      ✓ $(basename "$key") permissions correct ($key_perms)"
            else
                echo "      ⚠️  $(basename "$key") permissions $key_perms (should be 600)"
                echo "         Run: chmod 600 $key"
            fi
        done
    else
        echo "    ❌ No private keys found"
        echo "       Generate with: ssh-keygen -t ed25519 -f $ssh_dir/id_ed25519"
        exit 1
    fi
    
    if [ "$public_keys" -gt 0 ]; then
        echo "    ✓ Public keys found: $public_keys"
    else
        echo "    ⚠️  No public keys found (may be generated automatically)"
    fi
else
    echo "  ❌ Claude SSH directory not found: $ssh_dir"
    echo "     Create with: npm run init:dev or manual setup"
    echo "     See CONTRIBUTING.md for instructions"
    exit 1
fi

# Check .gitignore exclusions
echo ""
echo "🙈 Git Exclusion Validation:"
if [ -f ".gitignore" ]; then
    if grep -q ".gitconfig-claude" .gitignore; then
        echo "  ✓ .gitconfig-claude excluded from git"
    else
        echo "  ⚠️  .gitconfig-claude not found in .gitignore"
    fi
    
    if grep -q ".ssh-claude/" .gitignore; then
        echo "  ✓ .ssh-claude/ excluded from git"
    else
        echo "  ⚠️  .ssh-claude/ not found in .gitignore"
    fi
else
    echo "  ❌ .gitignore file not found"
    exit 1
fi

echo "✅ Credential files validation passed"
```

## Container-Level Doctor Scripts

**Mount Location:** `/workspace/scripts/doctor/` (from `.devcontainer/scripts/doctor/`)

**Pattern:** Each script is self-contained and executable

### Script Template

```bash
#!/bin/bash
# Template for doctor script modules

set -e

# Change to workspace root if needed
cd /workspace

echo "🔍 [Check Name] Validation"
echo "=========================="

# Perform specific validation
# Exit with non-zero code on failure
# Use consistent output format:
#   ✓ Success messages
#   ❌ Failure messages  
#   ⚠️  Warning messages
#   ℹ️  Info messages

echo "✅ [Check Name] validation passed"
```

### Individual Script Specifications

#### `.devcontainer/scripts/doctor/environment.sh`

**Purpose:** Validate environment variables and configuration

```bash
#!/bin/bash
set -e
cd /workspace

echo "🔍 Environment Variable Validation"
echo "=================================="

# Check CLAUDE_USER
if [ -z "$CLAUDE_USER" ]; then
    echo "❌ CLAUDE_USER environment variable is required"
    echo "   Set it to your preferred user identifier:"
    echo "   export CLAUDE_USER=your-identifier"
    exit 1
else
    echo "✓ CLAUDE_USER is set: $CLAUDE_USER"
fi

# Check MEMORY_FILE_PATH
if [ -z "$MEMORY_FILE_PATH" ]; then
    echo "❌ MEMORY_FILE_PATH environment variable is missing"
    exit 1
else
    echo "✓ MEMORY_FILE_PATH is set: $MEMORY_FILE_PATH"
fi

# Validate memory directory exists and is writable
if [ -d "$MEMORY_FILE_PATH" ] && [ -w "$MEMORY_FILE_PATH" ]; then
    echo "✓ Memory directory accessible and writable"
else
    echo "❌ Memory directory not accessible: $MEMORY_FILE_PATH"
    exit 1
fi

echo "✅ Environment validation passed"
```

#### `.devcontainer/scripts/doctor/ssh-permissions.sh`

**Purpose:** Validate SSH key permissions and configuration

```bash
#!/bin/bash
set -e
cd /workspace

echo "🔍 SSH Permission Validation"
echo "============================"

SSH_DIR="/home/claudreyality/.ssh"

if [ -d "$SSH_DIR" ]; then
    # Check directory permissions
    dir_perms=$(stat -c %a "$SSH_DIR" 2>/dev/null)
    if [ "$dir_perms" = "700" ]; then
        echo "✓ SSH directory permissions correct ($dir_perms)"
    else
        echo "❌ SSH directory has permissions $dir_perms (should be 700)"
        echo "   Run: chmod 700 $SSH_DIR"
        exit 1
    fi
    
    # Check private key permissions
    private_key_errors=0
    find "$SSH_DIR" -name "id_*" -not -name "*.pub" | while read -r key; do
        if [ -f "$key" ]; then
            key_perms=$(stat -c %a "$key" 2>/dev/null)
            if [ "$key_perms" = "600" ]; then
                echo "✓ Private key permissions correct: $(basename "$key")"
            else
                echo "❌ Private key has permissions $key_perms (should be 600): $(basename "$key")"
                echo "   Run: chmod 600 $key"
                private_key_errors=$((private_key_errors + 1))
            fi
        fi
    done
    
    if [ $private_key_errors -gt 0 ]; then
        exit 1
    fi
    
    # Check public key permissions
    find "$SSH_DIR" -name "*.pub" | while read -r key; do
        if [ -f "$key" ]; then
            key_perms=$(stat -c %a "$key" 2>/dev/null)
            if [ "$key_perms" = "644" ]; then
                echo "✓ Public key permissions correct: $(basename "$key")"
            else
                echo "⚠️  Public key has permissions $key_perms (should be 644): $(basename "$key")"
                echo "   Run: chmod 644 $key"
            fi
        fi
    done
else
    echo "ℹ️  SSH directory not found at $SSH_DIR"
    echo "   This is normal if SSH keys haven't been set up yet"
fi

echo "✅ SSH permission validation passed"
```

#### `.devcontainer/scripts/doctor/multi-user.sh`

**Purpose:** Validate multi-user configuration and isolation

```bash
#!/bin/bash
set -e
cd /workspace

echo "🔍 Multi-User Configuration Validation"
echo "======================================"

if [ -n "$CLAUDE_USER" ]; then
    # Check user-specific memory path
    expected_memory_path="/memory/${CLAUDE_USER}"
    if [ "$MEMORY_FILE_PATH" = "$expected_memory_path" ]; then
        echo "✓ Memory path correctly isolated: $MEMORY_FILE_PATH"
    else
        echo "❌ Memory path not user-specific"
        echo "   Expected: $expected_memory_path"
        echo "   Actual: $MEMORY_FILE_PATH"
        exit 1
    fi
    
    # Verify memory directory isolation
    if [ -d "$MEMORY_FILE_PATH" ]; then
        echo "✓ User-specific memory directory exists"
    else
        echo "⚠️  User-specific memory directory doesn't exist yet"
        echo "   It will be created on first use"
    fi
    
    # Check git identity
    git_user=$(git config user.name 2>/dev/null || echo "")
    git_email=$(git config user.email 2>/dev/null || echo "")
    
    if [ -n "$git_user" ] && [ -n "$git_email" ]; then
        echo "✓ Git identity configured: $git_user <$git_email>"
    else
        echo "❌ Git identity not configured"
        echo "   Expected git config from mounted .gitconfig-claude"
        exit 1
    fi
else
    echo "❌ CLAUDE_USER not set - multi-user validation skipped"
    exit 1
fi

echo "✅ Multi-user configuration validation passed"
```

#### `.devcontainer/scripts/doctor/vscode-integration.sh`

**Purpose:** Validate VSCode DevContainer integration

```bash
#!/bin/bash
set -e
cd /workspace

echo "🔍 VSCode Integration Validation"
echo "==============================="

# Check devcontainer.json syntax
if command -v python3 &> /dev/null; then
    if python3 -m json.tool .devcontainer/devcontainer.json >/dev/null 2>&1; then
        echo "✓ devcontainer.json is valid JSON"
    else
        echo "❌ devcontainer.json has syntax errors"
        exit 1
    fi
else
    echo "⚠️  Python not available for JSON validation"
fi

# Check workspace folder configuration
if grep -q '"workspaceFolder".*"/workspace"' .devcontainer/devcontainer.json; then
    echo "✓ workspaceFolder correctly set to /workspace"
else
    echo "⚠️  workspaceFolder not explicitly set to /workspace"
fi

# Check remoteUser configuration
if grep -q '"remoteUser".*"claudreyality"' .devcontainer/devcontainer.json; then
    echo "✓ remoteUser correctly set to claudreyality"
else
    echo "❌ remoteUser not set to claudreyality"
    exit 1
fi

# Verify we're running as the correct user
current_user=$(whoami)
if [ "$current_user" = "claudreyality" ]; then
    echo "✓ Running as correct user: $current_user"
else
    echo "❌ Running as wrong user: $current_user (should be claudreyality)"
    exit 1
fi

echo "✅ VSCode integration validation passed"
```

#### `.devcontainer/scripts/doctor/mcp-servers.sh`

**Purpose:** Validate MCP server configuration and connectivity

```bash
#!/bin/bash
set -e
cd /workspace

echo "🔍 MCP Server Configuration Validation"
echo "======================================"

# Check MCP configuration file
if [ -f ".devcontainer/.mcp.json" ]; then
    echo "✓ MCP configuration file exists"
    
    # Validate JSON syntax
    if command -v python3 &> /dev/null; then
        if python3 -m json.tool .devcontainer/.mcp.json >/dev/null 2>&1; then
            echo "✓ MCP configuration is valid JSON"
        else
            echo "❌ MCP configuration has syntax errors"
            exit 1
        fi
    fi
else
    echo "❌ MCP configuration file not found"
    exit 1
fi

# Check basic-memory server availability
if command -v basic-memory &> /dev/null; then
    echo "✓ basic-memory MCP server available"
else
    echo "❌ basic-memory MCP server not found"
    echo "   Install with: uv tool install basic-memory"
    exit 1
fi

# Check sequential-thinking server availability  
if command -v sequential-thinking &> /dev/null; then
    echo "✓ sequential-thinking MCP server available"
else
    echo "❌ sequential-thinking MCP server not found"
    echo "   Install with: npm install -g @modelcontextprotocol/server-sequential-thinking"
    exit 1
fi

echo "✅ MCP server validation passed"
```

#### `.devcontainer/scripts/doctor/memory-system.sh`

**Purpose:** Validate memory system configuration and accessibility

```bash
#!/bin/bash
set -e
cd /workspace

echo "🔍 Memory System Validation"
echo "==========================="

# Check memory directory structure
if [ -d "/memory" ]; then
    echo "✓ Root memory directory exists"
else
    echo "❌ Root memory directory not found"
    exit 1
fi

# Check user-specific memory access
if [ -n "$MEMORY_FILE_PATH" ] && [ -d "$MEMORY_FILE_PATH" ]; then
    echo "✓ User memory directory accessible: $MEMORY_FILE_PATH"
    
    # Test write permissions
    test_file="$MEMORY_FILE_PATH/.doctor-test-$$"
    if echo "test" > "$test_file" 2>/dev/null; then
        rm -f "$test_file"
        echo "✓ Memory directory is writable"
    else
        echo "❌ Memory directory is not writable"
        exit 1
    fi
else
    echo "⚠️  User memory directory will be created on first use"
fi

# Verify memory system doesn't interfere with workspace
if [ ! -d "/workspace/memory" ]; then
    echo "✓ Memory system properly isolated from workspace"
else
    echo "⚠️  Memory directory exists in workspace (should be external mount)"
fi

echo "✅ Memory system validation passed"
```

## Usage Workflow

### For Developers

1. **Initial Setup Validation:**
   ```bash
   # Run comprehensive validation
   ./scripts/devcontainer-doctor.sh
   ```

2. **Quick Container Check (if container already running):**
   ```bash
   # Enter container and run specific checks
   npm run dev:shell
   cd /workspace/scripts/doctor
   ./environment.sh
   ```

### For CI/CD Integration

```bash
# Automated validation in CI
./scripts/devcontainer-doctor.sh --no-interactive
```

## Benefits of Modular Architecture

1. **Maintainability** - Each check is isolated and can be updated independently
2. **Debugging** - Failed validations point to specific problem areas
3. **Extensibility** - New checks can be added without modifying existing scripts
4. **Reusability** - Container scripts can be run independently or in combination
5. **Consistency** - Uniform output format and error handling across all checks

## Integration with Existing Infrastructure

- **Mount Point:** `.devcontainer/scripts/` → `/workspace/scripts/`
- **Execution Context:** All container scripts run from `/workspace` root
- **Error Handling:** Any script failure stops the entire validation process
- **Output Format:** Consistent emoji-based status indicators
- **File Permissions:** All scripts must be executable (`chmod +x`)

## Future Enhancements

- **Parallel Execution:** Run independent checks in parallel for faster validation
- **Repair Mode:** Automatic fixing of common issues where safe
- **Verbose Mode:** Detailed output for debugging complex problems
- **Report Generation:** Structured output for integration with monitoring systems
