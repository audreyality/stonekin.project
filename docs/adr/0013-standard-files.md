# ADR-0013: Standard File Patterns and Purposes

## Status

**Current:** Active

## Problem

While ADR-0001, ADR-0002, and ADR-0003 establish module structure, naming conventions, and import boundaries, developers still need guidance on what content belongs in which files within a module. Without clear file organization patterns, code gets placed arbitrarily, leading to modules where types are mixed with implementations, utilities are scattered across multiple files, and the purpose of each file is unclear. This makes it difficult for both developers and LLMs to locate specific functionality or understand how pieces fit together.

## Decision

We will standardize on seven file types within modules, each with a specific purpose and content pattern. These files work together to create predictable, well-organized modules that separate concerns clearly while maintaining cohesion.

### Standard File Types

- **`index.ts`** - Public module interface for external consumers
- **`prelude.ts`** - Internal abstractions for child modules
- **`data.ts`** - Constants, configurations, and enum-like objects
- **`type.ts`** - Type definitions and data structures
- **`api.ts`** - Interface definitions for dependency contracts
- **`di.ts`** - Dependency injection and factory functions
- **`util.ts`** - Pure utility functions

**Implementation files** extend these standard files with specific business logic and concrete implementations. They import from standard files and contain the actual functionality of the module (e.g., `agent.ts`, `registry.ts`, `executor.ts`).

## Why This Approach

- **Predictable location**: Developers know exactly where to find and place different types of code
- **Clear separation**: Each file has a single, well-defined responsibility
- **Incremental adoption**: Files are created only when needed, not upfront
- **Tool support**: Standard patterns enable better autocomplete and navigation
- **Cognitive clarity**: Related concepts are grouped together, reducing mental overhead

## Implementation

### File Purposes and Content Patterns

#### `index.ts` - Public Module Interface

Exports the module's public API for external consumers. Only imports from local implementation files.

```typescript
// filepath: src/agent/index.ts
export { createAgent } from './agent.ts';
export { processConversation } from './conversation.ts';
export type { AgentConfig } from './type.ts';
export { DEFAULT_AGENT_CONFIG } from './data.ts';
```

#### `prelude.ts` - Internal Abstractions

Exports types and interfaces for child modules. Must re-export parent's prelude.

```typescript
// filepath: src/agent/prelude.ts
export * from '../prelude.ts';
export type { AgentError } from './type.ts';
export type { Agent, ToolExecutor, LlmProvider } from './api.ts';
```

#### `data.ts` - Constants and Configuration

Contains default configurations, constants, and [enum-like objects](0005-enum-likes.md). No function definitions.

```typescript
// filepath: src/agent/data.ts
export const DEFAULT_AGENT_CONFIG = {
  timeout: 30000,
  model: 'claude-3-sonnet',
  // ...
} as const;

export const AGENT_CAPABILITIES = {
  REASONING: 'reasoning',
  TOOL_USE: 'tool-use',
  // ...
} as const;
```

#### `type.ts` - Type Definitions

Defines data structures and type aliases following [type system strategy](0004-type-strategy.md). No implementations, only type declarations.

```typescript
// filepath: src/agent/type.ts
import type { AGENT_CAPABILITIES } from './data.ts';

export type AgentCapability = typeof AGENT_CAPABILITIES[keyof typeof AGENT_CAPABILITIES];

export type AgentConfig = {
  readonly id: string;
  readonly capabilities: readonly AgentCapability[];
  // ...
};

export type AgentError = {
  readonly type: 'validation' | 'execution';
  readonly message: string;
};
```

#### `api.ts` - Interface Definitions

Defines contracts for dependencies and external integrations following [type system strategy](0004-type-strategy.md). Pure interface definitions.

```typescript
// filepath: src/agent/api.ts
import type { AgentError } from './type.ts';

export interface Agent {
  execute(prompt: string): Promise<Result<string, string>>;
}

export interface ToolExecutor {
  executeTool(name: string, args: unknown): Promise<Result<string, AgentError>>;
}

export interface LlmProvider {
  generateResponse(prompt: string): Promise<Result<string, string>>;
}
```

#### `di.ts` - Dependency Injection

Contains [factory functions](0008-domain-driven-design.md) and [dependency injection utilities](0009-dependency-inversion.md). Creates configured instances.

```typescript
// filepath: src/agent/di.ts
import type { AgentConfig } from './type.ts';
import type { LlmProvider } from './api.ts';
import { DEFAULT_AGENT_CONFIG } from './data.ts';

export function createAgentWithDeps(deps: { llmProvider: LlmProvider }) {
  // ...
}

export function createAgentRegistry() {
  // ...
}
```

#### `util.ts` - Pure Utility Functions

Contains stateless utility functions that operate on the module's types following [functional programming patterns](0007-functional-style.md). No side effects.

```typescript
// filepath: src/agent/util.ts
import type { AgentConfig, AgentCapability } from './type.ts';

export function validateAgentConfig(config: AgentConfig): boolean {
  // ...
}

export function hasCapability(config: AgentConfig, capability: AgentCapability): boolean {
  // ...
}
```

### How Files Work Together

For a complete understanding of module organization patterns, see the [TypeScript Module Resolution documentation](https://www.typescriptlang.org/docs/handbook/module-resolution.html) and [Node.js ES Modules guide](https://nodejs.org/api/esm.html).

```typescript
// create-agent.ts - imports from standard files
import type { AgentConfig } from './type.ts';
import type { Agent, LlmProvider } from './api.ts';
import { validateAgentConfig } from './util.ts';
import { DEFAULT_AGENT_CONFIG } from './data.ts';

export function createAgent(config: AgentConfig, llmProvider: LlmProvider): Agent {
  if (!validateAgentConfig(config)) {
    throw new Error('Invalid agent configuration');
  }
  
  return {
    id: config.id,
    async execute(prompt: string) {
      return llmProvider.generateResponse(prompt);
    }
    // ...
  };
}
```

### File Creation Guidelines

- **Create incrementally**: Only create files when you have content for them
- **Start with essentials**: Most modules need `index.ts`, `type.ts`, and at least one implementation file
- **Add as needed**: Create `data.ts`, `api.ts`, `di.ts`, and `util.ts` when their specific patterns emerge
- **Implementation files**: Create named implementation files (e.g., `agent.ts`, `registry.ts`) to contain specific domain logic
- **Avoid empty files**: Don't create placeholder files; wait until you have actual content

## Consequences

- **Benefits:**
  - Predictable code organization reduces navigation time
  - Clear separation of concerns improves maintainability
  - Standard patterns enable better tooling and autocomplete
  - LLMs can generate more appropriate code when file purposes are clear
  - Code reviews focus on logic rather than organization decisions

- **Trade-offs:**
  - More files per module increases initial cognitive overhead
  - Requires discipline to maintain separation between file types
  - May lead to over-engineering for simple modules

- **Migration:**
  - Existing modules can adopt patterns incrementally
  - Start by extracting types and constants into dedicated files
  - Gradually separate interfaces and utilities as modules mature

## Related ADRs

- **Builds on:** [ADR-0001: Module Organization](0001-module-organization.md)
- **Builds on:** [ADR-0002: File Naming Conventions](0002-file-organization.md)
- **Builds on:** [ADR-0003: Import/Export Boundaries](0003-boundaries-and-dependencies.md)
- **Implements:** [ADR-0004: Type System Strategy](0004-type-strategy.md) (types vs interfaces in separate files)
- **Implements:** [ADR-0005: Enum Alternatives](0005-enum-likes.md) (enum-likes in `data.ts`)
- **Supports:** [ADR-0007: Functional Programming Style](0007-functional-style.md) (pure functions in `util.ts`)
- **Supports:** [ADR-0008: Domain-Driven Design](0008-domain-driven-design.md) (factory patterns in `di.ts`)
- **Supports:** [ADR-0009: Dependency Injection](0009-dependency-inversion.md) (DI patterns in `di.ts`)
- **Supports:** [ADR-0011: Naming Conventions and Domain Language](0011-naming-conventions.md) (file naming that implements these conventions)
- **See also:** Future ADRs on testing patterns will reference these file organization standards

← [ADR-0012: Documentation Standards](0012-documentation.md)

---

## Decision Log

| Date | Status | Author | Notes |
|------|--------|--------|-------|
| 2025-06-14 | Draft | GitHub Copilot | Initial standard file patterns |
| 2025-06-14 | Active | Audrey | Reviewed and approved with minor changes |
