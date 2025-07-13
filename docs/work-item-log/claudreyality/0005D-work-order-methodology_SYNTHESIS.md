# Evidence-Based Work Order Methodology Synthesis

## Overview

This synthesis combines validated internal practices with external research to create actionable work order methodology guidance. All practices have been validated through both empirical analysis of existing work orders and external industry standards.

## Core Methodology Framework

### 1. Problem-First Initiation

**Practice**: Begin every work order with explicit problem definition
**Evidence**: Work orders [0003][0003a-research] and [0004][0004a-research] showed superior outcomes; validated by Agile methodology and technical documentation standards

**Implementation**:
```markdown
## Problem Statement
- Current situation: [What is happening now]
- Friction points: [What specific issues exist]
- Impact: [Why this matters]
- Success criteria: [How we'll know it's resolved]
```

### 2. Structured Evaluation Framework

**Practice**: Use quantitative rubrics for complex decisions
**Evidence**: Work order [0001][0001a-rubric] demonstrated highest effectiveness; validated by [academic research][0001b-research] and enterprise frameworks

**Implementation Template**:
```markdown
## Evaluation Rubric
| Criterion | Weight | Description | Score (1-5) |
|-----------|--------|-------------|-------------|
| [Criterion 1] | 3x | [What we're measuring] | |
| [Criterion 2] | 2x | [What we're measuring] | |
| [Criterion 3] | 1x | [What we're measuring] | |

Scoring: 5=Excellent, 4=Good, 3=Adequate, 2=Poor, 1=Unacceptable
```

### 3. Systematic Option Analysis

**Practice**: Generate and evaluate multiple alternatives
**Evidence**: All highest-performing work orders compared options; validated by [ADR standards](https://adr.github.io/) and [SADR discipline](https://dl.acm.org/doi/abs/10.1145/1978802.1978812)

**Implementation**:
```markdown
## Options Analysis

### Option 1: [Name]
- Description: [What this approach entails]
- Pros: [Benefits]
- Cons: [Drawbacks]
- Trade-offs: [What we gain/lose]

### Option 2: [Name]
[Same structure]

### Recommendation
Based on evaluation criteria, Option X scores highest because...
```

### 4. Complete Decision Documentation

**Practice**: Maintain comprehensive decision trail from problem through outcome
**Evidence**: Enables knowledge transfer and prevents decision amnesia; validated by [ADR practices](https://www.techtarget.com/searchapparchitecture/tip/4-best-practices-for-creating-architecture-decision-records)

**Required Elements**:
- Context establishing the problem
- Alternatives considered with rationale
- Decision criteria and constraints
- Final decision with justification
- Assumptions and risks
- Status tracking (proposed → accepted → implemented)

### 5. Proximity-Based Context Scoping

**Practice**: Place information at appropriate levels of the knowledge hierarchy
**Evidence**: Optimizes prompt building and context gathering; aligns with information architecture principles

**Scoping Hierarchy**:
- **Immediate context**: Facts relevant to specific endeavor → local file
- **Domain context**: Broadly relevant facts → contextual CLAUDE.md
- **Configuration context**: Specific decisions → file.memory
- **Project context**: Shared knowledge → docs/
- **Working memory**: Runtime/speculative/tangential → basic memory/_SESSION.md/_REMEMBER.md

**Guidelines**:
- Use hyperlinks appropriately, including durable archive URLs
- Scope information as close to the problem as possible
- Enable precise context gathering for prompt building
- Avoid duplication across hierarchy levels

## Enhanced Workflow Integration

### Phase 1: Problem Definition and Planning

1. Create `_SESSION.md` with clear problem statement
2. Assess complexity - does this need systematic evaluation?
3. If complex: Create `_RUBRIC.md` with evaluation criteria
4. Document initial thoughts and approach in session file

### Phase 2: Research and Analysis

1. Create `_RESEARCH.md` for systematic investigation
2. Apply problem-driven methodology:
   - Current state analysis
   - Option generation
   - Evidence gathering
   - Systematic comparison
3. Use rubric scoring if applicable
4. Document findings with self-contained context

### Phase 3: External Validation (When Needed)

1. Create `_PROMPT.md` for external LLM queries
2. Operator executes prompts
3. Integrate results into research
4. Validate internal findings against external sources

### Phase 4: Implementation and Reporting

1. Execute based on research recommendations
2. Document progress in `_SESSION.md`
3. Create `_REPORT.md` with:
   - Work completed
   - Decisions made
   - Outcomes achieved
   - Lessons learned
4. Update `_REMEMBER.md` with persistent knowledge

## Additional Best Practices from External Validation

### Stakeholder Communication

- For high-impact decisions: Communicate early and often
- Document who was consulted and when
- Capture stakeholder concerns and how addressed

### Review and Maintenance

- Schedule periodic review of decisions
- Track actual vs. expected outcomes
- Update documentation when context changes
- Mark deprecated decisions clearly

### Status Lifecycle

Track decision status through lifecycle:
- **Draft**: Under development
- **Proposed**: Ready for review
- **Accepted**: Approved for implementation
- **Implemented**: Completed
- **Deprecated**: No longer valid
- **Superseded**: Replaced by newer decision

### Impact-Based Scaling

Adjust methodology depth based on impact:
- **Low Impact**: Lightweight documentation, single option acceptable
- **Medium Impact**: Multiple options, basic rubric
- **High Impact**: Full methodology, stakeholder involvement, external validation

## Quality Indicators

Work orders demonstrating these characteristics showed highest effectiveness:

1. **Clear Problem Statement**: Establishes context and scope
2. **Systematic Analysis**: Structured approach to investigation
3. **Evidence-Based Decisions**: Supported by research and data
4. **Complete Documentation**: Full decision trail preserved
5. **Actionable Outcomes**: Clear next steps and implementation

## Anti-Patterns to Avoid

Based on analysis, avoid these practices:

1. **Solution-First Thinking**: Jumping to implementation without problem analysis
2. **Single Option Evaluation**: Not considering alternatives
3. **Sparse Documentation**: Assuming context or skipping rationale
4. **Orphaned Decisions**: Not linking decisions to outcomes
5. **External Dependencies**: Requiring multiple documents for basic understanding

## Templates for Common Scenarios

### Simple Implementation Task

```markdown
# _SESSION.md
## Objective
[Clear statement of what needs to be done]

## Approach
[How you plan to accomplish it]

## Progress
- [ ] Step 1
- [ ] Step 2

## Outcome
[What was accomplished]
```

### Complex Decision Requiring Analysis

```markdown
# _RUBRIC.md
[Evaluation framework]

# _RESEARCH.md
## Problem Statement
## Current State Analysis
## Options Evaluation
## Recommendation

# _REPORT.md
## Decision Summary
## Implementation
## Outcomes
## Lessons Learned
```

## Conclusion

This methodology synthesizes proven practices from both internal experience and external validation. Following these patterns increases likelihood of:

- Making well-informed decisions
- Preserving institutional knowledge
- Enabling effective knowledge transfer
- Supporting continuous improvement
- Maintaining project coherence

The methodology scales from simple tasks to complex decisions while maintaining consistency and quality throughout the work order lifecycle.

<!-- Reference Links -->
[0001a-rubric]: ./0001A-memory_RUBRIC.md
[0001b-research]: ./0001B-memory_RESEARCH.md
[0003a-research]: ./0003A-markdownlint_RESEARCH.md
[0004a-research]: ./0004A-documentation-patterns_RESEARCH.md
