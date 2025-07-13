# Documentation Pattern Analysis

## Current State Assessment

### Existing Documentation Patterns

**_DOMAIN.md Files Found:**
- `/Users/audreyality/Code/stonekin.project/_DOMAIN.md` (root configuration)
- `/Users/audreyality/Code/stonekin.project/docs/adr/_DOMAIN.md` (architecture decisions)
- `/Users/audreyality/Code/stonekin.project/code/core/src/_DOMAIN.md` (core module)
- `/Users/audreyality/Code/stonekin.project/.devcontainer/_DOMAIN.md` (container architecture)

**Memory Files Found:**
- `.markdownlint.json.memory` (configuration rationale)

**Work Directory Files Present:**
- `_REMEMBER.md` (long-term memory)
- `_RESEARCH.md` (this file)
- `_REPORT.md` (previous work outcomes)

### Directory-Specific Guidelines

**Root CLAUDE.md:**
- Project-wide practices and tooling
- Work directory usage guidelines
- Memory files pattern
- Git workflow and DevContainer setup
- Sequential thinking tool usage

**Code CLAUDE.md:**
- Comprehensive coding standards
- Module organization patterns
- Type system requirements
- Error handling strategies
- Documentation strategy (TSDoc, README.md, _DOMAIN.md)

### Special-Purpose Directories

**`/code` Directory:**
- Has own domain standards in `code/CLAUDE.md`
- Contains strict coding conventions
- Module hierarchy requirements
- Independent documentation patterns

**`/memory` Directory:**
- Exclusively managed by Basic Memory tool
- No manual editing allowed
- Contains non-source-controlled information

## Pattern Analysis

### Universal Patterns (Apply Everywhere)

1. **Memory Files (`filename.memory`)**
   - Currently used: `.markdownlint.json.memory`
   - Should be expanded throughout repository
   - For configuration context and decisions

2. **Work Directory (`.work/`)**
   - Research, reports, session tracking
   - Cross-project continuity
   - Analysis and decision documentation

### Root-Level Patterns (Exclude /code and /memory)

1. **_DOMAIN.md Pattern**
   - Already used in multiple locations
   - For complex subsystem documentation
   - Problem domain, constraints, solutions

2. **README.md Guidelines**
   - Context-appropriate documentation
   - User-facing information

3. **General Documentation Principles**
   - Domain language usage
   - Clear decision capture

### Domain-Specific Patterns

1. **Code Directory**
   - TSDoc requirements
   - Module-specific files (index.ts, prelude.ts)
   - Strict naming conventions
   - Type system rules

2. **Memory Directory**
   - Tool-managed only
   - No manual intervention

## Gaps and Overlaps

### Current Overlaps

- _DOMAIN.md pattern mentioned in code/CLAUDE.md but used project-wide
- General documentation principles could be extracted from code-specific rules

### Missing Documentation

- No comprehensive work directory guide
- Memory systems distinction unclear
- Operator relationship not documented
- Pattern scope boundaries not explicit

## Recommendations

### Promote to Root Level

1. **_DOMAIN.md pattern** - Already used across multiple directories
2. **Memory files pattern** - Expand to universal usage
3. **Work directory system** - Comprehensive file type documentation

### Keep Domain-Specific

1. **Code standards** - Remain in code/CLAUDE.md
2. **Memory tool usage** - Basic Memory tool manages /memory

### Clarify Boundaries

1. **Explicit scope statements** needed in root CLAUDE.md
2. **Cross-references** between root and code guidelines
3. **Memory system distinction** between files and tool
