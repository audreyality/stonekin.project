# ADR-0015: Structure Context as Guided Discovery

## Status

**Current:** Active

## Problem

A feedback loop emerges from the interaction between [Claude Code's](https://docs.anthropic.com/en/docs/claude-code) automatic context loading and the LLM's (["lost in the middle" attention bias](https://arxiv.org/abs/2406.16008)). The system automatically loads [CLAUDE.md files](https://docs.anthropic.com/en/docs/claude-code/memory) hierarchically, memory files contextually, and tool definitions globally. As operators attempt to ensure critical instructions remain accessible, they add more content to CLAUDE.md files. This defensive response triggers a [positive feedback loop](https://en.wikipedia.org/wiki/Positive_feedback): more content pushes important information into the attention "dead zone," prompting even more defensive content additions, causing CLAUDE.md files to swell beyond sustainable limits.

The problem fractalizes when agents invoke sub-agents through tasks - each task creates a fresh context window that reloads the entire CLAUDE.md hierarchy, creating nested instances of the same feedback loop. A single conversation might spawn multiple task sub-flows, each suffering from the same attention dynamics, making instruction accessibility exponentially more unpredictable.

The project's current memory systems operate solely within this feedback loop:

1. **CLAUDE.md Files**: Automatically loaded with high precedence, currently ~1000 lines across root and code directories
2. **Memory Files (`filename.memory`)**: Contextually loaded when working with associated files, adding unpredictable context flooding

## Decision

We will break the feedback loop by transforming CLAUDE.md files from exhaustive instruction sets into [guided discovery](https://startmontessori.com/glossary/guided-discovery/) workflows that serve as navigation menus for in-repository actions and knowledge:

1. **Restructure CLAUDE.md files as workflow guides and action menus** - Transform verbose instructions into decision trees and navigation aids
2. **Domain driven workflow** - local CLAUDE.md should be domain-specific
3. **Preserve memory files with clear instructions on when to access them** - Keep institutional knowledge intact but accessible on-demand
4. **Add CLAUDE.md files to documentation folders** - Enable indexing workflows for work item logs and ADRs
5. **Transform the context competition problem into a guided discovery solution** - Use high-precedence files as navigation rather than exhaustive documentation

### CLAUDE.md File Functions

CLAUDE.md files will function as:
- **Essential instructions** that must always be followed
- **Decision trees** for when to consult memory files, ADRs, and other artifacts
- **Workflow guides** that direct appropriate actions based on context
- **Navigation menus** for accessing repository knowledge and tools

## Why This Approach

- **Breaks the feedback loop**: Eliminates defensive context flooding that triggers attention bias
- **Leverages existing infrastructure**: Uses repository structure rather than building external systems
- **Transforms context competition into guided discovery**: High-precedence files become navigation aids
- **Preserves institutional knowledge**: Memory files and documentation remain accessible through guided workflows
- **Solves recursive context problems**: Discovery guides remain accessible across all task nesting levels

## Implementation

### Phase 1: Audit and Analysis

1. Audit existing CLAUDE.md files to identify workflow patterns and decision points
2. Categorize current content into:
   - Essential always-needed instructions
   - Workflow guidance and decision trees
   - Reference material that can be accessed on-demand

### Phase 2: Create Navigation Structures

Create navigation structures for accessing:
- Memory files (with guidance on when each is relevant)
- ADR documentation (with indexing workflows)
- Work item logs (with search and retrieval patterns)
- External tools and processes

### Phase 3: Restructure CLAUDE.md Files

1. Transform root CLAUDE.md into project navigation menu
2. Convert code/CLAUDE.md into programming workflow guide
3. Add CLAUDE.md files to `docs/adr/` for ADR indexing
4. Add CLAUDE.md files to work directories for work item navigation

### Phase 4: Establish Patterns

Establish consistent navigation patterns across all CLAUDE.md files to ensure predictable discovery paths.

> [!TIP]
> Patterns embedded in CLAUDE.md files may make good candidates for agents and/or facilities within the SDK!

### Transformation Examples

#### Scope Overview

```markdown
# Current State: 1000+ lines of exhaustive instructions (triggering feedback loop)
code/CLAUDE.md:     ~600 lines (detailed programming rules)
root CLAUDE.md:     ~400 lines (comprehensive project guidelines)

# Target State: Navigation and workflow guides (breaking feedback loop)
code/CLAUDE.md:     ~100 lines (workflow guide for programming tasks)
root CLAUDE.md:     ~50 lines (project navigation menu)
docs/adr/CLAUDE.md: ~30 lines (ADR indexing and search workflow)
```

#### Example: code/CLAUDE.md Transformation

```markdown
# Before (600 lines triggering attention bias feedback loop)
[Exhaustive TypeScript patterns, error handling, domain modeling, etc...]

# After (workflow guide breaking the feedback loop)
## Programming Workflow
0. **The Golden Rule**: Check basic-memory before reading files!
1. **Starting new module**: Check ADR-0001 for organization patterns
2. **TypeScript patterns**: Review .ts.memory files in relevant directories
3. **Error handling**: See ADR-0006 for established patterns
4. **Domain modeling**: Consult ADR-0010 and related memory files

## Critical Rules (Always Apply)
- No Prettier formatting
- Use functional style with immutable data

## When to Consult Memory Files
- `.ts.memory`: File-specific implementation patterns
- `.json.memory`: Configuration rationale and common operations
- `.md.memory`: Do not create.
```

#### Example: New docs/adr/CLAUDE.md

```markdown
# ADR Navigation and Indexing

## Finding Relevant ADRs
1. **By topic**: Use grep with domain terms
2. **By dependency**: Check "Related ADRs" sections
3. **By chronology**: Review index.md for decision timeline

## Creating New ADRs
1. Use template in `.templates/adr.md`
2. Follow ADR-0000 standards
3. Update index.md with cross-references
4. Double-check all references and links
```

## Consequences

- **Benefits:**
  - Increases discoverability of existing knowledge
  - Consistent behavior across main conversation and task sub-flows
  - Leverages repository structure as knowledge organization system
  - Reduces unpredictable attention bias effects

- **Trade-offs:**
  - Requires careful workflow design to minimize conflicts
  - Navigation adds steps to access detailed information
  - Initial restructuring effort across multiple CLAUDE.md files
  - Need to maintain navigation accuracy as repository evolves

- **Migration:**
  - Incremental transformation possible
  - Start with highest-impact files

## Related ADRs

- **Builds on:** [ADR-0000: Architecture Decision Records](0000-architecture-decision-records.md) (documentation patterns)
- **See also:** [ADR-0008: Domain-Driven Design](0008-domain-driven-design.md) (context boundaries)

← [ADR-0014: RxJS Stream Primitive](0014-rxjs-stream-primitive.md) 

---

## Decision Log

| Date | Status | Author | Notes |
|------|--------|--------|-------|
| 2025-07-19 | Draft | Claude/Audrey | Initial documentation of guided discovery approach |
| 2025-07-19 | Active | Audrey | Refined and approved |
