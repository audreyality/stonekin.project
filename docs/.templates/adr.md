# ADR-XXXX: [Title: Brief Descriptive Name]

> **Template Notes:**
>
> - Replace XXXX with the next sequential ADR number
> - Title should be concise and descriptive (e.g., "Standard File Patterns and Purposes")
> - Use sentence case for the title

## Status

**Current:** [Draft | Active | Superseded | Deprecated]

> **Template Notes:**
>
> - Draft: Initial proposal under review
> - Active: Currently in use and enforced
> - Superseded: Replaced by newer ADR (include reference)
> - Deprecated: No longer recommended but may still exist in codebase

## Problem

> **Content Checklist:**
>
> - [ ] Clearly state the problem this ADR addresses
> - [ ] Explain why the current state is insufficient
> - [ ] Describe specific pain points or challenges
> - [ ] Reference related ADRs if this builds on previous decisions
> - [ ] Include concrete examples of the problem when helpful

[Describe the architectural challenge, constraint, or requirement that necessitates a decision. Focus on the problem space rather than jumping to solutions. Include specific examples of pain points and explain why the status quo is insufficient.]

**Example problem statement pattern:**

```
Without clear [X], developers [experience Y pain], leading to [Z negative outcomes]. 
This makes it difficult for [stakeholders] to [accomplish goals] and [understand/maintain/extend] [system aspects].
```

## Decision

> **Content Checklist:**
>
> - [ ] State the decision clearly and concisely
> - [ ] Include key principles or constraints that guide the decision
> - [ ] Provide specific implementation details or patterns
> - [ ] Reference external standards or best practices when applicable
> - [ ] Include subsections for different aspects of the decision

[State the architectural decision clearly. Include the key principles, constraints, or patterns that will be followed. Break complex decisions into subsections with clear headings.]

### [Subsection 1: Core Principles/Patterns]

> **Template Notes:**
>
> - Use subsections to organize complex decisions
> - Include bullet points for key principles
> - Reference external documentation when applicable

**Key principles:**

- **[Principle 1]**: [Brief explanation]
- **[Principle 2]**: [Brief explanation]
- **[Principle 3]**: [Brief explanation]

### [Subsection 2: Specific Guidelines/Patterns]

[Include specific implementation patterns, coding standards, or architectural constraints]

## Why This Approach

> **Content Checklist:**
>
> - [ ] Explain the reasoning behind the decision
> - [ ] Connect benefits to the original problem
> - [ ] Address why alternatives were not chosen
> - [ ] Include domain-specific benefits when applicable
> - [ ] Keep benefits concrete and measurable when possible

[Explain the reasoning behind the decision. Focus on how this approach solves the stated problem and why it's superior to alternatives. Use bullet points for clarity.]

**Benefits:**

- **[Benefit category]**: [Specific benefit and impact]
- **[Benefit category]**: [Specific benefit and impact]
- **[Benefit category]**: [Specific benefit and impact]

## Implementation

> **Content Checklist:**
>
> - [ ] Provide concrete implementation guidance
> - [ ] Include code examples following project standards
> - [ ] Show both positive and negative examples
> - [ ] Include step-by-step guidance when appropriate
> - [ ] Reference related ADRs that inform implementation

[Provide specific implementation guidance with concrete examples. This section should be actionable and include both what to do and what not to do.]

### [Implementation Pattern 1]

[Description of the pattern or approach]

```typescript
// ✅ Good example following the decision
export function createAgent(config: AgentConfig): Agent {
  // Implementation following the patterns
}

// ❌ Anti-pattern to avoid
export class AgentManager {
  // Implementation that violates the decision
}
```

### [Implementation Pattern 2]

[Additional patterns or examples]

```typescript
// Example with domain-specific context
import type { AgentCapability } from './type.ts';
import { DEFAULT_CONFIG } from './data.ts';

export function validateConfiguration(config: AgentConfig): boolean {
  // Implementation showing the pattern in practice
}
```

### Guidelines and Best Practices

> **Template Notes:**
>
> - Include specific do's and don'ts
> - Reference external documentation when helpful
> - Provide migration guidance if applicable

- **[Guideline category]**: [Specific guidance]
- **[Guideline category]**: [Specific guidance]
- **[Guideline category]**: [Specific guidance]

### Anti-Patterns to Avoid

```typescript
// ❌ Anti-pattern 1: [Description]
// [Code example showing what not to do]

// ❌ Anti-pattern 2: [Description] 
// [Code example showing what not to do]
```

## Consequences

> **Content Checklist:**
>
> - [ ] Honestly assess both benefits and trade-offs
> - [ ] Include migration considerations for existing code
> - [ ] Address potential risks or challenges
> - [ ] Consider long-term maintenance implications
> - [ ] Include timeline or adoption strategies

[Provide a balanced assessment of the decision's impact, including both positive and negative consequences.]

- **Benefits:**
  - [Specific benefit and its impact]
  - [Specific benefit and its impact]
  - [Specific benefit and its impact]

- **Trade-offs:**
  - [Honest assessment of costs or limitations]
  - [Honest assessment of costs or limitations]
  - [Honest assessment of costs or limitations]

- **Migration:**
  - [Guidance for adopting this decision in existing code]
  - [Timeline or prioritization suggestions]
  - [Tools or processes to support migration]

## Related ADRs

> **Content Checklist:**
>
> - [ ] Link to ADRs this decision builds upon
> - [ ] Link to ADRs this decision implements or supports
> - [ ] Note ADRs that might conflict or need updates
> - [ ] Include forward references to planned ADRs
> - [ ] Use consistent relationship language

> **Template Notes:**
>
> - Use consistent relationship terms: "Builds on", "Implements", "Supports", "Conflicts with", "See also"
> - Include brief descriptions in parentheses for clarity
> - Link to actual ADR files using relative paths

- **Builds on:** [ADR-XXXX: Title](XXXX-filename.md) (brief description of relationship)
- **Implements:** [ADR-XXXX: Title](XXXX-filename.md) (brief description of relationship)
- **Supports:** [ADR-XXXX: Title](XXXX-filename.md) (brief description of relationship)
- **Supercedes:** [ADR-XXXX: Title](XXXX-filename.md) (brief description of conflict)
- **See also:** [ADR-XXXX: Title](XXXX-filename.md) (brief description of relationship)

← [Previous ADR](XXXX-filename.md) | [Next ADR](XXXX-filename.md) →

---

## Decision Log

> **Template Notes:**
>
> - Include all significant changes to the ADR
> - Use ISO date format (YYYY-MM-DD)
> - Include author and brief description of changes
> - Latest entry should be at the bottom

| Date | Status | Author | Notes |
|------|--------|--------|-------|
| YYYY-MM-DD | Draft | [Author Name] | Initial draft |
| YYYY-MM-DD | Active | [Reviewer Name] | Reviewed and approved |

---

## ADR Template Checklist

> **Remove this section before finalizing ADR**

**Before submitting:**

- [ ] ADR number is correct and sequential
- [ ] Title is descriptive and follows naming conventions
- [ ] Problem section clearly explains the challenge
- [ ] Decision section provides actionable guidance
- [ ] Implementation includes concrete code examples
- [ ] Examples follow project coding standards and domain language
- [ ] Related ADRs are correctly linked
- [ ] Decision log includes initial entry
- [ ] All placeholder text has been replaced
- [ ] Template notes and checklist sections are removed
