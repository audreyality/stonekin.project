# ADR-0004: Type System Strategy (Types vs Interfaces)

## Status

**Current:** Active

## Problem

TypeScript provides both `type` aliases and `interface` declarations for defining contracts, but without clear guidelines, developers use them inconsistently. This creates confusion about when to use each construct and leads to mixed patterns that make the codebase harder to understand and maintain. For LLMs generating code, unclear type vs interface usage results in inconsistent code generation that doesn't follow established architectural patterns.

## Decision

We will use a clear semantic distinction between `type` and `interface` based on what we're modeling:

- **Use `type` definitions** to model pure data abstractions and structure
- **Use `interface` declarations** to model functional abstractions and behavioral contracts

This creates a clear mental model: types represent "what something looks like" while interfaces represent "what something can do."

## Why This Approach

- **Semantic clarity**: The distinction matches the conceptual difference between data and behavior
- **Serialization safety**: Types naturally encourage JSON-compatible data structures
- **Contract modeling**: Interfaces clearly express behavioral expectations and dependencies
- **Composition patterns**: Types work better with union types and data transformation, interfaces work better with dependency injection and mocking
- **Extensibility**: Behaviors may be progressively enhanced using declaration merging
- **Tooling alignment**: Most TypeScript tooling expects interfaces for behavioral contracts
- **Architectural consistency**: Aligns with our preference for functional idioms over OOP patterns

## Implementation

### Data Modeling with Types

Use `type` for pure data structures, configurations, and value objects that should remain serializable:

```typescript
// ✅ Types for data structures
type UserProfile = {
  readonly id: string;
  readonly email: string;
  readonly preferences: {
    readonly theme: 'light' | 'dark';
    readonly notifications: boolean;
  };
};

type AgentConfig = {
  readonly name: string;
  readonly model: string;
  readonly temperature: number;
  readonly maxTokens: number;
};

// ✅ Types for discriminated unions (state modeling)
type ProcessingState = 
  | { readonly status: 'pending'; readonly queuePosition: number }
  | { readonly status: 'processing'; readonly progress: number }
  | { readonly status: 'complete'; readonly result: string }
  | { readonly status: 'failed'; readonly error: string };

// ✅ Types for branded primitives
type UserId = string & { readonly __brand: 'UserId' };
type Email = string & { readonly __brand: 'Email' };

// ✅ Types for constant objects (our enum alternative)
const Status = { PENDING: 'pending', COMPLETE: 'complete' } as const;
type StatusType = typeof Status[keyof typeof Status];
```

### Behavioral Modeling with Interfaces

Use `interface` for behavioral contracts, service definitions, and functional abstractions:

```typescript
// ✅ Interfaces for behavioral contracts
interface Logger {
  info(message: string, context?: Record<string, unknown>): void;
  error(message: string, error?: Error): void;
  debug(message: string, data?: unknown): void;
}

interface AgentExecutor {
  execute(prompt: string, config: AgentConfig): Promise<string>;
  validateConfig(config: AgentConfig): boolean;
}

// ✅ Interfaces for dependency contracts (goes in api.ts)
interface DatabaseConnection {
  query<T>(sql: string, params?: unknown[]): Promise<T[]>;
  transaction<T>(work: (tx: DatabaseConnection) => Promise<T>): Promise<T>;
  close(): Promise<void>;
}
```

### File Organization Alignment

This decision integrates with our file organization patterns:

```typescript
// data.ts - constant objects and configurations
export const ProcessingStatus = {
  PENDING: 'pending',
  PROCESSING: 'processing', 
  COMPLETE: 'complete',
  FAILED: 'failed'
} as const;

// type.ts - data structures and type definitions
export type ProcessingState = 
  | { readonly status: typeof ProcessingStatus.PENDING; readonly queuePosition: number }
  | { readonly status: typeof ProcessingStatus.PROCESSING; readonly progress: number }
  | { readonly status: typeof ProcessingStatus.COMPLETE; readonly result: string }
  | { readonly status: typeof ProcessingStatus.FAILED; readonly error: string };

export type TaskConfig = {
  readonly id: string;
  readonly priority: number;
  readonly retryCount: number;
};

// api.ts - behavioral contracts and interfaces
export interface TaskProcessor {
  process(task: TaskConfig): Promise<ProcessingState>;
  cancel(taskId: string): Promise<void>;
  getStatus(taskId: string): ProcessingState | null;
}

export interface TaskQueue {
  enqueue(task: TaskConfig): Promise<void>;
  dequeue(): Promise<TaskConfig | null>;
  size(): number;
}
```

### Anti-Patterns to Avoid

```typescript
// ❌ Don't use interfaces for pure data
interface UserData {  // Should be a type
  name: string;
  email: string;
}

// ❌ Don't use types for behavioral contracts
type EventHandler = {  // Should be an interface
  handle(event: Event): void;
  canHandle(event: Event): boolean;
};

// ❌ Don't mix data and behavior in types
type UserWithActions = {
  name: string;
  email: string;
  save(): Promise<void>;  // Behavior doesn't belong in a type
};
```

## Consequences

- **Benefits:**
  - Clear semantic distinction reduces decision paralysis
  - Better alignment with functional programming patterns
  - Improved serialization safety for data structures
  - More effective dependency injection and testing patterns
  - Clearer file organization with types and interfaces in appropriate files

- **Trade-offs:**
  - Requires learning the semantic distinction for developers used to arbitrary choice
  - Some TypeScript features work differently between types and interfaces (declaration merging, etc.)

## Related ADRs

- **Builds on:** [ADR-0001: Module Organization] (file placement patterns)
- **See also:** [ADR-0005: Enum Alternatives] (constant object patterns used with types)

---

## Decision Log

| Date | Status | Author | Notes |
|------|--------|--------|-------|
| 2025-06-13 | Draft | Claude | Initial version with examples and file organization |
| 2025-06-13 | Draft | Audrey | Removed function property preference; it belongs in a separate ADR |
| 2025-06-13 | Draft | Audrey | Added declaration merging benefit to the whys list |
| 2025-06-13 | Active | Audrey | Reviewed and approved |
