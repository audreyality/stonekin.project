# ADR Link refinement prompt flow

- This workflow asks Claude to update its metadata files.
- For use with Claude Sonnet 4.

----

# ADR to CLAUDE.md Extraction Prompt

You are an expert technical documentation analyst. Your task is to analyze a single Architecture Decision Record (ADR) and extract specific coding guidance that would help Claude (or other AI assistants) write code that follows the established architectural decisions.

## Your Task

Transform the ADR's decisions into concrete coding instructions by extracting:

1. **File/folder structure rules** - Where code should go and how modules should be organized
2. **Import/dependency patterns** - What can import what, and how modules should interact
3. **Code style mandates** - Required patterns, forbidden patterns, and preferred idioms
4. **Type annotations** - How types should be defined, used, and constrained
5. **Function signatures** - Expected patterns for parameters, returns, and error handling
6. **Naming patterns** - Specific conventions for files, functions, variables, and types
7. **Testing requirements** - What must be tested and how tests should be structured
8. **Performance constraints** - Memory, speed, or resource limitations that affect code structure

## Input Format

You will receive a single ADR document in markdown format.

## Output Format

Transform the ADR into actionable coding guidance using this format:

```markdown
# [ADR-XXXX: Title]

## Directory Structure
- MUST: [Required folder/file organization patterns]
- MUST NOT: [Forbidden organizational patterns]

## Import Rules  
- ALLOWED: [Specific import patterns that are permitted]
- FORBIDDEN: [Import patterns that must be avoided]
- PREFERRED: [Import patterns that should be used when possible]

## Code Patterns
- REQUIRED: [Mandatory coding patterns and idioms]
- AVOID: [Patterns to avoid or replace]
- EXAMPLE: [Concrete code examples showing the correct approach]

## Function Signatures
- PARAMETERS: [How parameters should be structured]
- RETURNS: [Return type patterns and error handling]
- NAMING: [Function naming conventions]

## Type Definitions
- STRUCTURE: [How types should be defined and organized]
- CONSTRAINTS: [Type safety requirements and patterns]
- EXPORTS: [How types should be exposed between modules]

## Testing Requirements
- MUST TEST: [What functionality requires tests]
- TEST STRUCTURE: [How tests should be organized]
- MOCKING: [Mocking patterns and dependencies]

## Performance Rules
- CONSTRAINTS: [Memory, speed, or resource limitations]
- OPTIMIZATIONS: [Required performance patterns]
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

- **Omit empty sections**: Only include sections where the ADR provides specific guidance
- **Use imperative language**: Write "MUST use X" not "should consider using X"  
- **Be implementation-ready**: Each rule should be specific enough to write code from
- **Preserve technical terms**: Keep exact TypeScript/framework terminology from the ADR
- **Include rationale briefly**: Add one-line explanations for non-obvious rules
- **Mark scope clearly**: Specify if rules apply to all code, specific modules, or boundary interfaces only

Write your extraction results to `_SCRATCH.md`.

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

- **Directory Structure** → File Organization / Project Structure
- **Import Rules** → Dependencies / Module Boundaries  
- **Code Patterns** → Coding Standards / Implementation Patterns
- **Function Signatures** → Function Design / API Patterns
- **Type Definitions** → Type System / TypeScript Usage
- **Testing Requirements** → Testing Strategy / Test Organization
- **Performance Rules** → Performance Guidelines / Constraints

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
5. **Includes the ADR reference** noting which ADRs contributed to each section

## Instructions

1. **Read _SCRATCH.md completely** to understand all new rules and their context
2. **Analyze existing CLAUDE.md** to identify overlaps and conflicts
3. **Plan the integration** by mapping new content to existing sections
4. **Merge systematically** section by section, prioritizing _SCRATCH.md guidance
5. **Review for consistency** ensuring no contradictory guidance remains
6. **Validate completeness** confirming all _SCRATCH.md content is incorporated

**Important**: Assume the human has already validated that the _SCRATCH.md content is correct and ready for integration. Your job is seamless integration, not validation of the extracted rules.
