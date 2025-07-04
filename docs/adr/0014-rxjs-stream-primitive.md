# ADR-0014: Adopt RxJS as Stream Primitive

## Status

**Current:** Draft

## Problem

Agents require composable, asynchronous, and replayable pipelines to support perception, reflection, and interaction. Prior models using mutable memory and copy-on-write structures proved incompatible with agent cognition at scale. Without a clear stream abstraction, developers experience difficulty in maintaining and extending agent behaviors, leading to increased complexity and reduced scalability.

## Decision

We choose RxJS as the official stream abstraction for the Stonekin SDK. All perception, memory, action, and supervision will flow through RxJS primitives (`Observable`, `SubjectLike`, `Observer`, and `SchedulerLike`). Custom behaviors and memory sinks will be built as implementations of these interfaces.

### Core Principles/Patterns

**Key principles:**

- **Encapsulation:** Behaviors are encapsulated using named interfaces (e.g., `LongTermMemory`, `ReflectionSink`, `PlannerInterface`).
- **Generic Operators:** Operators work generically, accepting lambdas and configuration just like native RxJS operators.
- **Declarative Surface:** Operators like `reflectOn()`, `storeTo()`, and `vectorize()` provide a declarative interface.
- **Semantic Grouping:** Observers and Subjects are grouped into interfaces for routing, injection, and introspection.

### Specific Guidelines/Patterns

- `Observable` for perceptions
- `SubjectLike` for memory and tool interfaces
- `Observer` for side-effect endpoints
- `SchedulerLike` for time and priority contexts

## Why This Approach

**Benefits:**

- **Reusability:** RxJS composables allow shared behavior across all agents.
- **Semantic Grouping:** Stonekin interfaces organize behavior into signalable surfaces.
- **Instrumentation:** Supervisor agents can intercept streams without affecting logic.

**Trade-offs:**

- **Learning Curve:** Developers must understand RxJS primitives and operator chaining.
- **Complexity:** Observer composition and scheduling behavior must be disciplined.

## Implementation

### Implementation Pattern 1

#### Semantic Interface

```typescript
interface LongTermMemory {
  store: Observer<MemoryEntry>;
  search(query: string): Observable<SearchResult>;
}
```

#### Operator

```typescript
function storeTo(memory: { store: Observer<T> }): OperatorFunction<T, T> {
  return tap(value => memory.store.next(value));
}
```

### Application

```typescript
agentStream.pipe(
  reflectOn(),
  storeTo(agentContext.memory),
  logStream("thought")
)
```

## Consequences

|Impact|Description|
|---|---|
|✅ Reusability|RxJS composables allow shared behavior across all agents|
|✅ Semantic grouping|Stonekin interfaces organize behavior into signalable surfaces|
|✅ Instrumentation|Supervisor agents can intercept streams without affecting logic|
|⚠️ Learning curve|Developers must understand RxJS primitives and operator chaining|
|⚠️ Complexity|Observer composition and scheduling behavior must be disciplined|

## Related ADRs

- **Builds on:** [ADR-0004: Type Strategy](0004-type-strategy.md) (Defines type strategy for interfaces)
- **See also:** [ADR-0008: Domain-Driven Design](0008-domain-driven-design.md) (Provides context for semantic interfaces)

---

## Decision Log

| Date       | Status | Author           | Notes                               |
|------------|--------|------------------|-------------------------------------|
| 2025-07-04 | Draft  | ChatGPT (Daemon) | Initial draft                       |
| 2025-07-04 | Draft  | Copilot (GPT 4o) | Improve consistency with other ADRs |
