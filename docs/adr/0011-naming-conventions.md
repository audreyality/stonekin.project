# ADR-0011: Naming Conventions and Domain Language

## Status

**Current:** Active

## Problem

Inconsistent naming conventions across the codebase create confusion and reduce code readability. Without clear guidelines, developers fall back on technical jargon, implementation-focused names, or inconsistent patterns. This is particularly problematic when domain concepts need to be clearly distinguished from their technical implementations.

Poor naming choices also make it harder for LLMs to understand the domain model and generate consistent code that aligns with the problem space rather than just the solution space.

## Decision

We will use **intention-revealing names that describe domain concepts** rather than technical implementation details. All naming should use consistent domain language that reflects the module's problem space.

### Core Principles

- **Domain-first naming**: Use terminology from the module's domain
- **Intention-revealing**: Names should explain what something represents or does
- **Consistent vocabulary**: Use the same terms for the same concepts throughout the codebase
- **Avoid technical prefixes**: No Hungarian notation or implementation-focused prefixes
- **Favor composition**: Build complex names from simple, well-understood domain terms

## Why This Approach

- **Domain alignment**: Code reads like the problem space rather than technical abstractions
- **Reduced cognitive load**: Developers spend less time decoding technical names
- **Better discoverability**: Domain experts can navigate the code using familiar terminology
- **LLM effectiveness**: Clear domain language helps AI understand context and generate appropriate code
- **Maintainability**: Names that reflect purpose are easier to refactor and extend

## Implementation

### Variables and Function Names

Focus on what things represent and what functions accomplish:

```typescript
// ✅ Domain-focused naming
const searchTool = createWebSearchTool(config);
const analysisPrompt = createAnalysisTemplate(domain);

function toolForCapability(capability: string): Tool | null {
  return registry.findByCapability(capability);
}

function promptForTask(taskType: string): PromptTemplate {
  return library.getTemplate(taskType);
}

// ❌ Implementation-focused naming
const searchInstance = createWebSearchTool(config);
const templateObject = createAnalysisTemplate(domain);

function getByCapability(capability: string): Tool | null {
  return registry.findByCapability(capability);
}

function retrieveTemplate(taskType: string): PromptTemplate {
  return library.getTemplate(taskType);
}
```

### Interface Names (Behavioral Contracts)

Use domain verbs and capabilities, avoiding data structure names:

```typescript
// ✅ Behavior-focused interface names
interface ToolExecutor {
  execute(parameters: unknown): Promise<ToolResult>;
  validateParameters(parameters: unknown): boolean;
}

interface PromptRenderer {
  render(context: PromptContext): string;
  validateContext(context: PromptContext): boolean;
}

// ❌ Data-focused or generic interface names
interface PromptInfo { /* Should be a type, not interface */ }
interface Manager { /* Too generic */ }
interface Handler { /* Too generic */ }
```

### Type Names (Data Structures)

Use domain nouns that represent data concepts:

```typescript
// ✅ Domain data type names
type AgentCapability = 'reasoning' | 'search' | 'computation';
type ConversationHistory = readonly Message[];
type ToolResult = {
  readonly success: boolean;
  readonly data: unknown;
  readonly metadata: ToolMetadata;
};

// ❌ Generic or implementation-focused type names
type StringArray = readonly string[]; /* Too generic */
type DataObject = { /* Too generic */ };
type ResultType = { /* Suffix 'Type' is redundant */ };
```

### Constants and Enums Alternatives

Use descriptive domain-specific constant names:

```typescript
// ✅ Domain-meaningful constant names
const AgentState = {
  IDLE: 'idle',
  PROCESSING: 'processing', 
} as const;

const ToolCategory = {
  WEB_SEARCH: 'web-search',
  CALCULATOR: 'calculator',
} as const;

// ❌ Generic or unclear constant names
const State = {
  STATE_1: 'idle',
  STATE_2: 'processing'
} as const;

const Types = {
  SEARCH: 'web-search',
  CALC: 'calculator'
} as const;
```

### Function Names That Avoid Service Patterns

Name functions by their domain purpose, not their technical role:

```typescript
// ✅ Domain purpose naming (avoids service pattern)
function spawnAgent(config: AgentConfig): Agent { /* Creates rich domain object */ }
function enrichPromptWithContext(template: PromptTemplate, context: Context): string { /* Domain operation */ }
function routeToCapableAgent(request: AgentRequest): Agent | null { /* Domain logic */ }

// ❌ Service pattern naming
function createAgentInstance(config: AgentConfig): Agent { /* Generic creation */ }
function processTemplate(template: PromptTemplate, context: Context): string { /* Generic processing */ }
function findAgent(request: AgentRequest): Agent | null { /* Generic finding */ }
```

### Anti-Patterns to Avoid

```typescript
// ❌ Technical prefixes and suffixes
interface IToolExecutor { /* No 'I' prefix */ }
class AbstractPromptFactory { /* No 'Abstract' prefix */ }
class ToolManager { /* Avoid 'Manager' suffix */ }
class PromptHandler { /* Avoid 'Handler' suffix */ }
class AgentService { /* Avoid 'Service' suffix */ }

// ❌ Implementation details in names
function httpGetUserPreferences(): Promise<UserConfig> { /* Hide transport */ }
function parseJsonAndCreateTool(data: string): Tool { /* Hide parsing */ }
function executeQueryAndMap<T>(sql: string): Promise<T[]> { /* Hide database details */ }

// ❌ Abbreviated or cryptic names
const cfg = loadConfig(); /* Use 'config' */ 
function procReq(req: Request): Response { /* Use full words */ }
```

## Consequences

- **Benefits:**
  - Code reads like domain documentation
  - Easier onboarding for developers familiar with the domain
  - Better alignment between problem space and solution space
  - Improved maintainability through self-documenting code
  - Enhanced LLM understanding of domain concepts

- **Trade-offs:**
  - Longer names may increase verbosity
  - Requires domain knowledge to choose appropriate terms
  - May need refactoring when domain understanding evolves

- **Migration:**
  - Update existing code to use domain-focused names during refactoring
  - Prioritize public APIs and interfaces for immediate improvement
  - Use IDE refactoring tools to safely rename symbols across the codebase

## Related ADRs

- **Builds on:** [ADR-0004: Type System Strategy](0004-type-stretegy.md) (Type vs interface naming patterns)
- **Builds on:** [ADR-0008: Domain-Driven Approaches Over Service Patterns](0008-domain-driven-design.md)
- **Builds on:** [ADR-0002: File Naming and Organization Conventions](0002-file-organization.md)

---

## Decision Log

| Date | Status | Author | Notes |
|------|--------|--------|-------|
| 2025-06-14 | Draft | Claude | Initial version focusing on domain-driven naming |
| 2025-06-14 | Active | Audrey | Reviewed and approved with minor changes |
