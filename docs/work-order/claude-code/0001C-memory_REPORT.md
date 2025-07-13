# MCP Working Memory System Evaluation Report

## Executive Summary

After systematic evaluation of 8 MCP servers against a weighted rubric emphasizing simplicity, local deployment, and toolchain integration, the analysis reveals a clear winner for the Stonekin project:

### Top Recommendations

1. **Basic Memory (92.5%) - Excellent Fit** P
   - Markdown-based semantic graph system
   - Perfect alignment with Stonekin's git-first, local-first philosophy
   - Zero external dependencies, human-readable format

2. **Memory Server Official (77.3%) - Acceptable Fit**
   - Simple knowledge graph with official MCP support
   - Good integration but binary data format limits git compatibility

3. **Filesystem Server Official (71.4%) - Acceptable Fit**
   - Solid foundation with excellent security model
   - Limited query capabilities require additional tooling

## Methodology

Each server was evaluated against 9 weighted criteria using a 1-5 scoring scale:

- **High Priority (3x weight):** Setup Simplicity, Local/Self-hosted, Integration
- **Medium Priority (2x weight):** Performance, Data Format, Maintenance
- **Standard Priority (1x weight):** Query Capabilities, Scalability, Security

Maximum possible score: 105 points. N/A scores excluded from calculations.

## Detailed Server Evaluations

### 1. Basic Memory - 92.5% (Excellent Fit)

| Criteria | Score | Weight | Weighted | Rationale |
|----------|-------|--------|----------|-----------|
| Setup Simplicity | 5 | 3x | 15 | "Self-contained system", "Compatible with existing Markdown editors", "No external API dependencies" |
| Local/Self-hosted | 5 | 3x | 15 | "Local-first knowledge management", "All data stored as Markdown files on your computer", "Zero external dependencies" |
| Integration | 5 | 3x | 15 | "Direct integration with Obsidian.md and standard editors", perfect git compatibility |
| Performance | N/A | 2x | - | No specific performance benchmarks provided |
| Data Format | 5 | 2x | 10 | "Standard Markdown files", "Human-readable and editable", "Version control friendly" |
| Maintenance | 5 | 2x | 10 | "Zero external dependencies", "Self-contained system" |
| Query Capabilities | 3 | 1x | 3 | "Semantic Graph: Traversable knowledge graph using Markdown linking" - basic but functional |
| Scalability | 3 | 1x | 3 | Markdown files scale reasonably but not to enterprise levels |
| Security | 3 | 1x | 3 | File system level protection only |

**Total: 74/80 = 92.5%**

**Strengths:** Perfect alignment with Stonekin values, excellent git integration, human-readable format, zero setup complexity
**Limitations:** Basic query capabilities, limited scalability for very large datasets

### 2. Memory Server Official - 77.3% (Acceptable Fit)

| Criteria | Score | Weight | Weighted | Rationale |
|----------|-------|--------|----------|-----------|
| Setup Simplicity | 4 | 3x | 12 | Single Docker or NPX command, "No external dependencies" |
| Local/Self-hosted | 5 | 3x | 15 | "Local-first approach, no external service dependencies" |
| Integration | 4 | 3x | 12 | Official MCP server, designed for Claude compatibility |
| Performance | N/A | 2x | - | "Performance characteristics not detailed in documentation" |
| Data Format | 2 | 2x | 4 | Knowledge graph format, not human-readable |
| Maintenance | 4 | 2x | 8 | MIT license, relatively simple system |
| Query Capabilities | 4 | 1x | 4 | "search_nodes", "read_graph", good relationship handling |
| Scalability | N/A | 1x | - | No scalability information provided |
| Security | 3 | 1x | 3 | Local file-based storage, basic security |

**Total: 58/75 = 77.3%**

**Strengths:** Official support, good local operation, comprehensive API
**Limitations:** Binary format limits git integration, unknown performance characteristics

### 3. Filesystem Server Official - 71.4% (Acceptable Fit)

| Criteria | Score | Weight | Weighted | Rationale |
|----------|-------|--------|----------|-----------|
| Setup Simplicity | 4 | 3x | 12 | "NPX: Direct command-line installation", "Node.js runtime, no external services" |
| Local/Self-hosted | 5 | 3x | 15 | "No external services", fully local operation |
| Integration | 5 | 3x | 15 | Official MCP server, Node.js-based, excellent toolchain fit |
| Performance | 4 | 2x | 8 | "Supports streaming and batch file processing" |
| Data Format | 4 | 2x | 8 | Works with actual files, format depends on usage |
| Maintenance | 4 | 2x | 8 | File system operations, minimal overhead |
| Query Capabilities | 2 | 1x | 2 | "Search files" but basic file system search only |
| Scalability | 3 | 1x | 3 | File system scalability limitations |
| Security | 4 | 1x | 4 | "Strict directory access restrictions", "Configurable access controls" |

**Total: 75/105 = 71.4%**

**Strengths:** Excellent integration, strong security model, official support
**Limitations:** Limited query capabilities, requires building memory features on top

### 4. Memory-Plus - 61.0% (Poor Fit)

| Criteria | Score | Weight | Weighted | Rationale |
|----------|-------|--------|----------|-----------|
| Setup Simplicity | 3 | 3x | 9 | Requires Google API key and UV Runtime setup |
| Local/Self-hosted | 4 | 3x | 12 | Local storage but depends on Google API for embeddings |
| Integration | 4 | 3x | 12 | "Works across multiple AI coding assistants" |
| Performance | 4 | 2x | 8 | "Lightweight design optimized for developer workflows" |
| Data Format | 3 | 2x | 6 | RAG store format, not purely human-readable |
| Maintenance | 3 | 2x | 6 | Google API dependency adds complexity |
| Query Capabilities | 4 | 1x | 4 | "Search by keywords or topics", good semantic search |
| Scalability | 4 | 1x | 4 | Vector store should scale reasonably |
| Security | 3 | 1x | 3 | Google API dependency, local storage |

**Total: 64/105 = 61.0%**

**Strengths:** Good developer focus, semantic search capabilities
**Limitations:** External API dependency violates local-first principle

### 5. Qdrant MCP Server - 59.0% (Poor Fit)

| Criteria | Score | Weight | Weighted | Rationale |
|----------|-------|--------|----------|-----------|
| Setup Simplicity | 3 | 3x | 9 | Docker deployment required, multiple environment variables |
| Local/Self-hosted | 4 | 3x | 12 | Local deployment possible but requires OpenAI API |
| Integration | 4 | 3x | 12 | Official Qdrant server, good MCP support |
| Performance | 4 | 2x | 8 | "High-performance", "Rust-based engine for speed" |
| Data Format | 2 | 2x | 4 | Vector database, binary format |
| Maintenance | 3 | 2x | 6 | Database maintenance required |
| Query Capabilities | 4 | 1x | 4 | "Semantic search", vector similarity search |
| Scalability | 4 | 1x | 4 | Designed for scale |
| Security | 3 | 1x | 3 | Database-level security |

**Total: 62/105 = 59.0%**

**Strengths:** High performance, excellent scalability
**Limitations:** Complex setup, binary format, external API dependency

### 6. Neo4j Memory - 59.0% (Poor Fit)

| Criteria | Score | Weight | Weighted | Rationale |
|----------|-------|--------|----------|-----------|
| Setup Simplicity | 2 | 3x | 6 | Requires Neo4j database installation |
| Local/Self-hosted | 4 | 3x | 12 | Can run Neo4j locally |
| Integration | 4 | 3x | 12 | "Works with Claude Desktop, VS Code, Cursor, Windsurf" |
| Performance | 4 | 2x | 8 | "Real-time data access", professional database |
| Data Format | 2 | 2x | 4 | Neo4j database format, not human-readable |
| Maintenance | 3 | 2x | 6 | Database maintenance overhead |
| Query Capabilities | 5 | 1x | 5 | "Cypher queries", "Complex graph operations" |
| Scalability | 5 | 1x | 5 | "Scalable for large datasets" |
| Security | 4 | 1x | 4 | Professional database security |

**Total: 62/105 = 59.0%**

**Strengths:** Excellent query capabilities, professional scalability
**Limitations:** Complex database setup, binary format, maintenance overhead

### 7. Elasticsearch MCP Server - 53.3% (Not Recommended)

| Criteria | Score | Weight | Weighted | Rationale |
|----------|-------|--------|----------|-----------|
| Setup Simplicity | 2 | 3x | 6 | "Requires Elasticsearch instance", complex setup |
| Local/Self-hosted | 3 | 3x | 9 | Can run locally but heavy infrastructure requirement |
| Integration | 3 | 3x | 9 | "Experimental, not production-ready" |
| Performance | 5 | 2x | 10 | "Enterprise-grade search performance" |
| Data Format | 2 | 2x | 4 | Elasticsearch indices, binary format |
| Maintenance | 2 | 2x | 4 | Enterprise software maintenance overhead |
| Query Capabilities | 5 | 1x | 5 | "Advanced query DSL", "Full-text search" |
| Scalability | 5 | 1x | 5 | "Large-scale text analysis", enterprise-grade |
| Security | 4 | 1x | 4 | "Fine-grained access control", SSL/TLS support |

**Total: 56/105 = 53.3%**

**Strengths:** Exceptional query capabilities and scalability
**Limitations:** Heavy infrastructure, complex setup, experimental MCP implementation

### 8. GraphRAG MCP Server - 47.6% (Not Recommended)

| Criteria | Score | Weight | Weighted | Rationale |
|----------|-------|--------|----------|-----------|
| Setup Simplicity | 1 | 3x | 3 | Requires Python 3.12+, Neo4j, and Qdrant databases |
| Local/Self-hosted | 4 | 3x | 12 | Both databases can run locally |
| Integration | 2 | 3x | 6 | Python-based, requires significant configuration |
| Performance | 4 | 2x | 8 | "Combines strengths of graph and vector databases" |
| Data Format | 2 | 2x | 4 | Database storage, not human-readable |
| Maintenance | 2 | 2x | 4 | Two databases to maintain |
| Query Capabilities | 5 | 1x | 5 | "Hybrid search", excellent semantic and graph capabilities |
| Scalability | 4 | 1x | 4 | Professional database backing |
| Security | 4 | 1x | 4 | Database-level security from both systems |

**Total: 50/105 = 47.6%**

**Strengths:** Cutting-edge hybrid search capabilities
**Limitations:** Extremely complex setup, multiple database dependencies, Python requirement

## Comparison Matrix

| Server | Setup | Local | Integration | Performance | Format | Maintenance | Query | Scale | Security | **Total** |
|--------|-------|-------|-------------|-------------|--------|-------------|-------|-------|----------|-----------|
| Basic Memory | 5 | 5 | 5 | N/A | 5 | 5 | 3 | 3 | 3 | **92.5%** |
| Memory Server | 4 | 5 | 4 | N/A | 2 | 4 | 4 | N/A | 3 | **77.3%** |
| Filesystem Server | 4 | 5 | 5 | 4 | 4 | 4 | 2 | 3 | 4 | **71.4%** |
| Memory-Plus | 3 | 4 | 4 | 4 | 3 | 3 | 4 | 4 | 3 | **61.0%** |
| Qdrant | 3 | 4 | 4 | 4 | 2 | 3 | 4 | 4 | 3 | **59.0%** |
| Neo4j Memory | 2 | 4 | 4 | 4 | 2 | 3 | 5 | 5 | 4 | **59.0%** |
| Elasticsearch | 2 | 3 | 3 | 5 | 2 | 2 | 5 | 5 | 4 | **53.3%** |
| GraphRAG | 1 | 4 | 2 | 4 | 2 | 2 | 5 | 4 | 4 | **47.6%** |

## Implementation Recommendations

### Primary Recommendation: Basic Memory

**Implementation Path:**

1. Install Basic Memory MCP server
2. Configure memory storage in `~/basic-memory` directory
3. Establish workflows for creating and maintaining memories as Markdown files
4. Integrate with existing Obsidian/Markdown tooling
5. Define memory categories and linking patterns for Stonekin project context

**Why Basic Memory Excels:**

- **Perfect Philosophy Alignment:** Markdown files integrate seamlessly with git workflow
- **Zero Friction Setup:** No databases, APIs, or complex configuration
- **Human-Readable Memory:** Team members can read, edit, and understand memories directly
- **Version Control Native:** Git diffs show exactly what memory changes occurred
- **Editor Integration:** Works with existing VSCode, Obsidian, and other Markdown tools

### Secondary Option: Memory Server Official

**When to Consider:** If structured knowledge graph capabilities are required and binary format is acceptable.

**Implementation Path:**

1. Install via NPX: `npx -y @modelcontextprotocol/server-memory`
2. Configure memory file path for project
3. Design entity and relationship schema for Stonekin context
4. Establish memory update patterns

### Tertiary Option: Filesystem Server + Custom Memory Layer

**When to Consider:** If building a custom memory solution on a secure foundation is preferred.

**Implementation Path:**

1. Install Filesystem Server for secure file operations
2. Build custom memory management layer on top
3. Leverage strong security model for access control
4. Implement custom query and indexing capabilities

## Risk Analysis

### Basic Memory Risks

- **Limited Query Performance:** May struggle with very large memory sets
- **Manual Organization:** Requires discipline in memory organization and linking
- **Mitigation:** Implement naming conventions and directory structure guidelines

### Memory Server Risks

- **Binary Format:** Difficult to debug memory issues or view git diffs
- **Unknown Performance:** No documented performance characteristics
- **Mitigation:** Develop export utilities for human-readable memory inspection

### General Risks

- **Adoption Complexity:** Even simple systems require workflow establishment
- **Memory Quality:** All systems depend on quality memory creation practices
- **Migration Paths:** Plan for potential future migration between systems

## Future Considerations & Growth Path

### Tiered Memory Architecture Strategy

When Basic Memory reaches its limits, a tiered approach allows gradual complexity addition while preserving the benefits of the simple foundation:

#### Tier 1: Basic Memory (Current Choice)

- **Strengths:** Git integration, human readability, zero friction
- **Limits:** Query performance, relationship traversal, large dataset handling

#### Tier 2: Runtime Knowledge Graph Enhancement

**Recommended: Memory Server Official (77.3%)**

- **Why:** Provides knowledge graph capabilities while maintaining relative simplicity
- **Integration:** Can index Basic Memory's Markdown files into graph structure
- **Benefits:**
  - Adds entity/relationship queries without losing Markdown foundation
  - Official MCP support ensures compatibility
  - Runtime graph can be regenerated from Markdown truth source
- **Use Case:** When you need to query "show me all decisions related to API design" across hundreds of memory files

#### Tier 3: Professional Scale Solution  

**Recommended: Neo4j Memory (59.0%)**

- **Why:** Best-in-class graph operations when scale demands it
- **Integration:** Import structured memories from Tiers 1 & 2
- **Benefits:**
  - Cypher queries for complex relationship analysis
  - Proven scalability to millions of nodes
  - Professional tooling and monitoring
- **Use Case:** When memory system becomes mission-critical infrastructure requiring advanced queries, performance guarantees, and operational tooling

### Migration Path Design

```text
Basic Memory → Memory Server → Neo4j
     ↓              ↓             ↓
[Markdown]  → [Graph Index] → [Full Graph DB]
              (from Markdown)   (migration tools)
```

This architecture ensures:

1. **No Lock-in:** Markdown files remain the source of truth
2. **Gradual Complexity:** Add tiers only when benefits justify overhead
3. **Preservation of Values:** Git-first approach maintained even with advanced tiers

### Known Unknowns for docs/

- **Query Performance Threshold:** At what memory volume does Basic Memory search become inadequate?
- **Relationship Complexity:** When do implicit Markdown links need explicit graph modeling?
- **Team Scale:** How many team members before runtime indexing becomes essential?
- **Migration Effort:** Actual effort to implement Tier 2 indexing of Markdown memories
- **Hybrid Overhead:** Performance and maintenance cost of running multiple tiers

## Conclusion

Basic Memory emerges as the clear winner with a 92.5% score, representing an excellent fit for the Stonekin project. Its perfect alignment with git-first, local-first, and simplicity principles makes it the optimal choice for working memory implementation.

The evaluation reveals that simpler, more transparent solutions significantly outperform complex database-backed systems when weighted against Stonekin's core values. While advanced systems offer superior query capabilities, they fail to deliver proportional value given their setup complexity and integration overhead.

**Recommendation:** Proceed with Basic Memory implementation as the foundation for Stonekin's working memory system, with confidence that it provides the best balance of functionality, simplicity, and project alignment.
