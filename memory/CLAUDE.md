# Memory Folder - Tool-Managed Only

> [!DANGER]
> **STRICTLY PROHIBITED**: All manual interactions with this directory are forbidden.

## Access Policy

**ALLOWED:**
- Basic Memory tool (inside dev container only)
- Automated memory server operations

**FORBIDDEN:**
- Manual file creation or editing
- Reading files directly
- Any human or AI intervention
- Version control operations on contents

## Purpose

This directory contains working knowledge managed exclusively by the Basic Memory tool:
- Frequently referenced information
- API documentation excerpts  
- Early-stage ideas
- Personal context about operators
- Topics unrelated to the Stonekin project

## Memory System Distinction

- **Memory files** (`filename.memory`): Source-controlled configuration context
- **Memory tool** (this folder): Non-source-controlled working knowledge

## Container Requirement

The memory tool is only available inside the dev container. Outside the container, use `_REMEMBER.md` in the `.work/` directory for persistent knowledge.

## Enforcement

This directory is:
- Excluded from markdown linting
- Excluded from git operations via `.gitignore`
- Managed entirely by automated tooling

> [!WARNING]
> Violating these access restrictions may corrupt the memory system or cause data loss.