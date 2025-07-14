# DevContainer Boundary Reorganization - Comprehensive Implementation Plan

**Date:** 2025-07-13  
**Purpose:** Comprehensive implementation plan integrating original reorganization (A-DRAFT), synthesis recommendations (C-SYNTHESIS), and incremental doctor validation framework (D-DOCTOR)

> **📁 Implementation Files:** All file implementations referenced in this plan are available as templates in `.work/scratch/`. See `.work/scratch/INDEX.md` for a complete listing of available templates.

## Overview

This plan combines three complementary approaches:
1. **Core Reorganization** (A-DRAFT.md) - DevContainer boundary reorganization with user parameterization
2. **Infrastructure Enhancements** (C-SYNTHESIS.md) - Building on existing validation and documentation patterns
3. **Incremental Validation** (D-DOCTOR.md) - Progressive doctor script development ensuring environment stability

## Methodology: Incremental Validation Framework

### Core Principle

**Never break the development environment.** Each phase includes:
1. **Implementation Tasks** - Specific changes to be made
2. **Doctor Script Development** - Validation capabilities added incrementally  
3. **Validation Checkpoint** - Comprehensive testing before proceeding
4. **Rollback Plan** - Recovery procedure if validation fails

### Progressive Validation Strategy

- **Phase 0**: Establish baseline validation of current environment
- **Phases 1-3**: Build core infrastructure with basic validation
- **Phases 4-6**: Add advanced features with security validation
- **Phases 7-8**: Complete integration with full validation suite

### Validation Execution Pattern

Each phase ends with:
```bash
# Run all applicable doctor scripts developed so far
./scripts/devcontainer-doctor.sh

# If validation passes: proceed to next phase
# If validation fails: execute rollback plan
```

### Documentation Strategy

Each phase completion includes:
1. **Update _SESSION.md** with completion status and findings
2. **Update relevant domain files** with technical decisions and architecture changes:
   - `.devcontainer/_DOMAIN.md` for container architecture and validation patterns
   - `.claude/_DOMAIN.md` for credential management and security patterns
   - Other domain files as appropriate for the changes made
3. **Clean up _SESSION.md** after domain documentation is updated
4. **Focus on technical knowledge** (problem space, decisions, examples) not progress tracking

---

## Phase 0: Baseline Validation Framework ✅ COMPLETED

**Objective:** Establish current environment validation before making any changes

### Implementation Tasks

#### 0.1 Create Initial Doctor Script Structure

```bash
mkdir -p scripts/doctor
```

#### 0.2 Create Doctor Script Infrastructure

**Create main doctor script with container detection:**
- `scripts/doctor.sh` - Use template from `.work/scratch/doctor.sh`
- This script detects if running inside container (`/workspace` exists) and runs appropriate validation scripts
- Supports `--include-devcontainer` flag for host-to-container validation

**Create legacy trampoline script:**
- `scripts/devcontainer-doctor.sh` - Use template from `.work/scratch/devcontainer-doctor-trampoline.sh`
- Provides backward compatibility and translates legacy flags to new system

#### 0.3 Create Basic Host Validation Scripts

**Create basic validation scripts using scratch templates:**
- `scripts/doctor/docker.sh` - See `.work/scratch/docker.sh`
- `scripts/doctor/docker-compose.sh` - See `.work/scratch/docker-compose-basic.sh`  
- `scripts/doctor/required-files.sh` - See `.work/scratch/required-files-basic.sh`

#### 0.4 Make Scripts Executable

```bash
chmod +x scripts/doctor.sh
chmod +x scripts/devcontainer-doctor.sh
chmod +x scripts/doctor/*.sh
```

### Validation Checkpoint 0

```bash
# Test basic host validation
./scripts/doctor.sh

# Test legacy interface
./scripts/devcontainer-doctor.sh --skip-container
```

**Success Criteria:**
- All existing DevContainer files validated
- Docker and Docker Compose functional
- Current environment baseline established

**Rollback Plan:** If validation fails, fix underlying Docker/file issues before proceeding.

### Phase 0 Completion and Documentation

**Update _SESSION.md with completion status:**
- Mark all phase tasks as completed
- Document validation results and any issues resolved
- Record baseline environment capabilities established

**Update relevant domain files:**
- Update `.devcontainer/_DOMAIN.md` with doctor script framework architecture
- Document validation capabilities and technical decisions
- Add any new troubleshooting patterns discovered

**Clean up _SESSION.md:**
- Delete _SESSION.md file after documentation updates are complete
- Keeps work directory clean while preserving all important information in domain files

---

## Phase 1: Documentation Planning + Initial Validation Enhancement ✅ COMPLETED

**Objective:** Complete documentation planning while enhancing basic validation capabilities

### Implementation Tasks

#### 1.1 Documentation Planning (from A-DRAFT)

- ✅ Create `.work/A-DRAFT.md` with complete reorganization plan
- ✅ Create `.work/C-SYNTHESIS.md` with synthesis recommendations  
- ✅ Create `.work/D-DOCTOR.md` with doctor framework
- ✅ Create `.work/E-COMPREHENSIVE-PLAN.md` (this document)

#### 1.2 Research and Validation Documentation

- ✅ Create `.work/B-RESEARCH.md` validating plan against official specifications
- Document findings and validation results

### Doctor Script Development

#### 1.3 Enhance Required Files Validation

**Update `scripts/doctor/required-files.sh`:**
- Replace with enhanced template from `.work/scratch/required-files-enhanced.sh`

#### 1.4 Add Basic Node.js Validation

**Create `scripts/doctor/node.sh`:**
- Use template from `.work/scratch/node.sh` (basic version)

### Validation Checkpoint 1

```bash
./scripts/doctor.sh
```

**Success Criteria:**
- All documentation planning completed
- Enhanced file validation working
- Basic Node.js environment validated

**Rollback Plan:** No code changes made yet - documentation issues only require file corrections.

### Phase 1 Completion and Documentation

**Update _SESSION.md with completion status:**
- Mark enhanced validation scripts as completed
- Document Node.js validation capabilities added
- Record any validation improvements made

**Update relevant domain files:**
- Update `.devcontainer/_DOMAIN.md` with enhanced validation capabilities
- Document Node.js validation architecture and requirements
- Add any new technical decisions or troubleshooting patterns

**Clean up _SESSION.md:**
- Delete _SESSION.md file after documentation updates are complete
- Keeps work directory clean while preserving all important information in domain files

---

## Phase 2: Directory Structure + Credential Validation Framework ✅ COMPLETED

**Objective:** Create new directory structure while establishing credential validation capabilities

### Implementation Tasks

#### 2.1 Create `.claude/` Directory Structure (from A-DRAFT)

```bash
mkdir -p .claude/claudreyality
```

#### 2.2 Create Security and Configuration Files

**Create `.claude/.gitignore`:**
- Use template from `.work/scratch/claude-gitignore`

**Create `.claude/_DOMAIN.md`:**
- Use template from `.work/scratch/claude-domain.md`

#### 2.3 Create Memory Directory Structure

**Create `.devcontainer/memory/` structure:**
```bash
mkdir -p .devcontainer/memory/claudreyality
touch .devcontainer/memory/claudreyality/.gitkeep
```

**Move existing memory contents:**
```bash
# Move existing memory files to new location
if [ -d "memory" ]; then
    cp -r memory/* .devcontainer/memory/ 2>/dev/null || true
    # Keep original for now - will remove in Phase 6
fi
```

**Create `.devcontainer/memory/.markdownlint.json`:**
- Use template from `.work/scratch/memory-markdownlint.json`

**Create `.devcontainer/memory/.gitignore`:**
- Use template from `.work/scratch/memory-gitignore`

### Doctor Script Development

#### 2.4 Create Credential Files Validation

**Create `scripts/doctor/credential-files.sh`:**
- Use template from `.work/scratch/credential-files.sh`

#### 2.5 Create Environment Setup Validation

**Create `scripts/doctor/environment-setup.sh`:**
- Use template from `.work/scratch/environment-setup.sh`

### Validation Checkpoint 2

```bash
./scripts/doctor.sh
```

**Success Criteria:**
- New directory structure created successfully
- Credential validation framework operational
- Memory directory structure established
- Environment variable validation working

**Rollback Plan:**
```bash
# Remove new directories if validation fails
rm -rf .claude .devcontainer/memory
```

### Phase 2 Completion and Documentation

**Update _SESSION.md with completion status:**
- Mark directory structure creation as completed
- Document credential validation framework implementation
- Record memory directory structure establishment

**Update relevant domain files:**
- Update `.claude/_DOMAIN.md` with credential validation framework and directory structure
- Update `.devcontainer/_DOMAIN.md` with memory directory architecture
- Document security patterns and isolation setup in both domain files

**Clean up _SESSION.md:**
- Delete _SESSION.md file after documentation updates are complete
- Keeps work directory clean while preserving all important information in domain files

---

## Phase 3: Container Support + Multi-User Validation Framework ✅ COMPLETED

**Objective:** Implement user-parameterized container support with comprehensive multi-user validation

### Implementation Tasks

#### 3.1 Update DevContainer Configuration for Dynamic Users (from A-DRAFT + C-SYNTHESIS)

**Update `.devcontainer/docker-compose.yml`:**
- Use template from `.work/scratch/docker-compose.yml`

**Update `.devcontainer/devcontainer.json`:**
- Use template from `.work/scratch/devcontainer.json`

**Update `.devcontainer/Dockerfile`:**
- Add claudreyality user creation and MCP server installation
- Reference existing Dockerfile structure but add user setup

#### 3.2 Update MCP Configuration (from A-DRAFT)

**Update `.devcontainer/.mcp.json`:**
- Update basic-memory args to use `/memory/${CLAUDE_USER}` for storage path
- Keep sequential-thinking configuration as-is

### Doctor Script Development

#### 3.3 Create Container-Level Validation Scripts

**Create `.devcontainer/scripts/doctor/` directory:**
```bash
mkdir -p .devcontainer/scripts/doctor
```

**Copy main doctor script to container scripts:**
```bash
cp scripts/doctor.sh .devcontainer/scripts/
chmod +x .devcontainer/scripts/doctor.sh
```

**Create `.devcontainer/scripts/doctor/environment.sh`:**
- Use template from `.work/scratch/container-environment.sh`

**Create `.devcontainer/scripts/doctor/multi-user.sh`:**
- Use template from `.work/scratch/container-multi-user.sh`

**Note:** The main `doctor.sh` script will automatically detect it's running inside the container (by checking for `/workspace` directory) and run the container-specific validation scripts.

#### 3.4 Enhance Host-Level Docker Compose Validation

**Update `scripts/doctor/docker-compose.sh`:**
- Replace with enhanced template from `.work/scratch/docker-compose-enhanced.sh`

#### 3.5 Test Container Integration

**The main doctor script is now ready for container testing:**
- `scripts/doctor.sh --include-devcontainer` will start the container and run container validation
- The container validation uses the same `doctor.sh` script but detects it's inside the container
- Container-specific validation scripts run automatically when inside the container environment

### Validation Checkpoint 3

```bash
# Test host-only validation
./scripts/doctor.sh

# Test with container integration
CLAUDE_USER=test-user ./scripts/doctor.sh --include-devcontainer
```

**Success Criteria:**
- DevContainer configuration accepts CLAUDE_USER parameter
- Multi-user validation working
- Container can start with user parameterization
- Environment variables properly configured

**Rollback Plan:**
```bash
# Restore original DevContainer files
git checkout .devcontainer/docker-compose.yml .devcontainer/devcontainer.json .devcontainer/Dockerfile .devcontainer/.mcp.json
rm -rf .devcontainer/scripts/doctor
```

### Phase 3 Completion and Documentation

**Update _SESSION.md with completion status:**
- Mark DevContainer user parameterization as completed
- Document multi-user validation framework implementation
- Record container integration testing results

**Update relevant domain files:**
- Update `.devcontainer/_DOMAIN.md` with multi-user architecture, container validation framework, and symlink architecture
- Update `.claude/_DOMAIN.md` with new credential mounting patterns and multi-user security considerations
- Document user parameterization (CLAUDE_USER) and isolation patterns in both files

**Clean up _SESSION.md:**
- Delete _SESSION.md file after documentation updates are complete
- Keeps work directory clean while preserving all important information in domain files

---

## Phase 4: npm Scripts + Package Management Validation ✅ COMPLETED

**Objective:** Add user-parameterized npm scripts with comprehensive package validation

### Phase 4 Setup

#### 4.0 Copy Phase to _SESSION.md and Gather Domain Context

**Copy this Phase 4 section from E-PLAN.md to `.work/_SESSION.md` for focused work**

**Gather relevant domain context from updated domain files:**
- Read `.devcontainer/_DOMAIN.md` for current multi-user architecture and validation framework (updated in Phase 3)
- Read `.claude/_DOMAIN.md` for current credential management patterns (updated in Phase 3)
- Add relevant context to `_SESSION.md` for implementation guidance

### Implementation Tasks

#### 4.1 Add Dynamic Container Scripts (from A-DRAFT)

**Update `package.json` to add user-parameterized scripts:**
- Add new scripts from `.work/scratch/package-scripts-additions.json`
- Include dev container management, doctor script, and linting commands

### Doctor Script Development

#### 4.2 Enhance Node.js Validation

**Update `scripts/doctor/node.sh`:**
```bash
#!/bin/bash
set -e

echo "🔍 Node.js Version Validation"
echo "============================="

if command -v node &> /dev/null; then
    node_version=$(node --version)
    echo "✓ Node.js installed: $node_version"
else
    echo "ℹ️  Node.js not found on host system"
    echo "   This is fine - DevContainer provides Node.js"
fi

if command -v npm &> /dev/null; then
    npm_version=$(npm --version)
    echo "✓ npm available: v$npm_version"
    
    if [ -f "package.json" ]; then
        echo "✓ package.json found - npm scripts available"
        
        # Check for required dev scripts
        required_scripts=("dev:up" "dev:shell" "dev:down" "doctor")
        for script in "${required_scripts[@]}"; do
            if npm run --silent 2>/dev/null | grep -q "$script"; then
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

#### 4.3 Create Package Script Testing

**Create `scripts/doctor/package-scripts.sh`:**
```bash
#!/bin/bash
set -e

echo "🔍 Package Script Validation"
echo "============================"

echo "📦 Testing npm scripts..."

# Test non-container scripts
if npm run doctor:test 2>/dev/null; then
    echo "✓ Doctor script accessible via npm"
else
    echo "ℹ️  Doctor script validation (using direct execution)"
fi

# Test script syntax
if npm run --silent 2>/dev/null | grep -q "dev:up"; then
    echo "✓ Container management scripts available"
else
    echo "❌ Container management scripts missing"
    exit 1
fi

if npm run --silent 2>/dev/null | grep -q "lint:md"; then
    echo "✓ Linting scripts available"
else
    echo "❌ Linting scripts missing"
    exit 1
fi

# Test package.json syntax
if npm run --silent >/dev/null 2>&1; then
    echo "✓ package.json syntax is valid"
else
    echo "❌ package.json has syntax errors"
    exit 1
fi

echo "✅ Package script validation passed"
```

#### 4.4 Update Package.json Scripts Reference

**Update package.json to reference new doctor script:**
- Update "doctor" script to point to `scripts/doctor.sh` instead of `scripts/devcontainer-doctor.sh`
- Keep legacy script available for backward compatibility

### Validation Checkpoint 4

```bash
./scripts/doctor.sh
```

**Success Criteria:**
- All npm scripts properly configured
- Package validation working
- Scripts accessible via npm run
- DevContainer scripts functional with CLAUDE_USER

**Rollback Plan:**
```bash
# Restore original package.json
git checkout package.json
rm -f scripts/doctor/package-scripts.sh
```

### Phase 4 Completion and Documentation

**Update _SESSION.md with completion status:**
- Mark npm scripts implementation as completed
- Document package management validation capabilities
- Record script accessibility improvements

**Update relevant domain files:**
- Update `.devcontainer/_DOMAIN.md` with npm script user parameterization and package validation
- Add package management validation patterns to troubleshooting section
- Document script management and user isolation in developer workflow

**Clean up _SESSION.md:**
- Delete _SESSION.md file after documentation updates are complete
- Keeps work directory clean while preserving all important information in domain files

---

## Phase 5: Configuration Updates + Security Validation Framework ✅ COMPLETED

**Objective:** Update project configuration and establish comprehensive security validation

### Phase 5 Setup

#### 5.0 Phase Overview Setup

**Copy just this phase overview to `.work/_SESSION.md` for session tracking:**
- Phase objective and task list
- Work through tasks sequentially, one at a time
- For each task: copy task description → implement → mark complete

**When gathering domain context for each task:**
- Use sequential thinking to identify exactly which domain information is relevant for the specific task at hand
- Only extract the precise context needed for that implementation step
- Add focused context to the task in _SESSION.md, not entire domain file sections

### Implementation Tasks

#### 5.1 Update `.gitignore` Configuration

**Update `.gitignore`:**
- Use comprehensive template from `.work/scratch/project-gitignore`
- Includes Claude configurations, memory exclusions, and standard ignores

#### 5.2 Update User Initialization Script

**Update `scripts/init-dev.sh`:**
- Use updated template from `.work/scratch/init-dev-updated.sh`
- Requires CLAUDE_USER and CLAUDE_EMAIL environment variables
- Creates user-specific credentials in `.claude/{user}/` structure

#### 5.3 Create SSH Permission Validation

**Create `scripts/doctor/ssh-permissions.sh`:**
- Use template from `.work/scratch/ssh-permissions.sh`
- Validates SSH directory and key permissions for current CLAUDE_USER

#### 5.4 Create Security Documentation Pattern Implementation

**Create `.devcontainer/docker-compose.yml.memory`:**
- Use template from `.work/scratch/docker-compose-memory.md`
- Documents volume mount security and user isolation patterns

#### 5.5 Update .devcontainer/_DOMAIN.md Security Section

**Add to `.devcontainer/_DOMAIN.md`:**
```markdown
## Security Considerations

1. **Isolated Environment**: Container isolation from host
2. **Read-Only Mounts**: Git credentials mounted read-only  
3. **User Permissions**: Non-root user (claudreyality) for operations
4. **Network Isolation**: Custom bridge network
5. **SSH Key Security**: See [SSH configuration requirements](docker-compose.yml.memory)
6. **Multi-User Isolation**: Per-user memory and credential separation

For specific configuration security requirements, see the .memory files adjacent to each configuration file.
```

### Validation Checkpoint 5

```bash
# Test basic validation
./scripts/doctor.sh

# Test with user setup
CLAUDE_USER=test-user CLAUDE_EMAIL=test@example.com ./scripts/init-dev.sh
CLAUDE_USER=test-user ./scripts/doctor.sh
```

**Success Criteria:**
- Project configuration updated correctly
- Security validation framework operational  
- SSH permission validation working
- User initialization script functional

**Rollback Plan:**
```bash
# Restore original files
git checkout .gitignore scripts/init-dev.sh .devcontainer/_DOMAIN.md
rm -f scripts/doctor/ssh-permissions.sh .devcontainer/docker-compose.yml.memory
rm -rf .claude/test-user
```

### Phase 5 Completion and Documentation

**Update _SESSION.md with completion status:**
- Mark all tasks as completed
- Document any issues encountered and resolutions
- Record validation results

**Update relevant domain files:**
- Update `.claude/_DOMAIN.md` with SSH permission management and user setup processes
- Update `.devcontainer/_DOMAIN.md` with security validation architecture
- Document configuration update patterns and security considerations in both files

**Clean up _SESSION.md:**
- Delete _SESSION.md file after documentation updates are complete
- Keeps work directory clean while preserving all important information in domain files

---

## Phase 6: Data Migration + Memory System Validation ✅ COMPLETED

**Objective:** Migrate existing data to new structure with comprehensive validation

### Phase 6 Setup

#### 6.0 Phase Overview Setup

**Copy just this phase overview to `.work/_SESSION.md` for session tracking:**
- Phase objective and task list
- Work through tasks sequentially, one at a time
- For each task: copy task description → implement → mark complete

**When gathering domain context for each task:**
- Use sequential thinking to identify exactly which domain information is relevant for the specific task at hand
- Only extract the precise context needed for that implementation step
- Add focused context to the task in _SESSION.md, not entire domain file sections

### Implementation Tasks

#### 6.1 Data Migration (from A-DRAFT)

**Create migration script `scripts/migrate-data.sh`:**
- Use template from `.work/scratch/migrate-data.sh`
- Migrates .gitconfig-claude, .ssh-claude, and memory/ to new structure
- Preserves permissions and handles missing files gracefully

#### 6.2 Run Migration

```bash
chmod +x scripts/migrate-data.sh
./scripts/migrate-data.sh
```

### Doctor Script Development

#### 6.3 Create Memory System Validation

**Create `scripts/doctor/memory-system.sh`:**
```bash
#!/bin/bash
set -e

echo "🔍 Memory System Validation"
echo "==========================="

echo "📁 Memory Directory Structure:"
if [ -d ".devcontainer/memory" ]; then
    echo "  ✓ .devcontainer/memory directory exists"
    
    if [ -f ".devcontainer/memory/.gitignore" ]; then
        echo "  ✓ Memory .gitignore exists"
    else
        echo "  ❌ Memory .gitignore missing"
        exit 1
    fi
    
    if [ -f ".devcontainer/memory/.markdownlint.json" ]; then
        echo "  ✓ Memory markdownlint config exists"
    else
        echo "  ❌ Memory markdownlint config missing"
        exit 1
    fi
    
    # Check for CLAUDE.md
    if [ -f ".devcontainer/memory/CLAUDE.md" ]; then
        echo "  ✓ Memory CLAUDE.md exists"
    else
        echo "  ⚠️  Memory CLAUDE.md not found (may not have been migrated)"
    fi
else
    echo "  ❌ .devcontainer/memory directory not found"
    exit 1
fi

echo ""
echo "🔍 Legacy Directory Cleanup:"
if [ -d "memory" ]; then
    echo "  ⚠️  Legacy memory directory still exists"
    echo "     Consider removing after migration verification"
else
    echo "  ✓ Legacy memory directory removed"
fi

if [ -f ".gitconfig-claude" ]; then
    echo "  ⚠️  Legacy .gitconfig-claude still exists"
    echo "     Should be migrated to .claude/{username}/.gitconfig"
else
    echo "  ✓ Legacy .gitconfig-claude removed"
fi

if [ -d ".ssh-claude" ]; then
    echo "  ⚠️  Legacy .ssh-claude directory still exists"
    echo "     Should be migrated to .claude/{username}/.ssh/"
else
    echo "  ✓ Legacy .ssh-claude directory removed"
fi

echo "✅ Memory system validation passed"
```

#### 6.4 Create Container Memory Validation

**Create `.devcontainer/scripts/doctor/memory-system.sh`:**
```bash
#!/bin/bash
set -e
cd /workspace

echo "🔍 Memory System Validation"
echo "==========================="

if [ -d "/memory" ]; then
    echo "✓ Root memory directory exists"
else
    echo "❌ Root memory directory not found"
    exit 1
fi

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

#### 6.5 Create Migration Validation Script

**Create `scripts/doctor/migration-validation.sh`:**
```bash
#!/bin/bash
set -e

echo "🔍 Data Migration Validation"
echo "============================"

echo "📦 Migration Verification:"

# Check if migration appears to have run
if [ -d ".claude/claudreyality" ]; then
    echo "  ✓ Default user directory exists"
    
    if [ -f ".claude/claudreyality/.gitconfig" ]; then
        echo "  ✓ Git config migrated"
    else
        echo "  ⚠️  Git config not found (may not have existed)"
    fi
    
    if [ -d ".claude/claudreyality/.ssh" ]; then
        echo "  ✓ SSH keys migrated"
    else
        echo "  ⚠️  SSH keys not found (may not have existed)"
    fi
else
    echo "  ℹ️  Default user directory not found (migration may not have run)"
fi

if [ -f ".devcontainer/memory/CLAUDE.md" ]; then
    echo "  ✓ Memory CLAUDE.md migrated"
else
    echo "  ⚠️  Memory CLAUDE.md not found (may not have existed)"
fi

echo ""
echo "🧹 Cleanup Verification:"
legacy_files=(".gitconfig-claude" ".ssh-claude" "memory")
for item in "${legacy_files[@]}"; do
    if [ -e "$item" ]; then
        echo "  ⚠️  Legacy $item still exists"
    else
        echo "  ✓ Legacy $item removed"
    fi
done

echo "✅ Migration validation passed"
```

### Validation Checkpoint 6

```bash
# Run migration
./scripts/migrate-data.sh

# Validate migration
./scripts/doctor.sh

# Test with migrated user
CLAUDE_USER=claudreyality ./scripts/doctor.sh
```

**Success Criteria:**
- All data successfully migrated to new structure
- No legacy files remaining
- Memory system validation working
- Permissions preserved during migration

**Rollback Plan:**
```bash
# Restore from backup (if migration fails)
# This would need to be prepared before migration
echo "❌ Migration failed - manual rollback required"
echo "Restore .gitconfig-claude, .ssh-claude, and memory/ from backup"
```

### Phase 6 Completion and Documentation

**Update _SESSION.md with completion status:**
- Mark data migration as completed
- Document memory system validation implementation
- Record migration results and legacy cleanup

**Update relevant domain files:**
- Update `.devcontainer/_DOMAIN.md` with memory system validation and data migration procedures
- Update `.claude/_DOMAIN.md` with legacy file migration patterns
- Document file structure changes and migration troubleshooting in both files

**Clean up _SESSION.md:**
- Delete _SESSION.md file after documentation updates are complete
- Keeps work directory clean while preserving all important information in domain files

---

## Phase 7: Documentation + Integration Validation Framework ✅ COMPLETED

**Objective:** Complete documentation updates and establish full integration validation

### Phase 7 Setup

#### 7.0 Phase Overview Setup

**Copy just this phase overview to `.work/_SESSION.md` for session tracking:**
- Phase objective and task list
- Work through tasks sequentially, one at a time
- For each task: copy task description → implement → mark complete

**When gathering domain context for each task:**
- Use sequential thinking to identify exactly which domain information is relevant for the specific task at hand
- Only extract the precise context needed for that implementation step
- Add focused context to the task in _SESSION.md, not entire domain file sections

### Implementation Tasks

#### 7.1 Update CONTRIBUTING.md (from C-SYNTHESIS)

**Add environment variable section to CONTRIBUTING.md after "Prerequisites":**

```markdown
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
```text

#### 7.2 Create Documentation Validation

**Create `scripts/doctor/documentation.sh`:**
```bash
#!/bin/bash
set -e

echo "🔍 Documentation Validation"
echo "==========================="

echo "📚 Required Documentation:"
required_docs=(
    "CONTRIBUTING.md"
    "CLAUDE.md"
    ".claude/_DOMAIN.md"
    ".devcontainer/_DOMAIN.md"
    ".devcontainer/memory/CLAUDE.md"
)

for doc in "${required_docs[@]}"; do
    if [ -f "$doc" ]; then
        echo "  ✓ $doc exists"
    else
        echo "  ❌ $doc missing"
        exit 1
    fi
done

echo ""
echo "📋 Documentation Content Checks:"

# Check CONTRIBUTING.md for multi-user content
if grep -q "CLAUDE_USER" CONTRIBUTING.md; then
    echo "  ✓ CONTRIBUTING.md includes CLAUDE_USER documentation"
else
    echo "  ❌ CONTRIBUTING.md missing CLAUDE_USER documentation"
    exit 1
fi

# Check for _DOMAIN.md security sections
if grep -q "Security Considerations" .devcontainer/_DOMAIN.md; then
    echo "  ✓ DevContainer _DOMAIN.md has Security Considerations"
else
    echo "  ❌ DevContainer _DOMAIN.md missing Security Considerations"
    exit 1
fi

if grep -q "Security Considerations" .claude/_DOMAIN.md; then
    echo "  ✓ Claude _DOMAIN.md has Security Considerations"
else
    echo "  ❌ Claude _DOMAIN.md missing Security Considerations"
    exit 1
fi

echo "✅ Documentation validation passed"
```

### Doctor Script Development

#### 7.3 Create MCP Server Validation

**Create `.devcontainer/scripts/doctor/mcp-servers.sh`:**
```bash
#!/bin/bash
set -e
cd /workspace

echo "🔍 MCP Server Configuration Validation"
echo "======================================"

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
    echo "   Install with: pip3 install --user basic-memory"
    exit 1
fi

# Check sequential-thinking server availability  
if command -v sequential-thinking &> /dev/null; then
    echo "✓ sequential-thinking MCP server available"
elif [ -f "/usr/local/lib/node_modules/@modelcontextprotocol/server-sequential-thinking/dist/index.js" ]; then
    echo "✓ sequential-thinking MCP server available (via node)"
else
    echo "❌ sequential-thinking MCP server not found"
    echo "   Install with: npm install -g @modelcontextprotocol/server-sequential-thinking"
    exit 1
fi

echo "✅ MCP server validation passed"
```

#### 7.4 Create VSCode Integration Validation

**Create `.devcontainer/scripts/doctor/vscode-integration.sh`:**
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

#### 7.5 Add VSCode Validation to Host Scripts

**Create `scripts/doctor/vscode.sh`:**
```bash
#!/bin/bash
set -e

echo "🔍 VSCode Installation Validation"
echo "================================="

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
    if code --list-extensions 2>/dev/null | grep -q "ms-vscode-remote.remote-containers"; then
        echo "✓ DevContainers extension installed"
    else
        echo "⚠️  DevContainers extension not found"
        echo "   Install: ms-vscode-remote.remote-containers"
    fi
fi

echo "✅ VSCode validation completed (warnings are informational)"
```

### Validation Checkpoint 7

```bash
# Test documentation and integration
./scripts/devcontainer-doctor.sh

# Test full container integration
CLAUDE_USER=claudreyality npm run dev:up
CLAUDE_USER=claudreyality npm run dev:shell -c "cd /workspace && scripts/doctor/*.sh"
CLAUDE_USER=claudreyality npm run dev:down
```

**Success Criteria:**
- All documentation updated and validated
- MCP server integration working
- VSCode integration validated
- Complete container environment functional

**Rollback Plan:**
```bash
# Restore original CONTRIBUTING.md
git checkout CONTRIBUTING.md
rm -f scripts/doctor/documentation.sh scripts/doctor/vscode.sh
rm -f .devcontainer/scripts/doctor/mcp-servers.sh .devcontainer/scripts/doctor/vscode-integration.sh
```

### Phase 7 Completion and Documentation

**Update _SESSION.md with completion status:**
- Mark documentation updates as completed
- Document integration validation framework implementation
- Record MCP server and VSCode validation capabilities

**Update relevant domain files:**
- Update `.devcontainer/_DOMAIN.md` with complete integration validation architecture
- Document MCP server validation and VSCode integration patterns
- Add final container environment validation capabilities to troubleshooting section

**Clean up _SESSION.md:**
- Delete _SESSION.md file after documentation updates are complete
- Keeps work directory clean while preserving all important information in domain files

---

## Phase 8: Final Testing + Complete Validation Framework ✅ COMPLETED

**Objective:** Complete multi-user testing with full validation suite operational

### Phase 8 Setup

#### 8.0 Phase Overview Setup

**Copy just this phase overview to `.work/_SESSION.md` for session tracking:**
- Phase objective and task list
- Work through tasks sequentially, one at a time
- For each task: copy task description → implement → mark complete

**When gathering domain context for each task:**
- Use sequential thinking to identify exactly which domain information is relevant for the specific task at hand
- Only extract the precise context needed for that implementation step
- Add focused context to the task in _SESSION.md, not entire domain file sections

### Implementation Tasks

#### 8.1 Multi-User Container Testing (from A-DRAFT)

**Create comprehensive test script `scripts/test-multi-user.sh`:**
- Use template from `.work/scratch/test-multi-user.sh`
- Tests multiple users (alice, bob, claude-test) with full container lifecycle
- Validates memory isolation and cleans up after testing

#### 8.2 Complete Doctor Framework Integration

**Update `scripts/devcontainer-doctor.sh` for final version:**
- Use complete template from `.work/scratch/devcontainer-doctor-final.sh`
- Includes command line argument parsing (--skip-container, --verbose)
- Comprehensive status reporting and error handling

#### 8.3 Create Final Test Suite

**Create `scripts/run-full-tests.sh`:**
- Creates comprehensive test suite that runs all validation phases
- Tests basic environment, single user, multi-user scenarios
- Validates DevContainer standards compliance
- Provides final confirmation that environment is ready

### Validation Checkpoint 8 (Final)

```bash
# Run complete test suite
chmod +x scripts/test-multi-user.sh scripts/run-full-tests.sh
./scripts/run-full-tests.sh
```

**Success Criteria:**
- All host-level validations pass
- Container-level validations pass
- Multi-user isolation working correctly
- DevContainer standards compliance verified
- Complete doctor framework operational

**Final Verification:**
- ✅ DevContainer boundary separation (workspace, home, memory)
- ✅ User parameterization with CLAUDE_USER
- ✅ Fixed container user (claudreyality) with dynamic config mounting
- ✅ Memory isolation per user
- ✅ Security validation framework
- ✅ Comprehensive documentation

### Phase 8 Completion and Documentation

**Update _SESSION.md with completion status:**
- Mark multi-user testing as completed
- Document complete doctor framework integration
- Record final test suite implementation and results

**Update relevant domain files:**
- Update `.devcontainer/_DOMAIN.md` with final validation architecture and multi-user testing procedures
- Document complete doctor framework capabilities and final test suite
- Add comprehensive troubleshooting patterns discovered during testing
- Mark project as COMPLETE in domain documentation

**Clean up _SESSION.md:**
- Delete _SESSION.md file after documentation updates are complete
- All implementation knowledge now preserved in appropriate domain files

---

## Success Criteria & Validation Framework

### Environment Integrity Guarantees

1. **Progressive Validation**: Each phase validated before proceeding
2. **Rollback Capability**: Clear rollback procedures if validation fails
3. **Incremental Doctor Development**: Validation capabilities built progressively
4. **No Breaking Changes**: Development environment remains functional throughout

### Final Validation Commands

```bash
# Quick validation
npm run doctor

# Full validation with container testing
CLAUDE_USER=your-identifier npm run doctor

# Complete test suite
./scripts/run-full-tests.sh

# Multi-user testing
./scripts/test-multi-user.sh
```

### DevContainer Standards Compliance

- ✅ **Workspace Boundary**: `/workspace` for project files
- ✅ **User Home Boundary**: `/home/claudreyality` for user configs  
- ✅ **Memory Boundary**: `/memory` for agent memory
- ✅ **Fixed Container User**: `claudreyality` user in all containers
- ✅ **Dynamic Config Mounting**: Host `.claude/{user}/` → container home
- ✅ **User Parameterization**: `CLAUDE_USER` environment variable
- ✅ **Isolation**: Complete separation between users

### Troubleshooting & Recovery

#### Common Issues

1. **CLAUDE_USER not set**: `export CLAUDE_USER=your-identifier`
2. **Permission errors**: Run `scripts/doctor/ssh-permissions.sh` for guidance
3. **Container won't start**: Run `npm run doctor` to diagnose
4. **Docker issues**: Check Docker Desktop is running

#### Recovery Procedures

```bash
# Reset to clean state
npm run dev:clean
docker system prune -f

# Reinitialize user
CLAUDE_USER=your-name CLAUDE_EMAIL=your@email.com ./scripts/init-dev.sh

# Validate environment
npm run doctor
```

## Conclusion

This comprehensive plan integrates the original reorganization strategy with synthesis recommendations and incremental validation, ensuring environment stability throughout the refactor process. The progressive doctor script development provides confidence at each step, while the complete validation framework ensures long-term maintainability and multi-user support.

The result is a DevContainer-compliant, user-parameterized development environment with comprehensive validation and security frameworks.
