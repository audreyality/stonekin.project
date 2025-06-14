# ADR-XXXX: [Decision Title]

## Status

**Current:** [Draft | Active | Superseded | Deprecated]

## Problem

Brief description of what architectural issue we're solving and why it matters.

## Decision

Clear statement of what we've decided to do.

## Why This Approach

- Key reasons supporting this decision
- What principles or constraints drove this choice
- How it fits with existing architecture

## Implementation

Concrete guidance for developers:

```typescript
// Do this
const Status = { PENDING: 'pending', COMPLETE: 'complete' } as const;

// Not this
enum Status { PENDING = 'pending', COMPLETE = 'complete' }
```

## Consequences

- **Benefits:** What this solves or improves
- **Trade-offs:** What complexity or limitations this introduces
- **Migration:** How existing code should be updated (if applicable)

## Related ADRs

- **Builds on:** [Links to prerequisite ADRs]
- **See also:** [Related decisions]

---

## Decision Log

| Date | Status | Author | Notes |
|------|--------|--------|-------|
| YYYY-MM-DD | Draft | [Name] | Initial version |
