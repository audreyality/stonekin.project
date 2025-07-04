# ADR-0014: Adopt RxJS as Stream Primitive

## Status

**Current:** Draft

## Problem

Agents require composable, asynchronous, and replayable pipelines to support perception, reflection, and interaction. Prior models using mutable memory and copy-on-write structures proved incompatible with agent cognition at scale. Without a clear stream abstraction, developers experience difficulty in maintaining and extending agent behaviors, leading to increased complexity and reduced scalability.

## Decision

We choose RxJS as the official stream abstraction for the Stonekin SDK. All perception, memory, action, and supervision will flow through RxJS primitives (`Observable`, `SubjectLike`, `Observer`, and `SchedulerLike`). Custom behaviors and memory sinks will be built as implementations of these interfaces.

### Core Principles/Patterns

**Key principles:**

- **Encapsulation:** Behaviors are encapsulated using named interfaces (e.g., `ConversationSession`, `ToolExecutor`, `Agent`).
- **Generic Operators:** Operators work generically, accepting lambdas and configuration just like native RxJS operators.
- **Declarative Surface:** Operators like `processWithAgent()`, `executeTools()`, and `storeTo()` provide a declarative interface.
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

### Domain Interface Pattern

```typescript
interface ConversationSession {
  // ...existing properties...
  messageStream?: Subject<Message>;
  update(response: AgentResponse): void; // existing method
  searchMessages(query: string): Observable<Message>;
}
```

### Generic Operator Pattern

```typescript
function storeTo(sink: { store: Observer<T> }): OperatorFunction<T, T> {
  return tap(value => sink.store.next(value));
}

function processWithAgent(agent: Agent): OperatorFunction<UserInput, AgentResponse> {
  return switchMap(input => from(agent.process(input)));
}
```

### Application

```typescript
userInputs.pipe(
  processWithAgent(agent),
  tap(response => session.update(response)),
  storeTo({ store: session.messageStream }),
  logStream("agent-interaction")
).subscribe();
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
- **See also:** [_DOMAIN.md](../_DOMAIN.md) (Provides domain vocabulary for examples)

---

## Decision Log

| Date       | Status | Author                      | Notes                               |
|------------|--------|-----------------------------|-------------------------------------|
| 2025-07-04 | Draft  | ChatGPT (Daemon)            | Initial draft                       |
| 2025-07-04 | Draft  | Copilot (GPT 4o)            | Improve consistency with other ADRs |
| 2025-07-04 | Draft  | Copilot (Claude Sonnet 4)   | Replace abstract examples with domain-aligned patterns, streamline implementation section |
