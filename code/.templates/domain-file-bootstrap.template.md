# [Module Name] Domain

## Overview

A single paragraph capturing:

- The domain's primary responsibility and feedback mechanisms
- Its role within the larger system architecture  
- Key boundaries and interfaces

## Core Concepts

### Entities

Define each identified entity with:

- **[Entity Name]**: Precise definition (1-2 sentences)
- Relationship to other entities
- Invariants that must hold

### Processes

Document the primary flows:

- Input conditions and types
- Transformation logic (high-level)
- Output guarantees

## Technical Model

### Type Definitions

```typescript
// Core types that establish the domain structure
export type [EntityName] = {
  // ...
};
```

### Key Operations

```typescript
// Primary functions showing domain behavior
export function [operationName](input: InputType): Result<OutputType, ErrorType> {
  // Conceptual implementation
}
```

## System Integration

```mermaid
graph TD
    [Input] --> [Process]
    [Process] --> [Output]
    %% Show feedback loops and external dependencies
```

## Invariants & Constraints

- List 2-3 rules that must always hold
- Include both business and technical constraints

## Evolution Notes

- Current limitations
- Anticipated growth vectors
