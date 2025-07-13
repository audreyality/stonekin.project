# Root Configuration Domain

## Problem Domain

The Stonekin project requires consistent tooling and configuration management across multiple contexts:

1. **Code Quality**: Automated formatting and linting for maintainability
2. **Development Workflow**: Streamlined processes for both human and AI contributors
3. **Version Control**: Clear attribution and review processes
4. **Development Environment**: Consistent tooling across different machines

## Key Constraints

### AI-Human Collaboration

The project has both human and AI contributors, requiring:

- Tooling that minimizes friction for AI-generated content
- Clear separation of concerns between human and AI work
- Automated quality checks that focus on substance over style

### Multiple Contexts

Different areas of the project have different requirements:

- `/code` - Programming implementations with strict constraints
- `/docs` - Documentation with flexibility for natural language
- `/memory` - Basic Memory tool content that shouldn't be manually edited

### Tool Integration

Development tools must work together seamlessly:

- Git hooks that run quality checks
- Linters that can auto-fix issues
- Container environments with all necessary tools
- MCP servers for enhanced AI capabilities

## Solution Architecture

### Configuration Strategy

Root-level configurations provide project-wide defaults, with local overrides where needed:

```text
Root Level
├── .markdownlint.json     # Auto-fix rules + quality checks
├── package.json           # Project scripts and dependencies
├── .gitignore            # Version control exclusions
└── [tool configs]        # Other tool configurations

Subdirectories
└── .markdownlint.json    # Local overrides (e.g., disable in /memory)
```

### Philosophy

1. **Automate the Automatable**: Use auto-fix for formatting consistency
2. **Focus on Quality**: Only flag issues that impact comprehension or structure
3. **Respect Context**: Different areas have different needs
4. **Document Decisions**: Use memory files for non-obvious choices

## Configuration Inventory

### Development Tools

- **`package.json`** - Node.js project configuration and scripts
  - [npm documentation](https://docs.npmjs.com/cli/v10/configuring-npm/package-json)
  - Scripts for development workflow (`dev:*`, `lint:*`)
  - Project dependencies and dev dependencies

- **`.devcontainer/`** - Development container configuration
  - [Dev Container specification](https://containers.dev/)
  - Provides consistent development environment
  - Includes all necessary tools and MCP servers

### Code Quality

- **`.markdownlint.json`** - Markdown linting configuration
  - [markdownlint documentation](https://github.com/DavidAnson/markdownlint)
  - Auto-fixable formatting rules
  - Quality-critical rules (MD002, MD011, MD040)

- **`.markdownlintignore`** - Markdown linting exclusions
  - Pattern-based file exclusions
  - Complements local `.markdownlint.json` overrides

### Version Control

- **`.gitignore`** - Git exclusion patterns
  - [Git documentation](https://git-scm.com/docs/gitignore)
  - Standard Node.js patterns
  - Project-specific exclusions

- **`.gitconfig-claude`** - Claude's git identity
  - Separate identity for AI contributions
  - Enables clear attribution in commits

### AI Enhancement

- **`.mcp.json`** - Model Context Protocol server configuration
  - [MCP documentation](https://modelcontextprotocol.io/)
  - Basic Memory for knowledge management
  - Sequential Thinking for complex problem-solving

## Workflow Integration

### Development Workflow

1. **Container Start**: `npm run dev:up` launches the development environment
2. **Quality Checks**: Git hooks run `npm run lint:md` before commits
3. **Auto-Fix**: `npm run lint:md:fix` handles formatting issues
4. **AI Tools**: MCP servers provide enhanced capabilities within the container

### Configuration Precedence

1. Root configurations provide defaults
2. Local configurations override for specific directories
3. Memory files document project-specific decisions
4. Tool documentation provides general usage information

## Future Considerations

### Scalability

- Additional linters as new languages are added
- More MCP servers as they become available
- CI/CD configurations when deployment is needed

### Maintenance

- Regular review of linting rules based on team feedback
- Updates to development container as tools evolve
- Memory files updated as decisions change

## Conclusion

This root-level configuration approach balances consistency with flexibility, automation with quality, and supports both human and AI contributors effectively. By documenting decisions in appropriate places (configurations, memory files, and domain documentation), the project remains maintainable and understandable.
