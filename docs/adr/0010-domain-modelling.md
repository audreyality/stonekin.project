# ADR-0010: Domain Modeling with Branded Types and Discriminated Unions

## Status

**Current:** Active

## Problem

Domain modeling in TypeScript often relies on primitive types (string, number) that provide no semantic meaning or type safety. A `userId` and an `agentId` are both strings at runtime, but they represent fundamentally different concepts and should not be interchangeable. Similarly, complex domain states are often modeled with inheritance hierarchies that don't leverage TypeScript's type system for compile-time guarantees.

Without strong domain modeling patterns, we get runtime errors that could be caught at compile time and reduced code clarity.

## Decision

We will use **branded types** for domain primitives and **discriminated unions** for complex state modeling. Branded types use type-fest's `Opaque` type to create compile-time distinctions between semantically different values. Discriminated unions use enum-likes as discriminants to model mutually exclusive states.

## Why This Approach

- **Compile-time safety**: Prevents mixing semantically different primitive values
- **Zero runtime cost**: Branding exists only at the type level
- **Self-documenting**: Types express domain intent explicitly
- **Exhaustive checking**: Discriminated unions enable complete pattern matching
- **JSON compatible**: Branded types serialize as their underlying primitives

## Implementation

### Branded Types for Domain Primitives

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
export const TaskStatus = {
  PENDING: 'pending',
  EXECUTING: 'executing',
  COMPLETED: 'completed'
} as const;
```

```typescript
// type.ts
export type TaskState = 
  | { status: typeof TaskStatus.PENDING; queuePosition: number }
  | { status: typeof TaskStatus.EXECUTING; progress: number }
  | { status: typeof TaskStatus.COMPLETED; result: string };
```

### Type-Safe State Handling

```typescript
// TypeScript ensures all cases are handled
function formatTask(task: TaskState): string {
  switch (task.status) {
    case TaskStatus.PENDING:
      return `Queued at position ${task.queuePosition}`;
    case TaskStatus.EXECUTING:
      return `${task.progress}% complete`;
    case TaskStatus.COMPLETED:
      return `Done: ${task.result}`;
  }
}
```

### Anti-Patterns to Avoid

```typescript
// ❌ Don't use plain primitives for domain concepts
function loadAgent(id: string): Agent { /* loses type safety */ }

// ❌ Don't use optional properties for exclusive states
type TaskState = {
  status: string;
  queuePosition?: number;    // Could exist with wrong status
  progress?: number;         // Invalid combinations possible
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
  - Requires constructor functions for branded type creation
  - More verbose type definitions than plain primitives
  - Additional dependency on type-fest

## Related ADRs

- **Builds on:** [ADR-0004: Type System Strategy](0004-type-system-strategy.md)
- **Builds on:** [ADR-0005: Enum Alternatives](0005-enum-likes.md)
- **See also:** [ADR-0006: Error Handling Strategy](0006-error-handling.md)

---

## Decision Log

| Date | Status | Author | Notes |
|------|--------|--------|-------|
| 2025-06-14 | Active | GitHub Copilot | Initial domain modeling patterns |
| 2025-06-14 | Active | Audrey | Reviewed and approved |
