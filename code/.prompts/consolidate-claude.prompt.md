# CLAUDE consolidation Prompt

- This workflow increases the information density of CLAUDE.md.
- For use with Claude Sonnet 4.

> [!TIP]
> Use a second LLM to confirm consistency between the files.
> "Please compare CLAUDE.md to CLAUDE-CONSOLIDATED.md. Confirm that CLAUDE-CONSOLIDATED.md is consistent with CLAUDE.md."

----


# Prompt: Review and Consolidate CLAUDE.md Coding Rules

Please review the `CLAUDE.md` file and consolidate its content while preserving all essential meaning and requirements. Focus on improving organization, reducing redundancy, and enhancing clarity. Write your results to `CLAUDE-CONSOLIDATED.md`.

## Consolidation Goals

### 1. **Structural Organization**
- Group related concepts together logically
- Eliminate redundant rules that appear in multiple sections
- Create clear hierarchical relationships between concepts
- Ensure consistent terminology throughout

### 2. **Content Analysis Areas**

#### **Error Handling Consolidation**
- Merge Result/Option pattern rules with error type definitions
- Consolidate exception rules with error handling patterns
- Integrate state pattern examples with error handling
- Remove duplicate Result/Option syntax explanations

#### **Type System Unification**
- Combine type vs interface rules with file organization patterns
- Merge enum-like pattern definitions scattered across sections
- Consolidate opaque type usage with general type strategy
- Unify import rules for types with general import constraints

#### **Module Architecture Consolidation**
- Merge directory structure rules with import rules
- Combine file naming conventions with code patterns
- Integrate function signature rules with type definitions
- Consolidate prelude.ts patterns with module boundaries

### 3. **Redundancy Elimination**

Look for and merge these duplicate concepts:
- **Enum-like patterns** (appears in Type System, Code Patterns, Type Definitions)
- **Import restrictions** (scattered across Import Rules, Code Patterns, Function Signatures)
- **File organization** (repeated in Directory Structure, File Naming, Code Patterns)
- **Error handling syntax** (duplicated in Error Handling and Function Signatures)
- **Readonly constraints** (appears in multiple type-related sections)

### 4. **Clarity Improvements**

#### **Examples Consolidation**
- Create comprehensive examples that demonstrate multiple concepts
- Remove redundant code samples that show the same patterns
- Ensure examples are consistent in style and naming
- Add missing examples for under-illustrated concepts

#### **Rule Categorization**
- Clearly distinguish REQUIRED vs PREFERRED vs FORBIDDEN rules
- Ensure consistent use of constraint language (MUST, MUST NOT, SHOULD, etc.)
- Group related constraints under unified principles
- Remove contradictory or ambiguous statements

### 5. **Reorganization Strategy**

Suggest a new structure that:
- **Groups by conceptual domain** rather than implementation detail
- **Flows logically** from high-level architecture to specific syntax
- **Minimizes cross-references** between sections
- **Enables selective reading** of relevant sections

### 6. **Preservation Requirements**

**CRITICAL: Do not lose any of these essential elements:**
- All REQUIRED/MUST/FORBIDDEN constraints
- Specific syntax patterns for Result/Option types
- Import boundary restrictions
- File naming conventions
- Error handling patterns
- Type vs interface distinctions
- Module hierarchy rules
- Performance considerations
- Testing requirements

### 7. **Output Format**

Provide:
1. **Analysis summary** of redundancies found
2. **Proposed new structure** with section organization
3. **Consolidated content** maintaining all rules but improving organization
4. **Change justification** for any structural modifications

## Success Criteria

The consolidated file should:
- Be 20-30% shorter while preserving all meaning
- Have clear, non-overlapping sections
- Flow logically from architecture to implementation
- Eliminate all redundant explanations
- Maintain all technical requirements
- Improve overall readability and reference value

Please proceed with the analysis and consolidation, ensuring that every rule and constraint from the original is preserved in the reorganized version.
