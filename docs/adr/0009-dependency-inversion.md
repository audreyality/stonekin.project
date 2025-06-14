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
- **Idiomatic JavaScript**: Uses native `bind` for currying

## Implementation

### Interface-Based Dependency Contracts

Define dependency contracts in `api.ts` files:

```typescript
// agent/api.ts
export interface LlmProvider {
  generateResponse(prompt: string): Promise<Result<string, string>>;
}

export interface ToolExecutor {
  executeTool(name: string, args: unknown): Promise<Result<ToolResult, string>>;
}
```

### Curried Factory Functions

Create factories in `di.ts` files that accept dependencies as curried parameters:

```typescript
// agent/di.ts
type AgentDependencies = {
  llmProvider: LlmProvider;
  toolExecutor: ToolExecutor;
};

// Factory function with dependency injection
function createAgentWithDeps(deps: AgentDependencies, data: AgentData): Agent {
  return Object.assign({ ...data }, {
    async execute(request: AgentRequest) {
      return deps.llmProvider.generateResponse(request.prompt);
    },
    
    async useTool(name: string, args: unknown) {
      return deps.toolExecutor.executeTool(name, args);
    }
  }) as Agent;
}

export { createAgentWithDeps };
```

### Application-Level Dependency Wiring

Wire dependencies at application startup using `bind`:

```typescript
// app.ts - Application startup
const dependencies: AgentDependencies = {
  llmProvider: new OpenAIProvider(),
  toolExecutor: new McpToolExecutor()
};

// Create bound factory with dependencies injected
const createAgent = createAgentWithDeps.bind(null, dependencies);

// Use the bound factory to create agents
const textAgent = createAgent({
  id: 'text-agent-1',
  capabilities: ['text-processing'],
  // ...
});

const toolAgent = createAgent({
  id: 'tool-agent-1', 
  capabilities: ['tool-execution'],
  // ...
});
```

### Testing with Dependency Injection

```typescript
// agent/agent.test.ts
test('handles llm provider errors', async () => {
  const mockProvider: LlmProvider = {
    async generateResponse() { return [undefined, 'Connection timeout']; }
  };
  
  const mockDeps = { llmProvider: mockProvider, toolExecutor: mockToolExecutor };
  const agent = createAgentWithDeps(mockDeps, testAgentData);
  
  const [response, error] = await agent.execute({ prompt: 'Hello' });
  expect(error).toBe('Connection timeout');
});
```

### Cross-Module Communication

Use dependency injection for communication between modules:

```typescript
// Parent module defines interfaces in prelude.ts
export interface EventBus {
  publish(event: DomainEvent): Promise<void>;
}

// Child modules depend on parent abstractions via di.ts
// agent/supervisor/di.ts
function createAgentSystemWithDeps(
  deps: { eventBus: EventBus }, 
  config: AgentSystemConfig
): AgentSystem {
  return {
    async spawnAgent(data: AgentData) {
      const agent = createAgent(data);
      await deps.eventBus.publish({
        type: 'agent.spawned',
        agentId: agent.id
      });
      // ...
    }
  };
}

// In application code
const createAgentSystem = createAgentSystemWithDeps.bind(null, { eventBus });
// ...
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

- **Migration:**
  - Extract service dependencies to interface contracts in `api.ts`
  - Move factory functions to `di.ts` files
  - Convert direct imports to dependency parameters
  - Use `bind` to create dependency-injected factory functions

## Related ADRs

- **Builds on:** [ADR-0001: Module Organization](0001-module-organization.md) (Parent-child dependencies)
- **Builds on:** [ADR-0002: File Organization](0002-file-organization.md) (di.ts naming convention)
- **Builds on:** [ADR-0004: Type System Strategy] (Interfaces for behavioral contracts)
- **Builds on:** [ADR-0007: Functional Style] (Function composition over frameworks)

---

## Decision Log

| Date | Status | Author | Notes |
|------|--------|--------|-------|
| 2025-06-13 | Draft | GitHub Copilot | Initial version with curried factory pattern using bind |
| 2025-06-13 | Active | Audrey | Reviewed and approved |
