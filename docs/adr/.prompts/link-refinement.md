# ADR Link refinement prompt flow

- This workflow asks Claude to link an ADR into all of our other ADRs.
- For use with Claude Sonnet 4.

```markdown
# ADR Linking Analysis Task

Analyze the linking structure within **${ADR Number}** and generate a comprehensive linking improvement report.

## Report Requirements

Your report must include:

1. **Linking State Summary**: Current state of internal and external links
2. **Recommended Actions**: Specific, actionable improvements prioritized by impact
3. **Cross-Reference Analysis**: Identify missing bidirectional ADR references

## Specific Areas to Examine

- **Missing ADR Cross-References**:
  - Forward references this ADR should link to
  - Backward references from other ADRs that should link here
  - Related decisions that should be cross-linked

- **Navigation Links**:
  - Sequential navigation (← Previous | Next → links)
  - Missing or broken navigation chains

- **External Documentation Links**:
  - Technical references (MDN, Node.js docs, RFC specifications)
  - Module/library documentation
  - Standards and best practices documentation

## Task Constraints

- **Focus**: Stay strictly on linking analysis - do not fix formatting issues
- **Output**: Generate report only, provide brief status updates in chat
- **Formatting Issues**: If encountered, stop and request linter application
- **Completion**: Stop after report generation and await review

## Workflow

1. Analyze the specified ADR
2. Report status briefly in chat
3. Generate comprehensive linking report
4. Stop and wait for review feedback

Ready to proceed with ${ADR Number}?
```

-----

```markdown
# Apply ADR Linking Recommendations

Implement the specific linking changes recommended in the report for **${ADR Number}**.

## Task Instructions

1. **Follow the Report**: Apply only the changes listed in the "Recommended Actions" section
2. **No Additional Changes**: Do not add links or modifications beyond those specified in the report
3. **Verify Links**: Test that all implemented links work correctly
4. **Status Updates**: Provide brief progress updates in chat

## Completion

- Implement each recommended action from the report
- Report when finished with a summary of changes made

Ready to apply the recommendations from the linking analysis report?
```
