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

The project uses `.markdownlint.json` for markdown linting configuration. Currently configured rules:

- `line-length`: disabled (no line length limit)
- `no-inline-html`: allows `<span>` elements only

### Terminal Commands for Markdown Linting

Markdownlint is installed as a dev dependency. Use npm scripts for linting:

```bash
# Lint all markdown files in the project
npm run lint:md

# Lint and fix auto-fixable issues
npm run lint:md:fix

# For direct usage with specific paths
npx markdownlint-cli2 "docs/**/*.md"
npx markdownlint-cli2 README.md
```

Note: The following directories are excluded from linting:

- `node_modules/` - Third-party dependencies
- `.prompts/` - Prompt templates with special formatting
- `.templates/` - Template files with placeholder content

## TypeScript Configuration

TypeScript is configured in `code/core/tsconfig.json`. The project uses TypeScript 5.8.3.

### Terminal Commands for TypeScript

```bash
# Type check the core module
cd code/core && npx tsc --noEmit

# Build TypeScript files
cd code/core && npx tsc

# Watch mode for development
cd code/core && npx tsc --watch
```

## Git Configuration

The project is a git repository with main branch as the default. Current `.gitignore` excludes:

- Node.js dependencies and build artifacts
- Environment files
- IDE configurations
- OS-generated files
- Logs and temporary files

## Project Dependencies

### Development Tools Not Yet Configured

The following tools are commonly used but not yet configured in this project:

- **ESLint** - No configuration found
- **Testing Framework** - No test runner configured in package.json

### Recommendations for Future Setup

1. ✅ **Markdown linting** - Completed! Use `npm run lint:md`

2. **Consider adding ESLint** for TypeScript/JavaScript linting

3. **Set up a testing framework** appropriate for the SDK development

4. **Add Husky** for pre-commit hooks to ensure code quality

## VSCode Integration

The project includes `.markdownlint.json` which is automatically used by VSCode's markdown linting extensions. The `.claude/settings.json` file is available for Claude-specific configurations.

## Next Steps

Please let me know which of these areas you'd like to address:

1. Setting up proper dependency management for linting tools
2. Configuring ESLint and Prettier for TypeScript code
3. Setting up a testing framework
4. Creating npm scripts for common development tasks
5. Establishing a CI/CD pipeline configuration
