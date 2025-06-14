# ADR-0007: Functional Programming Style Over Object-Oriented Patterns

## Status

**Current:** Active

## Problem

Object-oriented programming patterns can lead to complex inheritance hierarchies, mutable state scattered across objects, and tight coupling between components. In a TypeScript codebase that emphasizes type safety and composability, traditional OOP patterns often create more problems than they solve:

- Classes encourage mutable state and stateful interactions
- Inheritance creates fragile hierarchies that are difficult to refactor
- Method-heavy objects make testing and mocking complex
- Side-effect-heavy void methods make control flow unpredictable

Without clear guidance, developers may default to familiar OOP patterns that conflict with our functional architecture goals and type-first design principles.

## Decision

We will **prefer functional programming idioms over object-oriented patterns** throughout the codebase. Classes should be used sparingly and only when encapsulating truly stateful, mutable concerns. The default approach should favor pure functions, immutable data structures, and function composition.

**Core Principles:**

- Pure functions over methods when possible
- Immutable data across module boundaries
- Function composition over inheritance
- Explicit return values over void functions with side effects
- Data and behavior separation over data-behavior coupling

**Immutability Scope:**
Immutability requirements apply to **module boundaries** (data crossing `index.ts` and `prelude.ts` interfaces). Internal module implementation may use mutable patterns when necessary for performance or third-party integration, but must present immutable interfaces to consumers.

## Why This Approach

- **Predictability**: Pure functions with no side effects are easier to reason about
- **Testability**: Functions with explicit inputs/outputs are simpler to test
- **Composability**: Functions can be combined in ways that objects cannot
- **Type safety**: Functional patterns work better with TypeScript's type system
- **Pragmatic**: Allows internal mutation for performance and third-party compatibility
- **Boundary clarity**: Clear contracts at module interfaces while preserving implementation flexibility

## Implementation

### Prefer Functions Over Classes

```typescript
// ✅ Preferred: Pure function approach
function validatePrompt(prompt: string, maxLength: number): Result<string, string> {
  if (prompt.length === 0) {
    return [undefined, 'Prompt cannot be empty'];
  }
  if (prompt.length > maxLength) {
    return [undefined, `Prompt exceeds maximum length of ${maxLength}`];
  }
  return [prompt, undefined];
}

// ❌ Avoid: Unnecessary class for stateless operations
class PromptValidator {
  validatePrompt(prompt: string, maxLength: number): Result<string, string> {
    // Same logic as above...
  }
}
```

### When Classes Are Appropriate

Classes should only encapsulate **stateful, mutable concerns**:

```typescript
// ✅ Appropriate: Managing agent session state
class AgentSession {
  private messages: readonly Message[] = [];
  private state: SessionState = 'idle';
  
  async sendMessage(prompt: string): Promise<Result<AgentResponse, string>> {
    if (this.state !== 'idle') {
      return [undefined, 'Agent is busy processing another request'];
    }
    
    this.state = 'processing';
    // ... process message and update state
    this.state = 'idle';
    
    return [response, undefined];
  }
}
```

### Immutability at Module Boundaries

Module interfaces must use immutable data, but internal implementation can use mutation for performance or third-party integration:

```typescript
// ✅ Module interface: Immutable data structures
// agent/index.ts
export function processPrompts(prompts: readonly string[]): Result<readonly AgentResponse[], string> {
  // Internal implementation may use mutable arrays for performance
  const results: AgentResponse[] = [];
  
  for (const prompt of prompts) {
    const [response, error] = processPrompt(prompt);
    if (error) {
      return [undefined, error];
    }
    results.push(response); // Internal mutation is fine
  }
  
  return [results, undefined]; // Return immutable reference
}

// ✅ Internal module: Mutable implementation for third-party integration
// agent/llm-client.ts (internal file)
class LLMClient {
  private cache: Map<string, string> = new Map(); // Mutable cache
  
  async query(prompt: string): Promise<string> {
    if (this.cache.has(prompt)) {
      return this.cache.get(prompt)!;
    }
    
    const response = await this.thirdPartyAPI.call(prompt);
    this.cache.set(prompt, response); // Mutation for caching
    return response;
  }
}
```

### Function Composition Patterns

```typescript
// ✅ Preferred: Function composition for prompt processing
type PromptProcessor = (input: string) => Result<string, string>;

function compose(...processors: PromptProcessor[]) {
  return (input: string): Result<string, string> => {
    let current: Result<string, string> = [input, undefined];
    
    for (const processor of processors) {
      if (current[1]) break; // Short-circuit on error
      current = processor(current[0]);
    }
    
    return current;
  };
}

// Usage
const processPrompt = compose(
  validatePromptLength,
  sanitizePrompt,
  enrichPrompt
);
```

### Explicit Returns Over Side Effects

```typescript
// ✅ Preferred: Explicit return values
function executeAgentRequest(
  request: AgentRequest,
  agent: Agent
): Result<AgentResponse, AgentError> {
  const [validatedRequest, validationError] = validateAgentRequest(request);
  if (validationError) {
    return [undefined, { type: 'validation', message: validationError }];
  }
  
  const [response, executionError] = agent.process(validatedRequest);
  if (executionError) {
    return [undefined, { type: 'execution', message: executionError }];
  }
  
  return [response, undefined];
}

// ❌ Avoid: Void functions with side effects
function executeAgentRequestWithSideEffects(request: AgentRequest): void {
  validateRequest(request);  // Where does validation result go?
  processRequest(request);   // How are errors handled?
}
```

### Pragmatic Mutation Patterns

Internal module code may use mutation when justified:

```typescript
// ✅ Internal: Mutable optimization for performance
function buildPromptFromParts(parts: readonly PromptPart[]): string {
  // Using mutable StringBuilder pattern for performance
  const builder: string[] = [];
  
  for (const part of parts) {
    if (part.type === 'system') {
      builder.push(`System: ${part.content}\n`);
    } else if (part.type === 'user') {
      builder.push(`User: ${part.content}\n`);
    }
  }
  
  return builder.join(''); // Immutable result
}

// ✅ Internal: Mutable state for third-party integration
class WebSocketAgent {
  private connection: WebSocket | null = null;
  private messageQueue: Message[] = []; // Mutable queue
  
  // Module boundary: Immutable interface
  async sendMessage(message: Message): Promise<Result<void, string>> {
    if (!this.connection) {
      this.messageQueue.push(message); // Internal mutation
      return [undefined, undefined];
    }
    
    try {
      this.connection.send(JSON.stringify(message));
      return [undefined, undefined];
    } catch (error) {
      return [undefined, error.message];
    }
  }
}
```

## Consequences

- **Benefits:**
  - More predictable code with fewer side effects at boundaries
  - Easier testing with pure functions
  - Better composability and reusability
  - Stronger alignment with TypeScript's type system
  - Performance flexibility for internal implementation
  - Practical integration with third-party libraries

- **Trade-offs:**
  - May require more explicit parameter passing at module boundaries
  - Some developers may need time to adjust from OOP patterns
  - Need to be disciplined about where mutation is acceptable

- **Migration:**
  - Focus first on making module interfaces immutable
  - Convert stateless classes to pure functions
  - Keep internal mutation where performance or third-party integration demands it
  - Gradually extract pure functions from method-heavy classes

## Related ADRs

- **Builds on:** [ADR-0003: Import/Export Boundaries] (Immutability applies at these boundaries)
- **Builds on:** [ADR-0004: Type System Strategy] (Functions work better with type-first design)
- **Builds on:** [ADR-0006: Error Handling Strategy] (Functional patterns compose with Result types)

---

## Decision Log

| Date | Status | Author | Notes |
|------|--------|--------|-------|
| 2025-06-13 | Draft | Claude | Initial version with boundary-scoped immutability |
| 2025-06-13 | Active | Audrey | Reviewed and approved |
