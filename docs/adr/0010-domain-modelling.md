# ADR-0010: Domain Modeling with Opaque Types and Discriminated Unions

## Status

**Current:** Active

## Problem

Domain modeling in TypeScript often relies on primitive types (string, number) that provide no semantic meaning or type safety. A `userId` and an `agentId` are both strings at runtime, but they represent fundamentally different concepts and should not be interchangeable. Similarly, complex domain states are often modeled with inheritance hierarchies that don't leverage TypeScript's type system for compile-time guarantees.

Without strong domain modeling patterns, we get runtime errors that could be caught at compile time and reduced code clarity.

## Decision

We will use **opaque types** for domain primitives and **discriminated unions** for complex state modeling. Opaque types use [type-fest's `Opaque` type](https://github.com/sindresorhus/type-fest#opaque) to create compile-time distinctions between semantically different values with zero runtime cost. [Discriminated unions](https://www.typescriptlang.org/docs/handbook/2/narrowing.html#discriminated-unions) use enum-likes as discriminants to model mutually exclusive states.

## Why This Approach

- **Compile-time safety**: Prevents mixing semantically different primitive values
- **Zero runtime cost**: Opaque typing exists only at the type level
- **Self-documenting**: Types express domain intent explicitly
- **Exhaustive checking**: Discriminated unions enable complete pattern matching
- **JSON compatible**: Opaque types serialize as their underlying primitives

## Implementation

### Opaque Types for Domain Primitives

Use [opaque types](https://github.com/sindresorhus/type-fest#opaque) for domain primitives:

```typescript
// type.ts
import type { Opaque } from 'type-fest';

export type AgentId = Opaque<string, 'AgentId'>;
export type ConversationId = Opaque<string, 'ConversationId'>;

// Constructor functions for type safety
export function createAgentId(value: string): AgentId {
  return value as AgentId;
}
```

```typescript
// Usage - compile-time safety
const agentId = createAgentId('agent-123');
const conversationId = createConversationId('conv-456');

function loadAgent(id: AgentId): Agent { /* ... */ }

loadAgent(agentId);        // ✅ Type-safe
loadAgent(conversationId); // ❌ Compile error
loadAgent('agent-123');    // ❌ Compile error
```

### Discriminated Unions for State Modeling

```typescript
// data.ts
export const AgentStatus = {
  IDLE: 'idle',
  PROCESSING: 'processing', 
  COMPLETE: 'complete'
} as const;
```

```typescript
// type.ts
export type AgentState = 
  | { status: typeof AgentStatus.IDLE; lastActivity: Date }
  | { status: typeof AgentStatus.PROCESSING; requestId: string }
  | { status: typeof AgentStatus.COMPLETE; result: string };
```

### Type-Safe State Handling

```typescript
// TypeScript ensures all cases are handled
function formatAgentStatus(agent: AgentState): string {
  switch (agent.status) {
    case AgentStatus.IDLE:
      return `Idle since ${agent.lastActivity.toLocaleString()}`;
    case AgentStatus.PROCESSING:
      return `Processing request ${agent.requestId}`;
    case AgentStatus.COMPLETE:
      return `Completed: ${agent.result}`;
  }
}
```

### Anti-Patterns to Avoid

```typescript
// ❌ Don't use plain primitives for domain concepts
function loadAgent(id: string): Agent { /* loses type safety */ }

// ❌ Don't use optional properties for exclusive states
type AgentState = {
  status: string;
  lastActivity?: Date;       // Could exist with wrong status
  requestId?: string;        // Invalid combinations possible
  result?: string;
};
```

## Consequences

- **Benefits:**
  - Compile-time prevention of primitive value mixing
  - Exhaustive state handling with TypeScript's type checking
  - Self-documenting domain model through expressive types
  - Zero runtime overhead for type safety

- **Trade-offs:**
  - Requires constructor functions for opaque type creation
  - More verbose type definitions than plain primitives
  - Additional dependency on type-fest

## Related ADRs

- **Builds on:** [ADR-0004: Type System Strategy](0004-type-strategy.md)
- **Builds on:** [ADR-0005: Enum Alternatives](0005-enum-likes.md)
- **Builds on:** [ADR-0007: Functional Programming Style](0007-functional-style.md) (immutable data structures complement opaque types)
- **See also:** [ADR-0006: Error Handling Strategy](0006-error-handling.md) (opaque types enable type-safe error categories)
- **See also:** [ADR-0007: Functional Programming Style](0007-functional-style.md) (domain objects align with functional principles)
- **See also:** [ADR-0008: Domain-Driven Approaches](0008-domain-driven-design.md) (opaque types support rich domain modeling)
- **Extended by:** [ADR-0011: Naming Conventions and Domain Language](0011-naming-conventions.md) (opaque type naming patterns)

---

← [ADR-0009: Dependency Management and Injection](0009-dependency-inversion.md) | [ADR-0011: Naming Conventions and Domain Language](0011-naming-conventions.md) →

---

## Decision Log

| Date | Status | Author | Notes |
|------|--------|--------|-------|
| 2025-06-14 | Active | GitHub Copilot | Initial domain modeling patterns |
| 2025-06-14 | Active | Audrey | Reviewed and approved |
| 2025-06-18 | Active | Claude | Amended to use opaque types |
