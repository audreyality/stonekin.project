# Markdownlint Configuration Analysis

## Problem Statement

The current markdownlint setup is causing friction in AI workflows by enforcing stylistic preferences ("pet peeves") rather than focusing on meaningful quality issues. This creates interruptions and manual correction overhead when AI generates markdown content.

## Current Configuration Analysis

### Existing Setup

- **Tool**: `markdownlint-cli2` v0.18.1 with markdownlint v0.38.0
- **Config locations**: Multiple `.markdownlint.json` files across project
- **Current status**: 0 errors across 38 markdown files

### Root Configuration (`.markdownlint.json`)

```json
{
    "line-length": false,
    "no-inline-html": {
        "allowed_elements": ["span"]
    }
}
```

### Multiple Config Files Found

- `/Users/audreyality/Code/stonekin.project/.markdownlint.json` (main)
- `docs/work-order/claude-code/.markdownlint.json` (disabled: `"default": false`)
- `memory/.markdownlint.json` (disabled: `"default": false`)

## Markdownlint Rules Categories

### Auto-Fixable Rules (24 rules)

These can be automatically corrected with `--fix`:
- **MD009**: Trailing spaces
- **MD010**: Hard tabs
- **MD012**: Multiple consecutive blank lines
- **MD014**: Dollar signs used before commands without showing output
- **MD018**: No space after hash on atx style heading
- **MD019**: Multiple spaces after hash on atx style heading
- **MD020**: No space inside hashes on closed atx style heading
- **MD021**: Multiple spaces inside hashes on closed atx style heading
- **MD022**: Headings should be surrounded by blank lines
- **MD023**: Headings must start at the beginning of the line
- **MD027**: Multiple spaces after blockquote symbol
- **MD030**: Spaces after list markers
- **MD037**: Spaces inside emphasis markers
- **MD038**: Spaces inside code span elements
- **MD039**: Spaces inside link text
- **MD047**: Files should end with a single newline character

### Quality-Critical Rules (Manual Review Needed)

These identify structural/accessibility issues:
- **MD001**: Heading levels should only increment by one level at a time
- **MD002**: First heading should be a top level heading
- **MD003**: Heading style consistency
- **MD011**: Reversed link syntax
- **MD034**: Bare URL used (impacts accessibility)
- **MD040**: Fenced code blocks should have a language specified

### Stylistic "Pet Peeve" Rules

These are preferences that often conflict with natural writing:
- **MD026**: Trailing punctuation in headings
- **MD025**: Multiple top-level headings in the same document
- **MD033**: Inline HTML (already customized)
- **MD013**: Line length (already disabled)

## AI Workflow Impact Assessment

### High-Friction Rules for AI Content

1. **MD026**: AI naturally includes punctuation in headings
2. **MD012**: AI often uses multiple blank lines for visual separation
3. **MD025**: AI may create multiple H1s in long documents
4. **MD047**: AI doesn't always end files with newlines

### Low-Impact Auto-Fix Rules

These improve consistency without manual intervention:
- Spacing normalization (MD009, MD010, MD027, MD030)
- Heading formatting (MD018, MD019, MD020, MD021, MD022, MD023)
- Code formatting (MD037, MD038, MD039)

## Recommendations

### Option 1: Auto-Fix Only Configuration (Recommended)

Configure markdownlint to only check auto-fixable rules and run `--fix` automatically:

**Benefits:**
- Maintains formatting consistency
- Zero manual intervention required
- No workflow interruption
- Documents remain well-structured

**Implementation:**
```json
{
    "default": false,
    "MD009": true,
    "MD010": true,
    "MD012": true,
    "MD014": true,
    "MD018": true,
    "MD019": true,
    "MD020": true,
    "MD021": true,
    "MD022": true,
    "MD023": true,
    "MD027": true,
    "MD030": true,
    "MD037": true,
    "MD038": true,
    "MD039": true,
    "MD047": true
}
```

### Option 2: Minimal Quality-Only Configuration

Keep only rules that catch serious structural issues:
```json
{
    "default": false,
    "MD001": true,
    "MD002": true,
    "MD011": true,
    "MD034": true,
    "MD040": true
}
```

### Option 3: Complete Removal

Remove markdownlint entirely and rely on manual review.

## Configuration Cleanup Needed

Multiple configuration files create inconsistency:
1. Consolidate to single root configuration
2. Remove subdirectory configs that disable linting
3. Update `.markdownlintignore` to handle exceptions

## Conclusion

**Recommendation**: Implement Option 1 (Auto-Fix Only) to balance quality maintenance with AI workflow efficiency. This approach eliminates friction while preserving document consistency.
