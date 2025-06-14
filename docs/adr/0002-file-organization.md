# ADR-0002: File Naming and Organization Conventions

## Status

**Current:** Active

## Problem

Inconsistent file naming conventions create confusion for developers and make it difficult for LLMs to predict where code should be placed. Without standardized naming patterns, projects develop ad-hoc conventions that vary between modules and contributors. This inconsistency makes navigation harder and reduces the effectiveness of automated tooling that relies on predictable file structures.

## Decision

We will standardize on kebab-case for all files by default, with single-word lowercase folder names. Applications and tools may override these defaults when they have specialized requirements that justify deviation from the standard.

### Default Naming Conventions

- **Files**: Use kebab-case for all files: `agent-processor.ts`, `prompt-template.ts`, `conversation-manager.ts`
- **Folders**: Use single-word lowercase names: `agent`, `prompt`, `tools`
- **Standard files**: Use lowercase for conventional files: `index.ts`, `prelude.ts`, `readme.md`

### Specialized Requirements (Overrides)

Applications and tools may use different conventions when justified:

- **README.md**: Uppercase for universal recognition and platform conventions
- **CLAUDE.md**: Uppercase for LLM instruction files requiring special attention
- **Configuration files**: Follow tool expectations: `.markdownlint.json`, `package.json`

## Why This Approach

- **Consistency**: Kebab-case provides uniform, readable naming across all TypeScript files
- **Platform compatibility**: Kebab-case works reliably across all operating systems
- **Tooling support**: Most TypeScript and Node.js tools expect lowercase, hyphenated filenames
- **Cognitive load**: Single pattern reduces decision fatigue for developers
- **Flexibility**: Allows overrides for legitimate technical requirements without breaking the standard

## Implementation

### Folder Structure Example

```text
src/
├── agent/                    # Single-word folder
│   ├── agent-processor.ts    # kebab-case implementation
│   ├── conversation-manager.ts # kebab-case implementation
│   ├── index.ts             # Standard file (lowercase)
│   └── prelude.ts           # Standard file (lowercase)
├── prompt/                   # Single-word folder
│   ├── template-engine.ts    # kebab-case implementation
│   ├── context-manager.ts    # kebab-case implementation
│   └── _explain.md          # Documentation (underscore prefix)
└── tools/                    # Single-word folder
    ├── tool-executor.ts      # kebab-case implementation
    └── capability-registry.ts # kebab-case implementation
```

### Project Root Files (Specialized Requirements)

```text
project/
├── README.md               # Uppercase (universal convention)
├── CLAUDE.md              # Uppercase (LLM instruction file)
├── package.json           # Lowercase (npm convention)
├── .markdownlint.json     # Dotfile (linter convention)
└── src/                   # Follows standard conventions
```

## Consequences

- **Benefits:**
  - Predictable file locations reduce cognitive overhead
  - Consistent imports across the entire codebase
  - Better tooling support and autocomplete functionality
  - Easier migration between different operating systems
- **Trade-offs:**
  - Requires renaming existing files that don't follow the convention
  - Some developers may prefer camelCase for TypeScript files
  - Need to document when specialized requirements justify overrides

## Related ADRs

- **Builds on:** [ADR-0001: Module Organization and Folder Structure](0001-module-organization.md)
- **See also:** Import rules and export conventions will build on these naming patterns

---

## Decision Log

| Date | Status | Author | Notes |
|------|--------|--------|-------|
| 2025-06-13 | Draft | GitHub Copilot | Initial file naming conventions |
| 2025-06-13 | Active | Audrey | Reviewed and approved |
