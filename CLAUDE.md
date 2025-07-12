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
- Root level - Project configuration and high-level documentation

## Markdown Linting

### Terminal Commands for Markdown Linting

```bash
# Lint all markdown files in the project
npm run lint:md

# Lint and fix auto-fixable issues
npm run lint:md:fix

# For direct usage with specific paths
npx markdownlint-cli2 "docs/**/*.md"
npx markdownlint-cli2 README.md
```

Note: Configuration is in `.markdownlint.json`. Exclusions are handled automatically.

**IMPORTANT:** After writing any markdown file, immediately run `npm run lint:md:fix` to distinguish meaningful linting issues from auto-fixable formatting problems.

## TypeScript Commands

```bash
# Type check the core module
cd code/core && npx tsc --noEmit

# Build TypeScript files
cd code/core && npx tsc

# Watch mode for development
cd code/core && npx tsc --watch
```

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

## VSCode Integration

The project includes `.markdownlint.json` which is automatically used by VSCode's markdown linting extensions.
