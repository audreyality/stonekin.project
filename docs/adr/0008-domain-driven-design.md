# ADR-0008: Domain-Driven Approaches Over Service Patterns

## Status

**Current:** Active

## Problem

Traditional service patterns encourage anemic domain models where data structures contain no behavior and all logic is scattered across service classes. This creates several architectural problems:

- Domain logic becomes disconnected from the data it operates on
- Services often accumulate unrelated responsibilities, violating single responsibility principle
- Testing becomes complex due to service dependencies and mocking requirements
- Domain knowledge becomes implicit rather than explicit in the code structure
- Services create artificial boundaries that don't reflect the problem domain

Without clear guidance, developers default to familiar service patterns that conflict with our functional architecture and create unnecessary abstraction layers.

## Decision

We will **favor domain-driven approaches over traditional service patterns**. Instead of services, we will use:

- **Rich domain objects** created through factory functions
- **Composable interfaces** that define behavior contracts without mixing data
- **Progressive enhancement** using Object static methods to augment types with behavior

**Core Principles:**

- Domain objects encapsulate both data and behavior relevant to their domain
- Interfaces define pure behavior contracts without extending data types directly
- Factories create domain objects with appropriate behavior attached

## Why This Approach

- **Domain alignment**: Code structure reflects the problem domain rather than technical patterns
- **Encapsulation**: Related data and behavior stay together
- **Testability**: Domain objects can be tested in isolation without complex mocking
- **Discoverability**: LLMs can explore domain capabilities through interfaces
- **Flexibility**: Composable interfaces allow mixing capabilities as needed
- **Type safety**: Generic interfaces preserve type information while allowing behavior composition

## Implementation

### Domain Objects with Factory Functions

Create rich domain objects through factory functions rather than anemic data + services:

```typescript
import type { AgentConfig } from './type.ts'; // From ADR-0004

// ✅ Preferred: Rich domain object
type AgentData = {
  readonly id: string;
  readonly capabilities: readonly string[];
  readonly config: AgentConfig;
};

function createAgent(config: AgentConfig): Agent {
  const agent = Object.assign({ ...config }, {
    async execute(request: AgentRequest): Promise<Result<AgentResponse, string>> {
      return executeAgentRequest(this, request);
    },
    
    canHandle(requestType: string): boolean {
      return this.capabilities.includes(requestType);
    }
  }) as Agent;
  
  return agent;
}

// ❌ Avoid: Anemic data + service
class AgentService {
  async execute(agent: AgentData, request: AgentRequest): Promise<Result<AgentResponse, string>> {
    // Domain logic disconnected from data
  }
}
```

### Composable Interfaces Without Data Mixing

Interfaces should define pure behavior contracts and use generic parameters to operate on data:

```typescript
// ✅ Preferred: Pure behavior interface with generic parameter
interface Executable<T = object> extends T {
  execute(request: AgentRequest): Promise<Result<AgentResponse, string>>;
  canHandle(requestType: string): boolean;
}

interface Configurable<T = object> extends T {
  updateConfig(config: AgentConfig): Promise<T>;
  getCapabilities(): readonly string[];
}

// Compose interfaces for domain objects
interface Agent extends Executable<AgentData>, Configurable<AgentData> {
  communicate(message: Message): Promise<Result<Response, string>>;
}

// ❌ Avoid: Interface directly extending data type
interface BadAgent extends AgentData {
  execute(request: AgentRequest): Promise<Result<AgentResponse, string>>;
  // Mixes data and behavior concerns
}
```

### Progressive Enhancement with Object Static Methods

Use [Object.assign()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/assign) static methods to progressively enhance types with behavior:

```typescript
function makeExecutable<T extends AgentData>(data: T): Executable<T> {
  return Object.assign(data, {
    async execute(request: AgentRequest): Promise<Result<AgentResponse, string>> {
      return executeAgentRequest(data, request);
    },
    canHandle(requestType: string): boolean {
      return data.capabilities.includes(requestType);
    }
  }) as Executable<T>;
}

function makeConfigurable<T extends AgentData>(data: T): Configurable<T> {
  return Object.assign(data, {
    async updateConfig(config: AgentConfig): Promise<T> {
      return { ...data, config } as T;
    },
    getCapabilities(): readonly string[] {
      return data.capabilities;
    }
  }) as Configurable<T>;
}

// Factory composes enhancements
function createAgent(data: AgentData): Agent {
  let agent = { ...data };
  agent = makeExecutable(agent);
  agent = makeConfigurable(agent);
  
  return Object.assign(agent, {
    async communicate(message: Message): Promise<Result<Response, string>> {
      // ...
    }
  }) as Agent;
}
```

### Anti-Patterns to Avoid

```typescript
// ❌ Don't create traditional service classes
class AgentService {
  async processRequest(agent: AgentData, request: AgentRequest): Promise<AgentResponse> {
    // Domain logic separated from domain object
  }
}

// ❌ Don't mix data and behavior in interfaces
interface BadAgent extends AgentData {
  execute(request: AgentRequest): Promise<AgentResponse>;
}

// ❌ Don't use inheritance for domain modeling
class BaseAgent { /* Inheritance creates rigid hierarchies */ }
class ChatAgent extends BaseAgent { /* Prefer composition */ }
```

## Consequences

- **Benefits:**
  - Domain logic stays close to relevant data
  - Better testability through isolated domain objects
  - Flexible composition of capabilities
  - Clear separation between data types and behavioral interfaces

- **Trade-offs:**
  - More complex object creation patterns
  - Requires understanding of advanced TypeScript generics
  - Learning curve for developers familiar with service patterns

- **Migration:**
  - Extract domain logic from service classes into factory functions
  - Convert service interfaces to composable behavioral interfaces
  - Use progressive enhancement to add behavior to data objects

## Related ADRs

- **Builds on:** [ADR-0004: Type System Strategy](0004-type-strategy.md) (Interfaces for behavior, types for data)
- **Builds on:** [ADR-0007: Functional Style](0007-functional-style.md) (Composition over inheritance)
- **See also:** [ADR-0003: Import/Export Boundaries](0003-boundaries-and-dependencies.md) (Module organization for domain objects)
- **Extended by:** [ADR-0010: Domain Modeling with Opaque Types](0010-domain-modelling.md) (opaque types support rich domain modeling)
- **Extended by:** [ADR-0011: Naming Conventions and Domain Language](0011-naming-conventions.md) (domain-focused naming aligns with DDD principles)

---

← [ADR-0007: Functional Style](0007-functional-style.md) | [ADR-0009: Dependency Inversion](0009-dependency-inversion.md) →

---

## Decision Log

| Date | Status | Author | Notes |
|------|--------|--------|-------|
| 2025-06-13 | Draft | Claude | Initial version emphasizing domain-driven patterns over services |
| 2025-06-13 | Active | Audrey | Reviewed and approved |
| 2025-06-18 | Active | Claude | Amended to use opaque types |
