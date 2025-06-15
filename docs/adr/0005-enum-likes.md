# ADR-0005: Enum Alternatives and Constant Objects (Enum-likes)

## Status

**Current:** Active

## Problem

TypeScript enums create unnecessary runtime overhead and introduce type system complications that conflict with our functional programming principles. Enums generate JavaScript objects at runtime even when only compile-time type checking is needed, and they don't play well with JSON serialization or our preference for immutable data patterns. Additionally, enum values can be accessed in ways that bypass type safety, leading to potential runtime errors.

Without a clear alternative pattern, developers might reach for enums out of habit or use inconsistent approaches for modeling sets of known values, creating maintenance burden and architectural inconsistency.

## Decision

We will **never use TypeScript enums**. Instead, we use **"enum-likes"** - constant objects with [`as const` assertions](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-3-4.html#const-assertions) that provide the same developer experience as enums but with better type safety, no runtime overhead, and perfect JSON compatibility.

Enum-likes follow this pattern:

```typescript
const StatusName = { KEY: 'value', ANOTHER: 'another' } as const;
type StatusNameType = typeof StatusName[keyof typeof StatusName];
```

## Why This Approach

- **Zero runtime overhead**: [`as const` objects](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#literal-types) are purely compile-time constructs
- **Perfect JSON compatibility**: Values serialize naturally without transformation
- **Better type safety**: Impossible to access undefined enum members
- **Immutable by design**: `as const` prevents accidental mutation
- **Tree-shakable**: Unused values can be eliminated by [bundlers](https://webpack.js.org/guides/tree-shaking/)
- **Functional alignment**: Works naturally with our discriminated union patterns
- **Predictable behavior**: No surprising enum edge cases or reverse mappings

## Implementation

### Basic Enum-like Pattern

```typescript
// ✅ Enum-like for status values
const AgentStatus = {
  IDLE: 'idle',
  PROCESSING: 'processing',
  COMPLETE: 'complete',
  FAILED: 'failed'
} as const;

type AgentStatusType = typeof AgentStatus[keyof typeof AgentStatus];
// Expands to: 'idle' | 'processing' | 'complete' | 'failed'

// Usage
function updateAgentStatus(status: AgentStatusType) {
  // Type-safe access to values
  console.log(`Agent status changed to: ${status}`);
}

updateAgentStatus(AgentStatus.IDLE);    // ✅ Type-safe
updateAgentStatus('idle');              // ✅ Also Type-safe!
updateAgentStatus('invalid');           // ❌ Compile error
```

### Numeric Enum-likes

When you need numeric constants:

```typescript
// ✅ Numeric enum-like
const ToolPriority = {
  LOW: 1,
  MEDIUM: 5,
  HIGH: 10,
  CRITICAL: 20
} as const;

type ToolPriorityType = typeof ToolPriority[keyof typeof ToolPriority];
// Expands to: 1 | 5 | 10 | 20

// Usage with type guards
function isToolPriorityValue(value: unknown): value is ToolPriorityType {
  return Object.values(ToolPriority).includes(value as ToolPriorityType);
}
```

### File Organization

Following our module patterns, enum-likes belong in `data.ts`:

```typescript
// data.ts - constant objects and configurations
export const AgentModel = {
  GPT_4: 'gpt-4',
  GPT_4_TURBO: 'gpt-4-turbo',
  CLAUDE_3_OPUS: 'claude-3-opus',
  CLAUDE_3_SONNET: 'claude-3-sonnet'
} as const;

export const LogLevel = {
  DEBUG: 'debug',
  INFO: 'info',
  WARN: 'warn',
  ERROR: 'error'
} as const;

// No external dependencies - pure data definitions
```

```typescript
// type.ts - type definitions using the enum-likes
import { AgentModel, LogLevel } from './data.ts';

export type AgentModelType = typeof AgentModel[keyof typeof AgentModel];
export type LogLevelType = typeof LogLevel[keyof typeof LogLevel];

export type AgentConfig = {
  readonly model: AgentModelType;
  readonly temperature: number;
  readonly maxTokens: number;
};

export type LogEntry = {
  readonly level: LogLevelType;
  readonly message: string;
  readonly timestamp: Date;
};
```

### Integration with Discriminated Unions

Enum-likes work perfectly with our [discriminated union patterns](https://www.typescriptlang.org/docs/handbook/2/narrowing.html#discriminated-unions):

```typescript
// data.ts
export const AgentStatus = {
  IDLE: 'idle',
  PROCESSING: 'processing',
  COMPLETE: 'complete',
  FAILED: 'failed'
} as const;

// type.ts
export type AgentState = 
  | { readonly status: typeof AgentStatus.IDLE; readonly lastActivity: Date }
  | { readonly status: typeof AgentStatus.PROCESSING; readonly progress: number }
  | { readonly status: typeof AgentStatus.COMPLETE; readonly result: string }
  | { readonly status: typeof AgentStatus.FAILED; readonly error: string };

// Perfect type narrowing
function handleAgentState(state: AgentState) {
  switch (state.status) {
    case AgentStatus.IDLE:
      console.log(`Last active: ${state.lastActivity}`);
      break;
    case AgentStatus.PROCESSING:
      console.log(`Progress: ${state.progress}%`);
      break;
    // ...
  }
}
```

### Anti-Patterns to Avoid

```typescript
// ❌ Never use TypeScript enums
enum Status {
  PENDING = 'pending',
  COMPLETE = 'complete'
}

// ❌ Don't use plain objects without `as const`
const Status = {
  PENDING: 'pending',
  COMPLETE: 'complete'
}; // TypeScript infers string type, loses literal types

// ❌ Don't use const assertions on individual values
const PENDING = 'pending' as const;
const COMPLETE = 'complete' as const;
// Scattered constants are harder to maintain and discover

// ❌ Don't mix enum-likes with different value types inconsistently
const MixedValues = {
  ACTIVE: true,
  INACTIVE: 'inactive',  // Inconsistent types make unions less useful
  PENDING: 1
} as const;
```

### Utility Functions

Helper functions are available in `@stonekin/ts` for common enum-like operations:

```typescript
import { getEnumValues, isEnumValue } from '@stonekin/ts-util';

const validStatuses = getEnumValues(ProcessingStatus);
const isValidStatus = isEnumValue(ProcessingStatus, userInput);
```

*Note: [`Object.values()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/values) can also be used directly for extracting enum-like values when utility functions aren't available.*

## Consequences

- **Benefits:**
  - Zero runtime overhead compared to TypeScript enums
  - Perfect [JSON serialization](https://www.json.org/) without transformation
  - Better type safety and predictable behavior
  - Natural integration with functional patterns
  - Clear, discoverable constant definitions

- **Trade-offs:**
  - Slightly more verbose than enum declarations
  - Requires understanding of `as const` behavior
  - Type definitions are more complex than simple enum types

## Related ADRs

- **Builds on:** [ADR-0004: Type System Strategy](0004-type-strategy.md) (enum-likes go in data.ts, types in type.ts)
- **See also:** [ADR-0010: Domain Modeling](0010-domain-modelling.md) (discriminated unions with enum-likes)
- **Extended by:** [ADR-0011: Naming Conventions and Domain Language](0011-naming-conventions.md) (naming conventions for constants)

---

← [ADR-0004: Type System Strategy](0004-type-strategy.md) | [ADR-0006: Error Handling Strategy](0006-error-handling.md) →

---

## Decision Log

| Date | Status | Author | Notes |
|------|--------|--------|-------|
| 2025-06-13 | Draft | Claude | Initial version with enum-like terminology and examples |
| 2025-06-13 | Draft | Audrey | Extracted enum utilities |
| 2025-06-13 | Active | Audrey | Reviewed and approved |
