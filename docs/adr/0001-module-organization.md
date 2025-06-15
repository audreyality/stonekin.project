# ADR-0001: Module Organization and Folder Structure

## Status

**Current:** Active

## Problem

The Stonekin SDK needs a consistent approach to organizing code into modules with clear boundaries and dependencies. Without structured organization principles, modules can become tightly coupled, difficult to test in isolation, and challenging for both developers and LLMs to navigate. We need to establish how folders relate to each other and what responsibilities each level of the hierarchy should have.

## Decision

We will organize code using a hierarchical module structure where each folder represents a cohesive module with clear boundaries. The architecture follows a parent-child relationship model where:

- **Root folders** contain system-level interfaces and core abstractions
- **Subfolders** group related functionality into specialized sub-systems that serve the root system
- **Modules** minimize direct dependencies on sibling modules
- **Child modules** may depend on parent abstractions via prelude files

## Why This Approach

- **Clear boundaries**: Each folder has a single, well-defined responsibility
- **Testable isolation**: Modules can be tested independently due to clear dependency rules
- **Scalable hierarchy**: The parent-child model scales from simple to complex architectures
- **Reduced coupling**: Sibling isolation prevents tangled dependencies
- **Incremental development**: Modules can be built organically as functionality requires them

## Implementation

### Folder Structure Example

```text
src/
├── agent/                    # Root module for agent orchestration
│   ├── supervisor/           # Child module for agent runtime management
│   └── registry/             # Child module for agent discovery
├── prompt/                   # Root module for prompt management
│   ├── history/              # Child module for conversation tracking
│   └── templates/            # Child module for prompt templating
└── tools/                    # Root module for tool integration
    ├── mcp/                  # Child module for MCP protocol
    └── registry/             # Child module for tool discovery
```

### Dependency Rules

- **Allowed**: Child modules can import from parent's `prelude.ts`
- **Allowed**: Modules can import from their own implementation files
- **Forbidden**: Direct imports between sibling modules
- **Forbidden**: Parent modules importing from child modules

```typescript
// ✅ Child importing parent abstractions
import { AgentConfig } from '../prelude.ts';

// ❌ Sibling module imports
import { TemplateEngine } from '../../prompt/templates';

// ✅ Proper cross-module communication via parent abstractions
import { ToolRegistry } from '../prelude.ts';
```

## Consequences

- **Benefits:**
  - Modules remain loosely coupled and independently testable
  - Clear mental model for where functionality belongs
  - Prevents circular dependencies and import tangles
  - Supports incremental development without upfront design
- **Trade-offs:**
  - May require additional abstraction layers for cross-module communication
  - Developers must understand the hierarchy to place code correctly
  - Some code duplication may occur to maintain module boundaries

## Related ADRs

- **Builds on:** [ADR-0000: Architecture Decision Records](0000-architecture-decision-records.md)
- **Extended by:** [ADR-0002: File Organization](0002-file-organization.md) (builds on module structure)
- **Extended by:** [ADR-0013: Standard File Patterns](0013-standard-files.md) (implements file organization within modules)
- **See also:** [ADR-0003: Import/Export Boundaries](0003-boundaries-and-dependencies.md) (enforces module organization)

---

← [ADR-0000: Architecture Decision Records](0000-architecture-decision-records.md) | [ADR-0002: File Organization](0002-file-organization.md) →

---

## Decision Log

| Date | Status | Author | Notes |
|------|--------|--------|-------|
| 2025-06-13 | Draft | Claude | Initial module organization principles |
| 2025-06-13 | Active | Audrey | Reviewed and approved with minor edits |
