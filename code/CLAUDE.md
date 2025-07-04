# Coding Rules - Consolidated

> [!IMPORTANT]
> These rules were distilled from ADRs by Claude Sonnet 4. In an event
> of a conflict between this file and an ADR, the ADR governs.

## Architecture Foundations

### Module Hierarchy & File Organization

**Module Structure:**

- MUST: Organize modules around domain concepts rather than technical layers
- MUST: Use hierarchical parent-child module structure where each folder represents a cohesive module
- MUST: Use single-word lowercase folder names: `agent/`, `prompt/`, `tools/`
- MUST: Every folder MUST contain exactly two interface files: `index.ts` (public) and `prelude.ts` (internal)
- MUST: Child folder `prelude.ts` files MUST re-export parent prelude: `export * from '../prelude.ts'`
- MUST: Ensure each folder has a single, well-defined responsibility
- MUST NOT: Create sibling modules with direct dependencies on each other
- MUST NOT: Allow parent modules to import from child modules
- MUST NOT: Use multi-word folder names with hyphens or underscores
- MUST NOT: Create service layers that separate domain logic from domain data

**File Types & Naming:**

- MUST: Use kebab-case for TypeScript implementation files: `agent-processor.ts`, `conversation-manager.ts`
- MUST: Use lowercase for standard files: `index.ts`, `prelude.ts`, `readme.md`
- MUST: Place data types in `type.ts` files within each module
- MUST: Place behavioral contracts in `api.ts` files within each module  
- MUST: Place constant objects and enum-like definitions in `data.ts` files within each module
- MUST: Place error constants in `data.ts` files, error types in `type.ts` files
- MUST: Create curried factory functions in `di.ts` files
- MUST NOT: Mix data types and behavioral interfaces in the same file
- MUST NOT: Use camelCase, PascalCase, or snake_case for regular implementation files
- MUST NOT: Use service-pattern naming (e.g., `agent-service.ts`, `message-manager.ts`)

**Documentation Strategy:**

- MUST: Every NPM module must have README.md following NPM README guidelines
- MUST: Complex agent subsystems requiring domain context must have `_DOMAIN.md` files
- MUST: All exported functions and types require TSDoc comments with domain-specific language
- MUST: Use TSDoc with `@param`, `@returns`, `@throws`, and `@example` sections

### Import Boundaries & Module Communication

**Allowed Import Patterns:**

- ALLOWED: Implementation files within same folder (`./data.ts`, `./type.ts`)
- ALLOWED: Parent folder's prelude only (`../prelude.ts`)
- ALLOWED: Sibling folders through their public interface (`./sibling`)
- ALLOWED: External npm packages and Node.js built-in modules
- REQUIRED: `import { Option } from "@stokekin/ts"` for optional value handling
- REQUIRED: Factory functions must import their target type definitions

**Forbidden Import Patterns:**

- FORBIDDEN: Own folder's `index.ts` or `prelude.ts` (prevents circular dependencies)
- FORBIDDEN: Nested folder access (`./child/impl.ts`, `../../parent/file.ts`)
- FORBIDDEN: Direct imports between sibling modules
- FORBIDDEN: Parent modules importing from child modules
- FORBIDDEN: Importing exception-throwing libraries for recoverable domain errors
- FORBIDDEN: `import { SomeEnum } from './enums'` (TypeScript enums are banned)
- FORBIDDEN: Cross-domain service dependencies that bypass domain boundaries

**Cross-Module Communication:**

- PREFERRED: Cross-module communication via parent abstractions through prelude files
- REQUIRED: Types MUST flow from parent to child, never upward or sideways
- REQUIRED: All data crossing `index.ts` and `prelude.ts` interfaces MUST be immutable
- REQUIRED: Use factory functions as creation boundaries between modules
- REQUIRED: Define behavioral contracts through interfaces
- REQUIRED: Use function composition for dependency management
- FORBIDDEN: Framework-based dependency injection systems

### Module Boundary Immutability

**Interface Requirements:**

- REQUIRED: All function parameters crossing module boundaries MUST use `readonly` arrays and objects
- REQUIRED: All function return values at module boundaries MUST return immutable references
- STRUCTURE: `readonly T[]` instead of `T[]` for arrays at boundaries
- REQUIRED: All concrete implementations and utilities MUST be exported through `index.ts`
- REQUIRED: Export types from `type.ts`, interfaces from `api.ts`

**Internal Implementation Flexibility:**

- ALLOWED: Internal functions MAY use mutable data structures for performance
- ALLOWED: Third-party integration MAY require mutable state management
- REQUIRED: Internal mutation MUST NOT leak through module interfaces

### Stream Primitives & RxJS Integration

**Core Decision:**

- REQUIRED: RxJS is the official stream abstraction for the Stonekin SDK
- REQUIRED: All perception, memory, action, and supervision MUST flow through RxJS primitives
- REQUIRED: Custom behaviors and memory sinks SHOULD be built as implementations of RxJS interfaces

**RxJS Primitive Mapping:**

- REQUIRED: Use `Observable` for perceptions
- REQUIRED: Use `SubjectLike` for memory and tool interfaces  
- REQUIRED: Use `Observer` for side-effect endpoints
- REQUIRED: Use `SchedulerLike` for time and priority contexts

**Design Principles:**

- REQUIRED: **Semantic Grouping:** Observers and Subjects MUST be grouped into interfaces for routing, injection, and introspection
- REQUIRED: **Generic Operators:** Operators SHOULD work generically, accepting lambdas and configuration just like native RxJS operators
- REQUIRED: Stream-based architectures MUST integrate with existing Result/Option patterns for error handling
- REQUIRED: RxJS streams crossing module boundaries MUST maintain immutability constraints

## Type System Design

### Types vs Interfaces Strategy

**Data Structures (use `type`):**

- REQUIRED: Define domain data as readonly types (e.g., `type AgentData = { readonly id: string; }`)
- REQUIRED: Import domain data types with `import type` syntax
- REQUIRED: Use `type` definitions for pure data abstractions and structure modeling
- REQUIRED: Data structures must remain JSON-serializable when using `type`
- REQUIRED: Use readonly properties for immutable data structures
- REQUIRED: Use discriminated unions with `type` for state modeling
- REQUIRED: Use opaque types via type-fest for primitive wrapping
- AVOID: Using interfaces for pure data structures without behavior
- AVOID: Mixing data and behavior in type definitions

**Behavioral Contracts (use `interface`):**

- REQUIRED: Define pure behavior contracts using generic parameters: `interface Executable<T = object> extends T`
- REQUIRED: Use generic parameters to operate on data without directly extending data types
- REQUIRED: Use `interface` declarations for functional abstractions and behavioral contracts
- REQUIRED: Define all external dependencies as interfaces
- STRUCTURE: Interface methods should follow established error handling patterns
- AVOID: Using types for behavioral contracts and service definitions
- AVOID: Interfaces that directly extend data types without generic parameterization
- FORBIDDEN: Import concrete implementations across module boundaries for dependencies

**Import Constraints:**

- ALLOWED: Interfaces can reference types for parameter/return structures
- ALLOWED: Types can reference constant objects for discriminated unions
- ALLOWED: Behavioral interfaces importing domain data types as generic constraints
- FORBIDDEN: Types importing behavioral interfaces
- FORBIDDEN: Data types importing or extending behavioral interfaces
- PREFERRED: Keep data and behavioral concerns in separate files

### Opaque Types & Domain Primitives

**Core Implementation:**

- REQUIRED: Use type-fest's Opaque type to create compile-time distinctions between semantically different values
- STRUCTURE: Use format: `export type AgentId = Opaque<string, 'AgentId'>;`
- REQUIRED: Create constructor functions for type-safe creation
- REQUIRED: Every opaque type MUST have a corresponding constructor function
- REQUIRED: Import Opaque type from type-fest: `import type { Opaque } from 'type-fest';`
- CONSTRAINTS: Opaque types must serialize as their underlying primitives for JSON compatibility

**Usage Patterns:**

- REQUIRED: Function parameters accepting domain concepts MUST use opaque types, not primitives
- FORBIDDEN: Direct assignment of primitives to opaque types: `loadAgent('agent-123')`
- REQUIRED: Use constructor functions: `loadAgent(createAgentId('agent-123'))`
- FORBIDDEN: Mixing semantically different opaque types even if they share underlying types
- LOCATION: Define opaque types in `type.ts` files

### Enum-like Patterns & Discriminated Unions

**Constant Object Definition:**

- REQUIRED: Use constant objects (not TypeScript enums) with `as const` for enum-like values
- REQUIRED: Follow pattern: `const Name = { KEY: 'value' } as const; type NameType = typeof Name[keyof typeof Name];`
- REQUIRED: Define enum-like types using `typeof EnumLike[keyof typeof EnumLike]` pattern
- CONSTRAINTS: Enum-like types expand to literal union types for perfect type safety
- CONSTRAINTS: All data types must be readonly and serializable
- AVOID: Plain objects without `as const` (loses literal types)
- AVOID: Mixed value types within single enum-like object
- LOCATION: Define enum-like constants in `data.ts` files

**Discriminated Union Patterns:**

- REQUIRED: Use discriminated unions with enum-likes as discriminants to model mutually exclusive states
- STRUCTURE: Use discriminated union format with typeof enum-like references
- REQUIRED: Each union member MUST include state-specific properties relevant only to that state
- AVOID: Optional properties for state-specific data that could exist in wrong states
- REQUIRED: Use exhaustive switch statements for state handling
- REQUIRED: TypeScript MUST enforce all cases are handled through discriminated union checking

**Comprehensive Example:**

```typescript
// In data.ts
export const AgentStatus = { 
  IDLE: 'idle', 
  PROCESSING: 'processing', 
  COMPLETE: 'complete',
  FAILED: 'failed'
} as const;

export const ErrorCode = {
  AGENT_NOT_FOUND: 'agent_not_found',
  AGENT_CONFIG_INVALID: 'agent_config_invalid',
  CONVERSATION_ERROR: 'conversation_error'
} as const;

// In type.ts
export type AgentStatusType = typeof AgentStatus[keyof typeof AgentStatus];
export type ErrorCodeType = typeof ErrorCode[keyof typeof ErrorCode];

export type AgentId = Opaque<string, 'AgentId'>;

export type AgentState = 
  | { readonly status: typeof AgentStatus.IDLE; readonly lastActivity: Date }
  | { readonly status: typeof AgentStatus.PROCESSING; readonly progress: number }
  | { readonly status: typeof AgentStatus.COMPLETE; readonly result: string }
  | { readonly status: typeof AgentStatus.FAILED; readonly error: string };

export type AgentConfigError = {
  readonly code: typeof ErrorCode.AGENT_CONFIG_INVALID;
  readonly field: string;
  readonly message: string;
};
```

### Function vs Class Decision Matrix

**Use Functions (Preferred):**

- REQUIRED: Stateless operations MUST use pure functions instead of classes
- REQUIRED: Data validation, transformation, and computation MUST use functions
- STRUCTURE: `function functionName(params): Result<T, E>` pattern required

**Use Classes (Limited Cases):**

- ALLOWED: Only when encapsulating truly stateful, mutable concerns
- REQUIRED: Session management, connection pools, and stateful resources MUST use classes
- CONSTRAINTS: Classes MUST expose immutable interfaces at module boundaries
- STRUCTURE: Private mutable state with immutable public interfaces
- REQUIRED: State transitions MUST be explicit and controlled

## Error Handling Strategy

### Result & Option Patterns

**Core Type Definitions:**

- STRUCTURE: Use generic Result type: `type Result<T, E = Error> = [T, undefined] | [undefined, E]`
- REQUIRED: Use tuple-based Result pattern `[value, undefined] | [undefined, error]` for operations that can fail
- REQUIRED: Use tuple-based Option pattern `[]` (None) or `[value]` (Some) for optional values
- REQUIRED: Functions that can fail MUST return `Result<T, E>` type
- REQUIRED: Functions with optional values MUST return `Option<T>` type

**Usage Syntax:**

- REQUIRED: Use destructuring assignment for Result/Option handling: `const [value, error] = result`
- REQUIRED: Check error conditions before using success values
- REQUIRED: Success results MUST use format `[value, undefined]`
- REQUIRED: Error results MUST use format `[undefined, error]`
- REQUIRED: Optional values MUST use `[]` for None, `[value]` for Some

**Composition & Integration:**

- REQUIRED: Results MUST integrate with discriminated union state patterns
- REQUIRED: Use array methods (map, flatMap, filter) for Result/Option composition
- PREFERRED: Combine Results with state modeling for UI components

### Exception Rules & Error Types

**Exception Guidelines:**

- REQUIRED: Exceptions are ONLY acceptable for programmer errors or unrecoverable system failures
- REQUIRED: Use exceptions for assertion failures and missing configuration files
- FORBIDDEN: Exceptions for business logic errors (insufficient funds, validation failures, etc.)

**Error Type Structure:**

- STRUCTURE: Define error codes using const objects: `export const ErrorCode = { ... } as const`
- STRUCTURE: Define error types as discriminated unions with readonly `code` property
- CONSTRAINTS: Domain methods must return Result types for error handling
- CONSTRAINTS: Error objects MUST be readonly
- CONSTRAINTS: Error objects MUST include a `code` property for categorization
- NAMING: Error types MUST end with "Error" suffix (e.g., `AgentConfigError`)
- EXPORTS: Export error types from domain modules alongside success types

**Comprehensive Error Handling Example:**

```typescript
// Result pattern for operations that can fail
async function loadAgentConfig(id: AgentId): Promise<Result<AgentConfig, string>> {
  try {
    const response = await fetch(`/api/agents/${id}/config`);
    if (!response.ok) {
      return [undefined, `HTTP ${response.status}: ${response.statusText}`];
    }
    const config = await response.json();
    return [config, undefined];
  } catch (error) {
    return [undefined, `Network error: ${error.message}`];
  }
}

// State pattern integration
type UserState = 
  | { readonly status: 'loading' }
  | { readonly status: 'success'; readonly user: User }
  | { readonly status: 'error'; readonly error: string };

function handleUserFetch(result: Result<User, string>): UserState {
  const [user, error] = result;
  if (error) return { status: 'error', error };
  return { status: 'success', user };
}
```

## Domain Modeling Patterns

### Progressive Enhancement & Object Creation

**Progressive Enhancement Pattern:**

- REQUIRED: Use `Object.assign()` to progressively add behavior to data objects
- STRUCTURE: `Object.assign(data, { methodName() { /* implementation */ } }) as EnhancedType`
- REQUIRED: Type assertion to preserve type safety after enhancement
- REQUIRED: Create enhancement functions: `function makeExecutable<T extends AgentData>(data: T): Executable<T>`
- REQUIRED: Return enhanced object with proper generic typing

**Factory Function Rules:**

- REQUIRED: Create domain objects through factory functions: `function createAgent(config: AgentConfig): Agent`
- REQUIRED: Factory functions must return fully-formed domain objects with behavior attached
- PARAMETERS: Accept focused configuration data, enhance with behavior internally
- REQUIRED: Compose multiple enhancements in factory functions
- REQUIRED: Domain-specific methods added in final composition step

**Behavioral Interface Composition:**

- REQUIRED: Compose multiple behavioral interfaces: `interface Agent extends Executable<AgentData>, Configurable<AgentData>`
- STRUCTURE: Each interface must provide specific domain capabilities
- REQUIRED: Use readonly parameters to prevent mutation: `canHandle(requestType: string): boolean`

### Dependency Injection & Factory Patterns

**Currying & Dependency Management:**

- REQUIRED: Accept dependencies as individual curried parameters
- REQUIRED: Order parameters from most stable to least stable (dependencies before configuration)
- FORBIDDEN: Group dependencies into single objects
- REQUIRED: Use JavaScript's native `bind` method for partial application
- REQUIRED: Apply dependencies from left to right in stability order
- PREFERRED: Create intermediate partially-applied functions for reuse

**Dependency Resolution:**

- REQUIRED: Perform all dependency wiring at application startup
- REQUIRED: Keep dependency resolution explicit and traceable
- FORBIDDEN: Runtime dependency resolution or service location
- FORBIDDEN: External DI frameworks or containers

**Domain Object Example:**

```typescript
// Factory function with progressive enhancement
function createAgent(data: AgentData): Agent {
  let agent = { ...data };
  agent = makeExecutable(agent);
  agent = makeConfigurable(agent);
  return Object.assign(agent, { 
    async execute(request: AgentRequest): Promise<Result<AgentResponse, string>> {
      return executeAgentRequest(this, request);
    }
  }) as Agent;
}

// Pure behavior interface with generics
interface Executable<T = object> extends T {
  execute(request: AgentRequest): Promise<Result<AgentResponse, string>>;
  canHandle(requestType: string): boolean;
}

// Curried factory with dependencies
function createAgentWithDependencies(
  db: Database, 
  logger: Logger, 
  config: AgentConfig
): Agent {
  // Dependencies applied before configuration
  return createAgent(config);
}
```

## Implementation Guidelines

### Function Design & Signatures

**Pure Function Requirements:**

- REQUIRED: Functions SHOULD have no side effects when possible
- REQUIRED: Functions MUST have explicit inputs and outputs
- STRUCTURE: `function name(input: T): Result<U, E>` preferred over void functions
- AVOID: Void functions with side effects unless absolutely necessary
- REQUIRED: Use explicit parameter passing instead of accessing external state
- PREFERRED: Multiple specific parameters over large configuration objects

**Parameter & Return Patterns:**

- PARAMETERS: Use parent prelude types for function parameters that cross module boundaries
- PARAMETERS: Use types for data parameter structures
- PARAMETERS: Accept enum-like union types (e.g., `AgentStatusType`) rather than raw enum-like objects
- RETURNS: Export concrete return types through module's own prelude for child consumption
- RETURNS: Return types for data, `Promise<type>` for async data operations
- RETURNS: Return enum-like values directly, not the container object

**Function Composition:**

- REQUIRED: Build complex operations through function composition
- STRUCTURE: `type Processor<T, U> = (input: T) => Result<U, E>`
- PATTERN: Use compose functions to chain processors with short-circuit error handling
- REQUIREMENTS: Function composition MUST not create excessive intermediate objects

### Naming Conventions

**Domain-Focused Naming:**

- REQUIRED: Use domain terminology that describes what things represent or what functions accomplish
- REQUIRED: Focus on intention-revealing names that explain purpose
- REQUIRED: Name functions by their domain purpose, not technical role
- REQUIRED: Use consistent domain language that reflects the module's problem space
- REQUIRED: Code should read like the problem space rather than technical abstractions
- REQUIRED: Favor composition of domain terms over generic technical terms

**Specific Naming Rules:**

- **Factory Functions:** Use `createX` pattern for domain object factories: `createAgent`, `createMessage`
- **Enhancement Functions:** Use `makeX` pattern for behavior enhancement: `makeExecutable`, `makeConfigurable`
- **Behavioral Interfaces:** Use capability-based names: `Executable`, `Configurable`, `Communicable`
- **Interface Methods:** Should be verbs (execute, validate, process)
- **Type Names:** Use domain nouns that represent data concepts
- **Error Types:** MUST end with "Error" suffix (e.g., `AgentConfigError`)
- **Constants:** Use descriptive suffixes like `Status`, `Level`, `Priority` for enum-like object names

**Forbidden Naming Patterns:**

- AVOID: Technical implementation details in names
- AVOID: Hungarian notation or implementation-focused prefixes
- AVOID: Generic suffixes like 'Manager', 'Handler', 'Service'
- AVOID: 'I' prefix on interface names
- AVOID: Generic names like 'DataObject', 'StringArray'
- AVOID: Redundant 'Type' suffix

### Performance & Testing Considerations

**Performance Optimizations:**

- ALLOWED: Mutable arrays and objects for internal processing
- PATTERN: Build results using mutable structures, return immutable references
- ALLOWED: Mutable state for caches, connection pools, and external API clients
- REQUIRED: Wrap mutable third-party APIs with immutable interfaces
- CONSTRAINTS: Enum-likes have zero runtime overhead (compile-time only constructs)
- CONSTRAINTS: Opaque types MUST have zero runtime cost - they exist only at the type level
- REQUIREMENTS: Perfect JSON serialization without transformation overhead

**Testing Requirements:**

- MUST TEST: Domain objects in isolation without complex mocking
- MUST TEST: All pure functions MUST have unit tests with explicit input/output verification
- MUST TEST: Classes with mutable state MUST test state transitions
- MUST TEST: Each module through its public `index.ts` interface only
- MUST TEST: All modules using mock implementations of their dependencies
- MOCKING: Use partial application with test doubles
- STRUCTURE: Test doubles must implement the same interfaces as production dependencies

## Reference Materials

### Anti-patterns to Avoid

**Type System Anti-patterns:**

```typescript
// ❌ Don't use interfaces for pure data
interface UserData {  // Should be a type
  name: string;
  email: string;
}

// ❌ Don't use types for behavioral contracts
type EventHandler = {  // Should be an interface
  handle(event: Event): void;
  canHandle(event: Event): boolean;
};

// ❌ Don't use TypeScript enums (banned)
enum Status {
  PENDING = 'pending',
  COMPLETE = 'complete'
}

// ❌ Don't use plain objects without `as const`
const Status = {
  PENDING: 'pending',
  COMPLETE: 'complete'
}; // TypeScript infers string type, loses literal types

// ❌ Don't use optional properties for exclusive states
type AgentState = {
  status: string;
  lastActivity?: Date;       // Could exist with wrong status
  requestId?: string;        // Invalid combinations possible  
  result?: string;
};
```

**Implementation Anti-patterns:**

```typescript
// ❌ Unnecessary class for stateless operations
class PromptValidator {
  validatePrompt(prompt: string): bool { /* no side effects */ }
}

// ❌ Void functions with unclear side effects
function processData(data: MutableData[]): void {
  // Where do results go? How are errors handled?
}

// ❌ Mutable data crossing module boundaries
export function processItems(items: Item[]): Item[] {
  // Should be: readonly Item[] -> readonly Item[]
}

// ❌ External DI frameworks or containers
@injectable()
class UserService {
  constructor(@inject('UserRepository') private repo: UserRepository) {}
}

// ❌ Dependency grouping objects
function createAgent(dependencies: { db: Database; logger: Logger; cache: Cache }) {
  // Should be individual curried parameters
}
```

**Naming Anti-patterns:**

```typescript
// ❌ FORBIDDEN: Generic function names
function getByCapability(capability: string): Tool | null; // Use 'toolForCapability'
function retrieveTemplate(taskType: string): PromptTemplate; // Use 'promptForConversation'
function createAgentInstance(config: AgentConfig): Agent; // Use 'createAgent'

// ❌ FORBIDDEN: Technical implementation details
function httpGetUserPreferences(): Promise<UserConfig>; // Hide transport details
function parseJsonAndCreateTool(data: string): Tool; // Hide parsing details
function executeQueryAndMap<T>(sql: string): Promise<T[]>; // Hide database details

// ❌ FORBIDDEN: Generic interface names
interface Manager { /* Too generic */ }
interface Handler { /* Too generic */ }
interface IToolExecutor { /* No 'I' prefix */ }
```

### Required Dependencies

**External Dependencies:**

- REQUIRED: `type-fest` package for `Opaque` type utility
- CONSTRAINT: Must use type-fest's Opaque implementation, not custom branded types
- REQUIRED: `import { Option } from "@stokekin/ts"` for optional value handling
- REQUIRED: `rxjs` package for stream primitives and reactive programming
- CONSTRAINT: SHOULD use RxJS for all perception, memory, action, and supervision flows

### TSDoc Example Template

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
```
