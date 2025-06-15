# ADR-0012: Module Documentation Standards

## Status

**Current:** Active

## Problem

The Stonekin SDK needs clear documentation standards that serve both human developers and AI assistants while maintaining architectural coherence. Without structured documentation guidelines, important context gets lost, onboarding becomes difficult, and the reasoning behind design decisions becomes tribal knowledge. Additionally, documentation needs to be embedded close to code for maximum relevance and maintainability.

## Decision

We will embed documentation as close to applicable code as possible using a tiered documentation strategy. Documentation will follow domain-driven design principles, focusing on agent capabilities, conversation management, and tool orchestration rather than technical implementation details.

### Documentation Hierarchy

- **Project-level**: `docs/` folder contains documentation spanning the full breadth of the stonekin project
- **Module-level**: `README.md` for NPM modules describing public interface and usage
- **Domain-level**: `_DOMAIN.md` for complex agent subsystems requiring domain context
- **Implementation-level**: TSDoc comments for all exported functions and types

### Domain-Focused Content

All documentation will use language from the agentic systems domain rather than generic software terminology. Programming assistants need domain context to properly implement domain-driven patterns.

## Why This Approach

- **Proximity principle**: Documentation near code stays current and relevant
- **Graduated detail**: Different audiences get appropriate levels of information
- **Domain alignment**: Consistent vocabulary improves comprehension across teams
- **AI-friendly**: Structured patterns help LLMs understand and maintain consistency
- **Maintainable**: Clear ownership and purpose for each documentation type

## Implementation

### Required Documentation: README.md (NPM Modules)

Every NPM module must have a README.md following [NPM README guidelines](https://docs.npmjs.com/about-npm/readme) and [CommonMark markdown standards](https://commonmark.org/). For consistent formatting, follow [markdownlint rules](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md) and [prettier markdown formatting](https://prettier.io/docs/en/options.html#prose-wrap):

```markdown
# Agent Framework

Manages agent lifecycle and discovery within the Stonekin framework.

## Installation

```bash
npm install @stonekin/agent-framework
```

## Usage

```typescript
import { createAgent, processConversation } from '@stonekin/agent-framework';

const agent = createAgent({
  id: 'customer-support',
  capabilities: ['conversation', 'search']
});

const response = await processConversation(agent, userMessage, tools);
```

## Dependencies

- Requires: `@stonekin/conversation-context`
- Provides: Agent discovery to orchestration modules

```markdown

### Domain Documentation: _DOMAIN.md

For complex agent subsystems requiring domain context:

```markdown
# Conversation Management Domain

## Overview

Manages stateful interactions between users and agents while preserving conversation boundaries.

## Key Concepts

### Conversation Sessions
- Message history with role attribution (user/agent/tool)
- Agent configuration and capability constraints  
- Tool execution context and partial results

### Agent Processing Protocol
When agents process conversations:
1. Agent receives user message with conversation context
2. Agent analyzes message using configured capabilities
3. Agent may invoke tools through execution framework
4. Results integrate into conversation history
5. Agent generates contextual response

## Architecture Patterns

Implements **Conversation Aggregate** pattern where ConversationSession is the aggregate root containing Messages as value objects.
```

### TSDoc Standards for Agent Systems

All exported functions must include domain-specific documentation following the [TSDoc specification](https://tsdoc.org/). See also the [TypeScript JSDoc reference](https://www.typescriptlang.org/docs/handbook/jsdoc-supported-types.html) and [VSCode IntelliSense JSDoc support](https://code.visualstudio.com/docs/languages/javascript#_jsdoc-support) for tooling integration.

```typescript
/**
 * Processes conversation turn with agent capabilities and tool access.
 * 
 * @param agent - Configured agent with defined capabilities
 * @param message - User input message to process
 * @param tools - Available tools for agent invocation
 * @returns Agent response with tool interactions
 * 
 * @throws {ConversationError} When conversation context is corrupted
 *
 * @example
 * ```typescript
 * const response = await processConversation(
 *   chatAgent,
 *   "Debug this TypeScript error",
 *   [codeAnalysisTool]
 * );
 * ```
 */
export async function processConversation(
  agent: Agent,
  message: UserMessage,
  tools: AgentTool[]
): Promise<AgentResponse> {
  // ...
}
```

### Documentation Examples

```typescript
// ✅ Domain-focused documentation
/**
 * Processes conversation turns with tool integration.
 * Preserves context across tool invocations.
 */
export interface ConversationManager {
  processConversationTurn(input: UserInput, tools: ToolRegistry): Promise<AgentResponse>;
}

// ❌ Generic technical documentation  
/**
 * Service class that handles business logic.
 */
export interface DataService {
  process(data: any): Promise<any>;
}
```

### _DOMAIN.md Example

**See:** [_DOMAIN.md](./_DOMAIN.md_)

## Consequences

- **Benefits:**
  - Documentation stays current by being co-located with code
  - Domain language creates shared vocabulary across team
  - Graduated detail serves different reader needs effectively
  - AI assistants get clear context for maintaining consistency

- **Trade-offs:**
  - Requires discipline to maintain documentation during development
  - Domain-specific examples require more context than generic patterns
  - Multiple documentation files increase cognitive overhead for simple modules

## Related ADRs

- **Builds on:** [ADR-0001: Module Organization and Folder Structure](0001-module-organization.md)
- **Builds on:** [ADR-0002: File Naming and Organization Conventions](0002-file-organization.md)
- **Builds on:** [ADR-0011: Naming Conventions and Domain Language](0011-naming-conventions.md) (domain-focused naming supports documentation clarity)
- **See also:** [ADR-0008: Domain-Driven Approaches Over Service Patterns](0008-domain-driven-design.md) (domain object documentation patterns and factory function documentation)

← [ADR-0011: Naming Conventions](0011-naming-conventions.md) | [ADR-0013: Standard File Patterns](0013-standard-files.md) →

---

## Decision Log

| Date | Status | Author | Notes |
|------|--------|--------|-------|
| 2025-06-14 | Draft | GitHub Copilot | Initial documentation standards |
| 2025-06-14 | Active | Audrey | Reviewed and approved |
