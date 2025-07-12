# Stonekin Project Guidelines

This document contains project-wide practices and tooling information for the Stonekin SDK. For code-specific guidelines, see `code/CLAUDE.md`.

## Banned Tools

- **Prettier** - DO NOT USE. This project does not use Prettier for code formatting.

## Project Structure

The project follows a domain-driven structure:

- `/code` - Programming implementations and SDK code
- `/docs` - Documentation including ADRs and known unknowns
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

## Development Environment Status

### ✅ Configured Tools

- **Markdown linting** - markdownlint-cli2 with `npm run lint:md`
- **Git hooks** - Husky pre-commit hooks for quality checks
- **Package management** - Root package.json for dev dependencies

### 🔄 Future Considerations

- **ESLint** - TypeScript/JavaScript linting (when modules are ready)
- **Testing framework** - Test runner setup (when modules are ready)
- **CI/CD pipeline** - Automated build and deployment

## VSCode Integration

The project includes `.markdownlint.json` which is automatically used by VSCode's markdown linting extensions.
