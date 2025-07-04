# ADR-0009: Dependency Management and Injection

## Status

**Current:** Active

## Problem

Traditional dependency injection frameworks create heavy runtime overhead and complex configuration patterns that conflict with our functional programming approach. Without clear dependency management patterns, modules become difficult to test in isolation, cross-module communication becomes tightly coupled, and factory functions require complex parameter threading to manage their dependencies.

## Decision

We will use **curried factory functions and interface-based dependency inversion** to create lightweight dependency management through function composition. Dependencies will be injected through currying using JavaScript's `bind` method rather than framework-based DI containers.

**Core Principles:**

- Use interfaces to define dependency contracts in `api.ts` files
- Create factories that accept dependencies as curried parameters in `di.ts` files
- Use `bind` for idiomatic currying in JavaScript
- Keep dependency resolution explicit and functional

## Why This Approach

- **Type safety**: Dependencies are resolved at compile time with full type checking
- **Testability**: Easy to substitute mock implementations for testing
- **Zero runtime overhead**: No reflection or metadata required
- **Framework independence**: No external DI libraries required
- **Idiomatic JavaScript**: Uses native [`bind`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/bind) for currying

## Implementation

### Interface-Based Dependency Contracts

Define dependency contracts in `api.ts` files:

```typescript
export interface LlmProvider {
  generateResponse(prompt: string): Promise<Result<string, string>>;
}

export interface ToolExecutor {
  executeTool(name: string, args: unknown): Promise<Result<ToolResult, string>>;
}
```

### Curried Factory Functions

Create factories in `di.ts` files with individual curried parameters:

```typescript
function createAgent(
  llmProvider: LlmProvider,
  toolExecutor: ToolExecutor,
  config: AgentConfig
): Agent {
  return {
    ...config,
    async execute(request: AgentRequest) {
      return llmProvider.generateResponse(request.prompt);
    },
    async useTool(name: string, args: unknown) {
      return toolExecutor.executeTool(name, args);
    }
  };
}
```

### Application-Level Dependency Wiring

Use `bind` for progressive specialization:

```typescript
const createAgentWithOpenAI = createAgent.bind(null, openAIProvider);
const createLocalAgent = createAgentWithOpenAI.bind(null, localTools);

const agent = createLocalAgent({ id: 'agent-1' });
```

### Testing with Dependency Injection

```typescript
test('uses mock dependencies', () => {
  const mockProvider = { async generateResponse() { return [undefined, 'error']; } };
  const agent = createAgent(mockProvider, mockTools, config);
  // ...
});

test('partial application in tests', () => {
  const createTestAgent = createAgent.bind(null, mockProvider);
  const agent = createTestAgent(realTools, config);
  // ...
});
```

### Cross-Module Communication

```typescript
export interface Logger {
  log(level: string, message: string): void;
}

function createAgentSystem(
  logger: Logger,
  config: AgentSystemConfig
): AgentSystem {
  return {
    async spawnAgent(data: AgentData) {
      logger.log('info', `Spawning agent ${data.id}`);
      // ...
    }
  };
}

const createSystemWithLogger = createAgentSystem.bind(null, logger);
const system = createSystemWithLogger(config);
```

## Consequences

- **Benefits:**
  - Type-safe dependency resolution at compile time
  - Easy testing through dependency substitution
  - No runtime DI framework overhead
  - Idiomatic JavaScript using native `bind`
  - Clear dependency contracts through interfaces

- **Trade-offs:**
  - Manual dependency wiring at application startup
  - Requires understanding of function currying and `bind`
  - More explicit setup compared to framework-based DI
  - Parameter order matters for effective currying (most stable dependencies first)

## Related ADRs

- **Builds on:** [ADR-0001: Module Organization](0001-module-organization.md) (Parent-child dependencies)
- **Builds on:** [ADR-0002: File Organization](0002-file-organization.md) (di.ts naming convention)
- **Builds on:** [ADR-0004: Type System Strategy](0004-type-strategy.md) (Interfaces for behavioral contracts)
- **Builds on:** [ADR-0007: Functional Style](0007-functional-style.md) (Function composition over frameworks)
- **See also:** [ADR-0006: Error Handling](0006-error-handling.md) (Result type patterns in DI)
- **See also:** [ADR-0008: Domain-Driven Design](0008-domain-driven-design.md) (Factory patterns for domain objects)
- **Implemented by:** [ADR-0014: RxJS Stream Primitive](0014-rxjs-stream-primitive.md) (Stream interfaces enable dependency injection)

---

[← ADR-0008: Domain-Driven Design](0008-domain-driven-design.md) | [ADR-0010: Domain Modeling →](0010-domain-modelling.md)

---

## Decision Log

| Date | Status | Author | Notes |
|------|--------|--------|-------|
| 2025-06-13 | Draft | Claude | Initial version with curried factory pattern using bind |
| 2025-06-13 | Active | Audrey | Reviewed and approved |
| 2025-06-19 | Active | Claude | Fixed to use true currying instead of dependency grouping |
