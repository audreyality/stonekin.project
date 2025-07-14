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

- **`package.json`** - Node.js project configuration and scripts (see `package.json.memory` for detailed rationale)

- **`.devcontainer/`** - Development container configuration
  - [Dev Container specification](https://containers.dev/)
  - Provides consistent multi-user development environment
  - For credential management architecture, see [.claude/_DOMAIN.md](.claude/_DOMAIN.md)

### Code Quality

- **`.markdownlint.json`** - Markdown linting configuration (see `.markdownlint.json.memory` for detailed rationale)

- **`.markdownlintignore`** - Markdown linting exclusions
  - Pattern-based file exclusions
  - Complements local `.markdownlint.json` overrides

### Version Control

- **`.gitignore`** - Git exclusion patterns
  - [Git documentation](https://git-scm.com/docs/gitignore)
  - Standard Node.js patterns
  - Project-specific exclusions

### AI Enhancement

- **`.mcp.json`** - Model Context Protocol server configuration (see `.mcp.json.memory` for detailed rationale)

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
