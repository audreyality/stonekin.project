# Stonekin Project Guidelines

This document contains project-wide practices and tooling information for the Stonekin SDK. For code-specific guidelines, see `code/CLAUDE.md`.

## Banned Tools

- **Prettier** - DO NOT USE. This project does not use Prettier for code formatting.

## Project Structure

The project follows a domain-driven structure:

- `/code` - Programming implementations and SDK code
- `/docs` - Documentation including ADRs and known unknowns
- `/memory` - Knowledge management system (independent of code constraints)
- `/.devcontainer` - Development container configuration
- `/.work` - Analysis reports and work artifacts (see Work Directory section)
- Root level - Project configuration and high-level documentation

## Work Directory

> [!DANGER]
> **DO NOT CHECK IN**: Work directory files should NEVER be committed to source control. They are local working files only.

Use the `.work` directory to document analyses, findings, and decisions. This provides continuity and allows tracking of work over time.

### File Types

- `_RESEARCH.md` - Analysis that explores options or documents evidence needed for planning
- `_RUBRIC.md` - Grading criteria for evaluating exploratory research results (complex decisions only)
- `_PROMPT.md` - Prompts for external LLMs to gather information not available in repository (operator executes)
- `_REPORT.md` - Implementation reports and outcomes
- `_SESSION.md` - Session notes and decision tracking within a work order
- `_REMEMBER.md` - Long-term memory for use outside dev container

### _REMEMBER.md Special Guidelines

> [!WARNING]
> DO NOT DELETE THIS FILE. ONLY EDIT IT.

> [!IMPORTANT]
> The stuff captured in this file is your long-term memory when working outside of the dev container. Inside the container, you have a memory server. Outside, you get the  .work/_REMEMBER.md file.

### Usage Guidelines

**Always document in `.work` when:**

- Analyzing problems or trade-offs
- Researching technical approaches
- Making architectural decisions
- Providing recommendations
- Completing multi-step implementations

**Operator involvement:**
- External LLM prompts from `_PROMPT.md` are handled by the operator
- Operator provides strategic guidance and executes external tasks

For detailed guidelines on each file type, see `.work/CLAUDE.md`.

This ensures all work artifacts are preserved and can inform future decisions.

## Markdown Linting

```bash
# Lint with auto-fix then check (recommended workflow)
npm run lint:md

# Fix only without checking
npm run lint:md:fix
```

**IMPORTANT:** The `npm run lint:md` command automatically fixes issues first, then reports any remaining problems.

Note: The `/memory/` directory has linting disabled as it's maintained by tools.

## TypeScript Commands

```bash
# Type check the core module
cd code/core && npx tsc --noEmit

# Build TypeScript files
cd code/core && npx tsc

# Watch mode for development
cd code/core && npx tsc --watch
```

## Memory Files

Configuration context and project-specific decisions are stored in `filename.memory` files adjacent to their respective configuration files.

```bash
# Find all memory files in the project
find . -name "*.memory" -not -path "./memory/*"

# Example: View memory for a configuration
cat .markdownlint.json.memory
```

**When to create/update memory files:**
- Documenting configuration rationale that isn't obvious from the file itself
- Recording project-specific decisions about tool usage
- Capturing implementation context that future developers need

Memory files complement but don't replace primary documentation like this file or `_DOMAIN.md`. They suppliment it, giving editors fine-grained contextual content that would otherwise clutter the implementation. For example, a high-churn configuration file might pair with a memory file listing jq operations for common edits.

## Git Hooks

Pre-commit hooks automatically run quality checks before commits.

```bash
# Git hooks run automatically, but you can test them manually:
npm run lint:md

# To bypass hooks in emergency (use sparingly):
git commit --no-verify -m "emergency commit"
```

## Git Workflow

### Repository Structure

- **`origin`** → `audreyality/stonekin.project` (main repository)
- **`claude`** → `claudreyality/stonekin.project` (Claude's working repository)

### Development Workflow

Claude follows a pull request workflow:

1. **Make commits** with Claude's git identity (`claude@audreyality.com`)
2. **Push to Claude's repository**: `git push claude main`
3. **Create pull requests** from `claudreyality/stonekin.project` → `audreyality/stonekin.project`

This provides:

- Clear attribution of AI-generated work
- Review process for all changes
- Separation between human and AI contributions
- Complete audit trail

### Commands

```bash
# Push Claude's work to its repository
git push claude main

# Push to main repository (human use only)
git push origin main
```

**Important Guidelines:**

- Claude should never push directly to `origin` (main repository)
- All Claude contributions go through pull requests for review
- Claude can freely experiment and iterate in its own repository
- Only push to `claude` remote after completing meaningful work

## Node.js Environment

### Required Version

- **Node.js v23.11** (managed via nvm)

### Setup Commands

```bash
# Install and use the correct Node.js version
nvm install 23.11
nvm use 23.11

# Verify version
node --version  # Should show v23.11.x
```

## DevContainer Environment

The project includes a fully configured development container with all tools and MCP servers:

### Container Features

- **Claude Code** with full MCP server support
- **Basic Memory** - Markdown-based knowledge management
- **Sequential Thinking** - Enhanced problem-solving
- **zsh shell** with oh-my-zsh
- **Node.js 23.11** and **Python 3.11**
- **Git with Claude's identity**

### Quick Start

```bash
# Start the container
npm run dev:up

# Enter the container
npm run dev:shell

# Stop the container
npm run dev:down
```

For VSCode users: Open project and click "Reopen in Container" when prompted.

## Development Environment Status

### ✅ Configured Tools

- **DevContainer** - Complete isolated development environment
- **Node.js** - v23.11 with nvm for version management
- **Markdown linting** - markdownlint-cli2 with `npm run lint:md`
- **Git hooks** - Husky pre-commit hooks for quality checks
- **Package management** - Root package.json for dev dependencies
- **MCP Servers** - Basic Memory and Sequential Thinking

### 🔄 Future Considerations

- **ESLint** - TypeScript/JavaScript linting (when modules are ready)
- **Testing framework** - Test runner setup (when modules are ready)
- **CI/CD pipeline** - Automated build and deployment

## Sequential Thinking Tool

Use `mcp__sequential-thinking__sequentialthinking` for complex implementation decisions requiring systematic analysis:

**Always use for:**

- Implementation approach analysis (multiple viable patterns)
- API design trade-offs (usability vs flexibility vs maintainability)
- Performance optimization analysis and bottleneck identification
- Error handling analysis
- Testing approach selection (unit vs integration vs e2e)
- Complex debugging when multiple factors could be involved
- Refactoring planning with multiple interdependent changes

**Don't use for:**

- Simple implementations following established patterns
- Straightforward tasks with clear solutions
- Basic CRUD operations or standard configurations

## Operator Relationship

The person prompting Claude is referred to as the "operator", reflecting a co-creator relationship in developing the Stonekin project.

**Operator responsibilities:**
- Execute external LLM prompts from `_PROMPT.md` files in work directories
- Provide guidance and strategic direction
- Handle tasks requiring external system access
- Make decisions about work priorities and approaches

**Collaborative approach:**
- Claude and operator work as co-creators
- Decisions are made jointly with mutual input
- Each brings different capabilities to the project
- Claude provides analysis and implementation; operator provides context and guidance

This relationship enables effective collaboration between human insight and AI capabilities.

## Memory Systems

The project uses two distinct memory systems for different types of information:

### Memory Files (`filename.memory`)

**Purpose:** Configuration context and project-specific decisions that belong in source control

**Characteristics:**
- Checked into version control
- Apply throughout entire repository (including `/code`)
- Store rationale for configuration choices
- Document project-specific decisions

**When to use:**
- Documenting configuration rationale that isn't obvious from the file itself
- Recording project-specific decisions about tool usage
- Capturing implementation context that future developers need

**Example:** `.markdownlint.json.memory` explains why specific linting rules were chosen

### Memory Tool (`/memory` folder)

**Purpose:** Information that doesn't belong in source control

**Contains:**
- Frequently referenced module relationships
- API documentation excerpts
- Early-stage ideas not ready for formal exploration
- Personal context about operators
- Topics unrelated to Stonekin project

**Characteristics:**
- Only accessible inside dev container via Basic Memory tool
- Not checked into source control
- Managed automatically by the memory server

> [!WARNING]
> DO NOT manually create or edit files in the `/memory` folder. This directory is exclusively managed by the Basic Memory tool.

### Memory System Usage

- **Memory files** are for decisions and context that should be preserved in the repository
- **Memory tool** is for working knowledge that doesn't need to be in source control
- Both systems complement each other for comprehensive knowledge management

## Documentation Patterns

The project uses a structured approach to documentation with clear scope boundaries:

### Universal Patterns (Apply Everywhere)

These patterns apply throughout the entire repository, including all directories:

- **Memory files (`filename.memory`)** - Configuration context and project-specific decisions
- **Work directory (`.work/`)** - Analysis, reports, and decision tracking

### Root-Level Patterns (Excludes /code and /memory)

These patterns apply to all directories EXCEPT `/code` and `/memory`:

- **`_DOMAIN.md`** - Architectural documentation for complex subsystems
  - When to create: Any complex subsystem requiring domain explanation
  - Structure: Problem domain, constraints, solution architecture
  - Currently used in: `.devcontainer/`, `docs/adr/`
  
- **`README.md`** - User-facing documentation following context-appropriate guidelines

- **General documentation principles:**
  - Use domain language that describes purpose and intent
  - Document decisions and rationale in appropriate files
  - Maintain clear information architecture

### Scope Exclusions

**`/code` directory:**
- Has its own comprehensive domain standards defined in `code/CLAUDE.md`
- Universal patterns (memory files, work directory) still apply
- All other documentation follows code-specific guidelines

**`/memory` directory:**
- Exclusively managed by the Basic Memory tool in dev container
- No manual documentation or editing allowed

### Cross-References

- For code work: See `code/CLAUDE.md` for complete guidelines
- For work directory details: See `.work/CLAUDE.md`
- For root configuration: See `_DOMAIN.md`

This hierarchy ensures clear boundaries while enabling appropriate documentation across all project contexts.

## VSCode Integration

The project includes `.markdownlint.json` which is automatically used by VSCode's markdown linting extensions.
