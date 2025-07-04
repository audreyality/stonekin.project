# Agentic Domain Model

The ADRs use a simplified agentic AI system as their domain.
This document explains elements of the domain that span
across files, so that the examples can be internally
consistent.

> [!IMPORTANT]
> **This model should be included when using an agent to create new ADRs.**
>
> It can also be used to refine *examples* contained in
> active ADRs, so that they remain "evergreen" with
> the latest practices.

## Summary

**Agentic Systems Domain**: Software that autonomously processes natural language requests by coordinating language models, tools, and conversation state to accomplish user goals. Agents orchestrate these capabilities while maintaining conversation context and handling tool execution.

**Core Problem**: Managing the complexity of autonomous request processing, tool coordination, and stateful conversations in a type-safe, maintainable way.

## Core Entity Vocabulary

These entities will be used consistently across all examples:

### Primary Entities

- **Agent**: Autonomous processor that coordinates language models and tools
- **AgentConfig**: Configuration for model selection and behavior limits
- **ConversationSession**: Stateful aggregate containing message history and context
- **Tool**: Executable capability (web search, calculation, file access)
- **Prompt**: Template for structuring agent inputs
- **LlmProvider**: Interface to language model capabilities

### Supporting Entities

- **ToolRegistry**: Central registry for tool discovery and management
- **ToolExecutor**: Interface for tool invocation and parameter validation (see [ADR-0009](0009-dependency-inversion.md))
- **AgentResponse**: Structured response format including tool interactions (see [ADR-0012](0012-documentation.md))
- **UserInput**: Standardized format for user requests and context
- **Message**: Communication unit with role attribution (user/agent/tool) (see [ADR-0012](0012-documentation.md))
- **ToolResult**: Standardized output format from tool execution
- **MessageStream**: Observable sequence of conversation messages (see [ADR-0014](0014-rxjs-stream-primitive.md))
- **ToolStream**: Observable sequence of tool executions (see [ADR-0014](0014-rxjs-stream-primitive.md))
- **PerceptionStream**: Observable sequence of agent perceptions (see [ADR-0014](0014-rxjs-stream-primitive.md))

## Domain Relationships

### Core Interactions

- **Agents** use **LlmProviders** to process requests, structured by **Prompts**
- **Agents** discover and execute **Tools** through **ToolRegistry** and **ToolExecutor**
- **ConversationSessions** maintain **Message** history with role attribution
- **ToolResults** are integrated into **AgentResponses** for conversation tracking

### Typical Flow

1. **UserInput** processed by **Agent** using **AgentConfig** parameters
2. **Agent** structures request via **Prompt** for **LlmProvider**
3. **Tools** invoked through **ToolExecutor** when needed
4. **ToolResults** integrated into **AgentResponse**
5. **ConversationSession** updated with complete interaction

## Implementation Patterns

When creating examples, follow these established patterns from the ADRs:

- Use **Result types** for error handling ([ADR-0006](0006-error-handling.md))
- Apply **opaque types** for domain identity ([ADR-0010](0010-domain-modelling.md))
- Model exclusive states with **discriminated unions** ([ADR-0005](0005-enum-likes.md), [ADR-0010](0010-domain-modelling.md))
- Create entities through **factory functions** ([ADR-0008](0008-domain-driven-design.md))
- Use **stream primitives** for reactive pipelines ([ADR-0014](0014-rxjs-stream-primitive.md))
- Structure tool communication using **MCP conventions**
- Maintain clear **import boundaries** between modules ([ADR-0003](0003-boundaries-and-dependencies.md))
