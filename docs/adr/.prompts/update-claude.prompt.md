# ADR Link refinement prompt flow

- This workflow asks Claude to update its metadata files from an ADR.
- For use with Claude Sonnet 4.

----

# ADR to CLAUDE.md Extraction Prompt

You are an expert technical documentation analyst. Your task is to analyze a single Architecture Decision Record (ADR) and extract specific coding guidance that would help Claude (or other AI assistants) write code that follows the established architectural decisions.

## Your Task

Transform the ADR's decisions into concrete coding instructions by extracting:

1. **Module architecture rules** - Hierarchical organization, file placement, and naming conventions
2. **Import/dependency patterns** - What can import what, and how modules should interact
3. **Type system constraints** - How types vs interfaces should be used, enum-like patterns, error types
4. **Error handling patterns** - Result/Option patterns, exception rules, and state integration
5. **Implementation patterns** - Function signatures, naming conventions, and code organization
6. **Development guidelines** - Testing requirements, performance considerations, and anti-patterns
7. **Code style mandates** - Required patterns, forbidden patterns, and preferred idioms
8. **Performance constraints** - Memory, speed, or resource limitations that affect code structure

## Input Format

You will receive a single ADR document in markdown format.

## Output Format

Transform the ADR into actionable coding guidance using this format:

```markdown
# [ADR-XXXX: Title]

## Module Architecture

### Directory Structure & File Organization

**Module Hierarchy:**
- MUST: [Required hierarchical organization patterns]
- MUST NOT: [Forbidden organizational patterns]

**File Types & Placement:**
- MUST: [Where specific file types should be placed]
- MUST NOT: [File organization anti-patterns]

**File Naming:**
- MUST: [Required naming conventions]
- MUST NOT: [Forbidden naming patterns]
- EXCEPTIONS: [Special cases when justified]

### Import Rules & Module Boundaries

**Allowed Imports:**
- ALLOWED: [Specific import patterns that are permitted]
- REQUIRED: [Mandatory import patterns]

**Forbidden Imports:**
- FORBIDDEN: [Import patterns that must be avoided]

**Cross-Module Communication:**
- PREFERRED: [Preferred communication patterns]
- REQUIRED: [Mandatory interaction patterns]

## Type System

### Types vs Interfaces

**Data Structures (use `type`):**
- REQUIRED: [When and how to use type definitions]
- AVOID: [Type usage anti-patterns]

**Behavioral Contracts (use `interface`):**
- REQUIRED: [When and how to use interface declarations]
- AVOID: [Interface usage anti-patterns]

**Import Constraints:**
- ALLOWED: [Type/interface cross-references that are permitted]
- FORBIDDEN: [Type/interface cross-references to avoid]
- PREFERRED: [Preferred type organization patterns]

### Enum-like Patterns

**Constant Object Definition:**
- REQUIRED: [How to define enum-like structures]
- CONSTRAINTS: [Type safety and serialization requirements]
- AVOID: [Enum-like anti-patterns]

### Error Type System

**Error Codes & Structure:**
- STRUCTURE: [How error types should be defined]
- CONSTRAINTS: [Error object requirements]
- NAMING: [Error naming conventions]
- EXPORTS: [Where error types should be exported]

## Error Handling

### Result & Option Patterns

**Core Patterns:**
- STRUCTURE: [Result/Option type definitions]
- REQUIRED: [Mandatory error handling patterns]

**Syntax Requirements:**
- REQUIRED: [How to handle Result/Option types]

**Anti-patterns:**
- AVOID: [Error handling patterns to avoid]

### Exception Rules

**Acceptable Exception Cases:**
- REQUIRED: [When exceptions are appropriate]
- FORBIDDEN: [When exceptions must not be used]

### State Pattern Integration
- REQUIRED: [How to integrate with state patterns]
- PREFERRED: [Preferred composition patterns]

## Implementation Patterns

### Function Signatures & Parameters

**Parameter Rules:**
- PARAMETERS: [How parameters should be structured]

**Return Types:**
- RETURNS: [Return type patterns and async handling]

### Naming Conventions

**Files & Modules:**
- NAMING: [File and module naming patterns]

**Types & Interfaces:**
- NAMING: [Type and interface naming conventions]

### Code Organization Patterns

**Module Exports:**
- EXPORTS: [How to structure module exports]

**Type Flow:**
- STRUCTURE: [How types should flow between modules]
- INTEGRATION: [Type integration patterns]

## Development Guidelines

### Testing Requirements
- MUST TEST: [What functionality requires tests]
- TEST STRUCTURE: [How tests should be organized]
- MOCKING: [Mocking patterns and dependencies]

### Performance Considerations

**Runtime Characteristics:**
- CONSTRAINTS: [Runtime performance requirements]
- REQUIREMENTS: [Performance guarantees]

**Development Optimizations:**
- CONSTRAINTS: [Development-time performance considerations]
- OPTIMIZATIONS: [Optimization patterns and techniques]

### Anti-patterns Reference
[Code examples showing incorrect patterns with explanations]
```

## Extraction Guidelines

1. **Convert decisions to rules**: Transform "we decided X" into "code MUST/MUST NOT do X"
2. **Extract specific patterns**: Pull out exact file paths, import statements, and code structures mentioned
3. **Identify enforcement points**: Note where linting rules, tests, or automation enforce the decisions  
4. **Preserve code examples**: Include implementation examples exactly as written in the ADR
5. **Flag breaking changes**: Mark any patterns that would break existing code
6. **Cross-reference dependencies**: Note when this ADR affects or builds on other ADRs
7. **Extract anti-patterns**: Capture explicit "don't do this" guidance with equal weight

## Critical Instructions

- **Extract ONLY explicit decisions**: Do not infer rules from examples or context
- **Distinguish examples from rules**: Code examples illustrate decisions, they don't create new rules
- **No pattern generalization**: Don't extrapolate patterns beyond what's explicitly documented
- **Omit empty sections**: Only include sections where the ADR provides specific guidance
- **Use imperative language**: Write "MUST use X" not "should consider using X"  
- **Be implementation-ready**: Each rule should be specific enough to write code from
- **Preserve technical terms**: Keep exact TypeScript/framework terminology from the ADR
- **Include rationale briefly**: Add one-line explanations for non-obvious rules
- **Mark scope clearly**: Specify if rules apply to all code, specific modules, or boundary interfaces only

## What NOT to Extract

- **Do not infer**: Rules from code examples unless explicitly stated
- **Do not generalize**: Patterns beyond the specific decisions documented
- **Do not assume**: Implementation details not mentioned in the ADR
- **Do not create**: New constraints based on architectural style or best practices
- **Do not extrapolate**: From single examples to broader patterns

Write your extraction results to `_SCRATCH.md`.

-----

# ADR Extraction Validator

Validate extracted `_SCRATCH.md` files to ensure they contain only explicit decisions from the source ADR, not inferred or overfitted rules.

## Task
For each rule in the extracted file, verify it can be directly traced to explicit text in the ADR. Flag any inferred content.

## Validation Test
For each rule, ask: **"Can I quote the specific ADR sentence that states this?"**
- If yes → Valid
- If no → Flag for correction

## Output Format

```markdown
# Corrections for [ADR Number]

## Rules to Remove
- **Rule**: [Exact text from _SCRATCH.md]
- **Reason**: [Inferred/Generalized/etc.]
- **Action**: Delete this rule

## Rules to Modify  
- **Current**: [Exact current text]
- **Change to**: [Corrected version with ADR quote]
- **Reason**: [Why the change is needed]

## Missing Rules
- **Add**: [Rule text based on explicit ADR content]
- **Source**: "[Direct quote from ADR]"
```

## Flag These Issues
- Rules inferred from code examples
- Patterns generalized beyond ADR scope  
- Implementation details not explicitly decided
- Best practices added without ADR basis

Write your extraction results to `_REPORT.md`.

-----

# CLAUDE.md Integration Prompt

You are an expert technical documentation maintainer. Your task is to integrate extracted ADR coding rules from `_SCRATCH.md` into the main `CLAUDE.md` file, treating the extracted results as the authoritative source of truth.

## Your Task

Read the extracted coding rules from `_SCRATCH.md` and intelligently merge them into the existing `CLAUDE.md` file by:

1. **Adding new rules** that don't exist in CLAUDE.md
2. **Updating existing rules** where _SCRATCH.md provides more specific or different guidance
3. **Resolving conflicts** by prioritizing _SCRATCH.md content over existing CLAUDE.md content
4. **Organizing content** to maintain logical flow and avoid duplication
5. **Preserving context** by keeping related rules grouped together

## Conflict Resolution Policy

**_SCRATCH.md is always correct.** When integrating:

- If _SCRATCH.md contradicts existing CLAUDE.md content → Update CLAUDE.md to match \_SCRATCH.md
- If _SCRATCH.md provides more specific guidance → Replace general guidance with specific guidance
- If _SCRATCH.md adds new constraints → Add them to existing sections or create new sections
- If rules seem to conflict → Assume the new rule supersedes or refines the old rule

## Integration Strategy

### 1. Section Mapping

Map _SCRATCH.md sections to appropriate CLAUDE.md sections:

- **Module Architecture** → Module Architecture (direct mapping)
- **Directory Structure & File Organization** → Directory Structure & File Organization
- **Import Rules & Module Boundaries** → Import Rules & Module Boundaries
- **Type System** → Type System (with subsections for Types vs Interfaces, Enum-like Patterns, Error Type System)
- **Error Handling** → Error Handling (with subsections for Result & Option Patterns, Exception Rules, State Pattern Integration)
- **Implementation Patterns** → Implementation Patterns (with subsections for Function Signatures & Parameters, Naming Conventions, Code Organization Patterns)
- **Development Guidelines** → Development Guidelines (with subsections for Testing Requirements, Performance Considerations, Anti-patterns Reference)

### 2. Content Integration Rules

- **Merge similar sections**: Combine related guidance under unified headings
- **Preserve imperative language**: Keep MUST/MUST NOT/REQUIRED format from _SCRATCH.md
- **Maintain examples**: Preserve code examples exactly as provided
- **Update cross-references**: Ensure internal links remain valid after changes

### 3. Quality Standards

- **No contradictions**: Final CLAUDE.md must not contain conflicting guidance
- **Complete coverage**: All rules from _SCRATCH.md must be represented
- **Logical flow**: Related concepts should be grouped and ordered sensibly
- **Implementation-ready**: Every rule must be specific enough to guide code writing
- **Searchable**: Use consistent terminology that coding assistants can easily find

## Output Requirements

Produce an updated `CLAUDE.md` file that:

1. **Incorporates all guidance** from _SCRATCH.md
2. **Maintains existing valuable content** that doesn't conflict with new rules
3. **Uses consistent formatting** with clear headings and bullet points
4. **Provides actionable guidance** for AI assistants writing code

## Instructions

1. **Read _SCRATCH.md completely** to understand all new rules and their context
2. **Analyze existing CLAUDE.md** to identify overlaps and conflicts
3. **Plan the integration** by mapping new content to existing sections
4. **Merge systematically** section by section, prioritizing _SCRATCH.md guidance
5. **Review for consistency** ensuring no contradictory guidance remains
6. **Validate completeness** confirming all _SCRATCH.md content is incorporated

**Important**: Assume the human has already validated that the _SCRATCH.md content is correct and ready for integration. Your job is seamless integration, not validation of the extracted rules.
