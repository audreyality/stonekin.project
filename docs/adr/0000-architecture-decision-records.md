# ADR-0000: Architecture Decision Records for Stonekin SDK

## Status

**Current:** Active

<span style="background-color:#0969DA; color:white; padding:2px 4px; border-radius:4px;">Your Text Here</span>

## Problem

The Stonekin SDK needs a consistent way to document architectural decisions and coding standards. Without a structured approach, important decisions get lost in chat histories, buried in code comments, or exist only in tribal knowledge. This makes it difficult for new contributors to understand the reasoning behind architectural choices and harder for LLMs to maintain consistency with established patterns.

## Decision

We will use Architecture Decision Records (ADRs) to document all significant architectural decisions, coding standards, and design patterns for the Stonekin SDK. ADRs will be stored in `docs/adr/` and follow a standardized template that balances comprehensiveness with practicality. ADRs will be written in GitHub flavored markdown.

ADRs will use a lightweight status tracking mechanism with four defined states:

- **Draft**: ADR is being written and is not yet ready for implementation or enforcement
- **Active**: ADR represents the current architectural standards for the codebase
- **Superseded**: ADR has been replaced by a newer ADR and should no longer be followed (must include reference to replacement)
- **Deprecated**: ADR is no longer recommended but has not been replaced by a specific alternative

## Why This Approach

- **Preserves context**: Captures not just what we decided, but why we decided it
- **Supports both audiences**: Provides examples for LLMs and explanations for humans
- **Enables incremental adoption**: Decisions can be documented as they're made rather than requiring upfront specification
- **Maintains history**: Decision log tracks evolution of architectural thinking
- **Enforces consistency**: Clear implementation guidance reduces ambiguity

## Implementation

ADRs will be numbered sequentially and stored in `docs/adr/`:

```text
docs/adr/
├── 0000-architecture-decision-records.md
├── 0001-module-organization.md
├── 0002-file-naming-conventions.md
└── ...
```

Each ADR follows this template structure:

- **Status tracking** with clear progression
- **Problem statement** explaining what needs to be decided
- **Decision** with clear implementation guidance
- **Code examples** showing concrete patterns to follow/avoid
- **Consequences** covering benefits and trade-offs
- **Decision log** tracking changes over time

```typescript
// ADRs will include concrete examples like this:
const Status = { PENDING: 'pending', COMPLETE: 'complete' } as const;
type StatusType = typeof Status[keyof typeof Status];

// Instead of:
enum Status { PENDING = 'pending', COMPLETE = 'complete' }
```

## Consequences

- **Benefits:**
  - Architectural decisions are preserved and searchable
  - New contributors can understand the reasoning behind patterns
  - LLMs have clear, consistent guidance with examples
  - Reduces repeated discussions about settled architectural questions
- **Trade-offs:**
  - Requires discipline to document decisions as they're made
  - Additional maintenance overhead for keeping ADRs current
  - May slow initial decision-making while documenting rationale

## Related ADRs

- **Builds on:** None (foundational ADR)
- **See also:** This ADR establishes the pattern for all subsequent architectural decisions

> [!TIP]
> This section is optional.

---

## Decision Log

| Date | Status | Author | Notes |
|------|--------|--------|-------|
| 2025-06-13 | Draft | Claude | Initial template and process definition |
| 2025-06-13 | Active | Audrey | Reviewed and edited before commit |
