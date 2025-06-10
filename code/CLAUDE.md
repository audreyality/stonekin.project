# General instructions for Claude Code - Opus

- This file contains comprehensive guidelines for programming modules within the stonekin SDK.
- These instructions apply to all code within the `src` folder of each project.
- Follow these patterns consistently to maintain architectural coherence across the codebase.

## Organization Principles

Think of each folder as a cohesive module with clear boundaries. The architecture follows these principles:

- **Root folder**: Contains system-level interfaces and core abstractions
- **Subfolders**: Group related functionality into specialized sub-systems that serve the root system
- **Isolation**: Modules should minimize direct dependencies on sibling modules
- **Hierarchy**: Child modules may depend on parent abstractions via prelude files

### File Naming Conventions

- Use kebab-case for folder names: `user-management`, `data-store`
- Use camelCase for TypeScript files: `userService.ts`, `dataMapper.ts`
- Prefix explanation files with underscore: `_EXPLAIN.md`, `_DEBT.md`
- Use lowercase for standard files: `index.ts`, `prelude.ts`, `readme.md`

## Common Files

The following files define the public and internal interfaces published by a folder:

### Interface Files (Import Restrictions Apply)

- **`index.ts`** - The public interface for the folder
  - Exports facilities for use by parent folders and external consumers
  - The root `index.ts` serves as the primary module barrel file
  - Should export concrete implementations, services, and utilities
  - **Cannot be imported by files within the same folder**

- **`prelude.ts`** - The internal interface for the folder
  - Exports facilities for use by child folders only
  - Must include its parent's `prelude.ts` using: `export * from '../prelude.ts'`
  - Should export only types, interfaces, constants, and abstract declarations
  - **Cannot be imported by files within the same folder**

### Implementation Files

- **`data.ts`** - Pure data definitions and constants
  - No external dependencies except `../prelude.ts`
  - Contains enums, constant objects, default configurations
  - Should be side-effect free

- **`type.ts`** - Type definitions and interfaces
  - May import from `./data.ts`, `../prelude.ts`, and external type libraries
  - Contains TypeScript interfaces, type aliases, and generic constraints
  - Should not contain runtime code

- **`api.ts`** - Service interfaces and contracts
  - May import from `./type.ts` and `../prelude.ts`
  - Defines abstract classes, interface contracts, and API specifications
  - Should not contain concrete implementations

- **`di.ts`** - Dependency injection utilities
  - Factory functions and builder patterns for module components
  - Configuration objects and initialization helpers
  - Should simplify component construction and wiring

- **`util.ts`** - Utility functions and helpers
  - Pure functions that operate on the module's types
  - Helper methods that simplify common operations
  - Should be stateless and testable

### Import Hierarchy Rules

Files may only import from:

- Their own folder's implementation files (data.ts, type.ts, api.ts, util.ts, di.ts)
- Parent folder's prelude.ts
- External npm packages
- Node.js built-in modules

Files may NOT import from:

- Their own folder's index.ts or prelude.ts
- Sibling folders' files
- Child folders' files

## Error Handling Patterns

- Use Result types or explicit error returns rather than throwing exceptions
- Define error types in `type.ts` files
- Implement error mapping utilities in `util.ts` files
- Document error conditions in function comments

## Testing Considerations

- Each module should be testable in isolation
- Mock external dependencies through interfaces defined in `api.ts`
- Use dependency injection patterns from `di.ts` to facilitate testing
- Test files should be co-located with source files

> [!IMPORTANT]
> Do not create files proactively simply because this document lists them.
> Introduce these files organically when functionality requires them.
> Build exports incrementally as features are developed.

## Documentation Requirements

The stonekin SDK embeds documentation as close to the applicable code as possible.

### Required Documentation - module level

- **`README.md`** - Module overview and purpose
  - Brief description of the module's responsibility
  - Build instructions and dependencies
  - Basic usage examples
  - Links to detailed documentation

### Optional Documentation - module level

- **`USAGE.md`** - Practical examples and patterns
  - Integration patterns with other modules
  - Best practices and anti-patterns

### Optional Documentation Files - subfolder level

- **`_EXPLAIN.md`** - Conceptual overview for developers
  - Explains the "why" behind architectural decisions
  - Describes concepts, patterns, and abstractions used
  - Target audience: technical developers unfamiliar with the codebase

- **`_DEBT.md`** - Technical debt and maintenance notes
  - Known issues and improvement opportunities
  - Planned refactoring efforts
  - Target audience: maintainers and AI assistants

### Code Documentation Standards

- All exported functions, classes, and interfaces must have TSDoc comments
- Include `@param`, `@returns`, and `@throws` annotations where applicable
- Document complex algorithms with inline comments
- Use `@example` tags for non-trivial usage patterns

## Module Communication

Generally, subsystems should avoid direct coupling. Use these patterns:

- **Shared abstractions**: Define interfaces in parent modules' prelude files
- **Event systems**: Use pub/sub patterns for loose coupling
- **Dependency injection**: Use DI containers to manage inter-module dependencies
- **Service interfaces**: Define contracts in `api.ts` files for cross-module communication
