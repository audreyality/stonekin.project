# ADR-0003: Import/Export Boundaries and Dependencies

## Status

**Current:** Active

## Problem

Without clear import boundaries, modules become tightly coupled and interdependent, making it difficult to understand, test, and maintain code. Traditional TypeScript projects often allow unrestricted imports between modules, leading to circular dependencies, unclear responsibility boundaries, and modules that are difficult to reason about in isolation. For LLMs working on code generation, this creates an overwhelming context space where any file might depend on any other file.

## Decision

We will enforce strict import boundaries using a hierarchical system with two special interface files: `index.ts` for public exports and `prelude.ts` for internal exports to child modules. These files act as explicit contracts that define what each module exposes and to whom.

### The Two-Interface System

- **`index.ts`** - Public interface for external consumers
  - Exports concrete implementations, utilities, and services
    defined by the module
  - Used by parent modules and external packages
  - **Cannot be imported by files within the same folder**

- **`prelude.ts`** - Internal interface for child modules  
  - Exports types, interfaces, constants, and abstract declarations
  - Must re-export parent's prelude: `export * from '../prelude.ts'`
  - **Cannot be imported by files within the same folder**

### Import Rules

Files may **only** import from:

- Implementation files within their own folder (`./data.ts`, `./type.ts`, etc.)
- Parent folder's prelude (`../prelude.ts`)
- Sibling folders (`./sibling`)
- External npm packages
- Node.js built-in modules

Files may **never** import from:

- Their own folder's `index.ts` or `prelude.ts`. This prevents circular dependencies.
- Nested folders (`../cousin`, `./grand/child`, `../../grandparent`). This limits scope and maintains encapsulation.

## Why This Approach

- **Bounded context**: Each module has a clearly defined scope that LLMs can understand completely
- **Dependency clarity**: Import rules make dependency direction explicit and prevent cycles
- **Incremental understanding**: Developers and LLMs can understand modules in isolation
- **Interface segregation**: Public and internal concerns are separated cleanly
- **Testability**: Modules can be tested independently through their public interfaces

## Implementation

### Folder Structure Example

```text
src/
├── prelude.ts            # Root abstractions for all child modules
├── index.ts              # Main SDK public interface
├── agent/
│   ├── prelude.ts        # Agent abstractions (includes ../prelude.ts)
│   ├── index.ts          # Agent public interface
│   ├── data.ts           # Agent constants and defaults
│   ├── type.ts           # Agent type definitions
│   └── executor.ts       # Agent implementation
├── prompt/
│   ├── prelude.ts        # Prompt abstractions (includes ../prelude.ts)
│   ├── index.ts          # Prompt public interface
│   ├── template/         # Child module
│   │   ├── prelude.ts    # Template abstractions (includes ../prelude.ts)
│   │   ├── index.ts      # Template public interface
│   │   └── engine.ts     # Template implementation
│   └── history.ts        # Prompt implementation
```

### Interface File Examples

```typescript
// src/prelude.ts - Root abstractions
export type AgentConfigBase = {
  readonly id: string;
  readonly version: string;
};

export interface LoggerInterface {
  info(message: string): void;
  error(message: string, error?: Error): void;
}
```

```typescript
// src/agent/prelude.ts - Agent abstractions
export * from '../prelude.ts';  // Required: inherit parent abstractions

export type AgentConfig = AgentConfigBase & {
  readonly name: string;
  readonly capabilities: readonly string[];
};

export interface AgentInterface {
  execute(prompt: string): Promise<string>;
}
```

```typescript
// src/agent/agent-processor.ts - Implementation file
import type { AgentConfig } from '../prelude.ts';  // ✅ Parent prelude allowed

export const DEFAULT_AGENT_CONFIG: AgentConfig = {
  id: 'default-agent',
  version: '1.0.0',
  name: 'Default Agent',
  capabilities: ['chat', 'reasoning'],
};
```

```typescript
// src/agent/index.ts - Public interface
export { Agent } from './conversation-manager.ts';          // ✅ Own folder implementation
export { DEFAULT_AGENT_CONFIG } from './agent-processor.ts'; // ✅ Own folder implementation
export { * } from './supervisors';                          // ✅ Re-export child content
```

### Correct Import Patterns

```typescript
// ✅ Allowed imports
import { ApiConfig } from '../prelude.ts';                    // Parent prelude
import { AgentData } from './agent-processor.ts';             // Same folder implementation
import { validatePrompt } from './prompt-utils.ts';           // Same folder utility
import { ToolExecutor } from './tools';                       // Sibling folder
import { readFile } from 'fs/promises';                       // Node.js built-in
import { z } from 'zod';                                      // External package

// ❌ Forbidden imports
import { AgentService } from './index.ts';                    // Own folder interface
import { AgentTypes } from './prelude.ts';                    // Own folder prelude
import { ConversationEngine } from './agent/conversation.ts'; // Child folder (nested)
import { RootConfig } from '../../config.ts';                 // Grandparent folder (nested)
import { ToolsData } from '../tools/tool-executor.ts';        // Cousin folder (nested)
```

### Module Communication Patterns

```typescript
// Parent module using child module through public interface
import { ConversationManager } from './conversation/index.ts';  // ✅ Child's public interface

// Child module using parent abstractions
import type { AgentConfigBase } from '../prelude.ts';           // ✅ Parent abstractions

// Sibling communication through parent (when necessary)
// Both modules export through parent's index.ts, consumer imports from parent
```

## Consequences

- **Benefits:**
  - **Bounded context**: LLMs can work on modules without loading entire codebase
  - **Clear dependencies**: Import rules prevent architectural drift
  - **Better testing**: Modules are naturally isolated and mockable
  - **Reduced complexity**: Each file has a limited, predictable import surface
  - **Incremental loading**: Development tools can work with smaller contexts

- **Trade-offs:**
  - **More structure**: Requires discipline to maintain interface boundaries
  - **Module production**: Sharing beyond bounded context requires new npm module(s)
  - **Initial setup**: Creating proper interfaces requires upfront design

## Related ADRs

- **Builds on:** [ADR-0001: Module Organization](0001-module-organization.md)
- **Builds on:** [ADR-0002: File Naming Conventions](0002-file-organization.md)
- **See also:** Future ADRs on dependency injection and testing will build on these import patterns

---

## Decision Log

| Date | Status | Author | Notes |
|------|--------|--------|-------|
| 2025-06-13 | Draft | GitHub Copilot | Initial import boundary system |
| 2025-06-13 | Active | Audrey | Reviewed and approved with minor edits |
