# ADR-0006: Error Handling Strategy with Tuples

## Status

**Current:** Active

## Problem

Traditional exception-based error handling creates unpredictable control flow and makes error conditions invisible in function signatures. Exceptions force developers to remember which functions might throw, leading to unhandled errors and runtime crashes. Additionally, exceptions don't compose well with our functional programming patterns and make it difficult to chain operations safely.

Without a consistent error handling strategy, different modules might use incompatible approaches (some throwing exceptions, others returning null, others using custom Result types), creating integration complexity and inconsistent error experiences.

## Decision

We will **avoid throwing exceptions** for recoverable errors and instead use **tuple-based Result and Option types** that make error handling explicit in function signatures. This approach uses native JavaScript arrays as containers, providing a uniform pattern that works naturally with existing array methods and destructuring syntax.

**Option Pattern** (1-tuple): Represents optional values

- `[]` represents None/empty
- `[value]` represents Some/present

**Result Pattern** (2-tuple): Represents operations that can succeed or fail

- `[value, undefined]` represents success
- `[undefined, error]` represents failure

## Why This Approach

- **Explicit error handling**: Function signatures show exactly what can go wrong
- **Composable**: Array methods like `map`, `flatMap`, and `filter` work naturally
- **Zero dependencies**: Uses native JavaScript arrays, no external libraries
- **Familiar syntax**: Destructuring and array methods are well-known patterns
- **Type-safe**: TypeScript can enforce proper error handling at compile time
- **Progressive enhancement**: Start simple, add utilities as needed
- **Functional alignment**: Fits perfectly with our preference for functional patterns

## Implementation

### Option Pattern for Optional Values

```typescript
import { Option } from "@stokekin/ts"
// Creating options
function findAgent(id: string): Option<Agent> {
  const agent = agents.find(a => a.id === id);
  return agent ? [agent] : [];
}

// Using options with destructuring
const [agent] = findAgent('agent-123');

// Simple truthy checks
if (agent) {
  console.log(`Found: ${agent.id}`);
} else {
  console.log('Agent not found');
}
```

### Result Pattern for Error Handling

```typescript
// Basic Result type
type Result<T, E = Error> = [T, undefined] | [undefined, E];

// Creating results
async function loadAgentConfig(id: string): Promise<Result<AgentConfig, string>> {
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

// Using results with destructuring
const [agentConfig, error] = await loadAgentConfig('agent-123');
if (error) {
  console.error('Failed to load agent config:', error);
  return;
}

// agentConfig is guaranteed to be defined here
processAgentConfig(agentConfig);
```

### File Organization

Following our module patterns:

```typescript
// data.ts - error constants
export const ErrorCode = {
  AGENT_NOT_FOUND: 'agent_not_found',
  AGENT_CONFIG_INVALID: 'agent_config_invalid',
  CONVERSATION_ERROR: 'conversation_error',
  TOOL_EXECUTION_FAILED: 'tool_execution_failed'
} as const;

// type.ts - result and option types
export type ErrorCodeType = typeof ErrorCode[keyof typeof ErrorCode];

export type AgentConfigError = {
  readonly code: typeof ErrorCode.AGENT_CONFIG_INVALID;
  readonly field: string;
  readonly message: string;
};

export type AgentNotFoundError = {
  readonly code: typeof ErrorCode.AGENT_NOT_FOUND;
  readonly agentId: string;
};

export type AgentError = AgentConfigError | AgentNotFoundError;
```

### When to Use Exceptions

Exceptions are **only acceptable** for fatal errors that indicate programmer mistakes or unrecoverable system failures:

```typescript
// ✅ Acceptable: Programming errors
function assertNonNull<T>(value: T | null | undefined, message: string): T {
  if (value == null) {
    throw new Error(`Assertion failed: ${message}`);
  }
  return value;
}

// ✅ Acceptable: Configuration errors
function loadConfig(path: string): Config {
  if (!fs.existsSync(path)) {
    throw new Error(`Configuration file not found: ${path}`);
  }
  // ... load config
}

// ❌ Avoid: Recoverable domain logic errors
function withdrawMoney(account: Account, amount: number): void {
  if (account.balance < amount) {
    throw new Error('Insufficient funds'); // Should return Result instead
  }
}
```

### Anti-Patterns to Avoid

```typescript
// ❌ Don't mix exceptions with Results
function badMixedApproach(id: string): Result<User, string> {
  if (!id) {
    throw new Error('ID required'); // Inconsistent!
  }
  return findUser(id);
}

// ❌ Don't use null/undefined for error states
function badNullPattern(id: string): User | null {
  // Doesn't tell us WHY it failed
  return users.find(u => u.id === id) || null;
}

// ❌ Don't use boolean success flags
function badBooleanPattern(id: string): { success: boolean; user?: User; error?: string } {
  // Verbose and error-prone
}

// ❌ Don't ignore error handling
const [user, error] = await fetchUser('123');
// Missing error check - user might be undefined!
console.log(user.name);
```

### Integration with Discriminated Unions

Results work naturally with our discriminated union patterns:

```typescript
// Combining Results with state modeling
type UserState = 
  | { readonly status: 'loading' }
  | { readonly status: 'success'; readonly user: User }
  | { readonly status: 'error'; readonly error: string };

function handleUserFetch(result: Result<User, string>): UserState {
  const [user, error] = result;
  if (error) {
    return { status: 'error', error };
  }
  return { status: 'success', user };
}
```

## Consequences

- **Benefits:**
  - Explicit error handling prevents forgotten error cases
  - Composable patterns that work with existing JavaScript/TypeScript
  - Low runtime overhead compared to try/catch
  - Type-safe error handling with compile-time guarantees
  - Natural integration with functional programming patterns
  - Progressive enhancement from simple arrays to rich utilities

- **Trade-offs:**
  - More verbose than simple exception throwing
  - Requires discipline to consistently check error conditions
  - Different from traditional JavaScript error handling patterns
  - May require education for developers unfamiliar with functional error handling

## Related ADRs

- **Builds on:** [ADR-0004: Type System Strategy] (Results use types for data modeling)
- **Builds on:** [ADR-0005: Enum Alternatives] (Error codes use enum-likes)
- **See also:** [ADR-0007: Functional Programming Style] (Error handling fits functional patterns)

---

## Decision Log

| Date | Status | Author | Notes |
|------|--------|--------|-------|
| 2025-06-13 | Draft | Claude | Initial version with tuple-based Result/Option patterns |
| 2025-06-13 | Draft | Audrey | Extracted types and utilities |
| 2025-06-13 | Active | Audrey | Reviewed and approved |
