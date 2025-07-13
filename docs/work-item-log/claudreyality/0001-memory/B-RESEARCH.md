# MCP Memory Server Research Findings

## Overview

This document contains comprehensive research on MCP (Model Context Protocol) servers that provide memory, storage, or persistence capabilities for working memory systems. Research conducted for evaluation against the Stonekin project rubric.

## Official MCP Memory Servers

### 1. Memory Server (Official)

**Repository:** `modelcontextprotocol/servers/src/memory`  
**Status:** Active  
**Maintainer:** Model Context Protocol (Anthropic)

#### Description

"A basic implementation of persistent memory using a local knowledge graph. This lets Claude remember information about the user across chats."

#### Technical Details

- **Storage Format:** Local knowledge graph with three components:
  - **Entities:** Nodes with unique names, types, and observations
  - **Relations:** Directed connections between entities (stored in active voice)
  - **Observations:** Discrete information strings attached to entities

#### Installation & Setup

- **Docker:** `docker run -i -v claude-memory:/app/dist --rm mcp/memory`
- **NPX:** `npx -y @modelcontextprotocol/server-memory`
- **Dependencies:** No external dependencies, local file-based storage

#### API/Tools Provided

- `create_entities` - Add new entities to the graph
- `create_relations` - Create directed relationships
- `add_observations` - Attach information to entities
- `delete_entities` - Remove entities
- `delete_observations` - Remove observations
- `delete_relations` - Remove relationships
- `read_graph` - Read entire graph structure
- `search_nodes` - Search for specific nodes
- `open_nodes` - Access node details

#### Configuration

- **Environment Variables:** `MEMORY_FILE_PATH` for custom memory file location
- **System Prompt:** Configurable for memory management strategy

#### Limitations & Characteristics

- Silently skips non-existent nodes/relations
- Requires manual memory update strategy
- MIT License (free use, modification, distribution)
- Performance characteristics not detailed in documentation
- Local-first approach, no external service dependencies

### 2. Filesystem Server (Official)

**Repository:** `modelcontextprotocol/servers/src/filesystem`  
**Status:** Active  
**Maintainer:** Model Context Protocol (Anthropic)

#### Filesystem Description

"Secure file operations with configurable access controls" - enables controlled file system interactions for storage applications.

#### Filesystem Technical Details

- **Purpose:** Standardized file system operations with robust access controls
- **Security Model:** Strict directory access restrictions, prevents operations outside allowed directories
- **Access Control Methods:**
  - Command-line arguments specifying allowed directories
  - Dynamic "Roots" protocol for runtime directory updates

#### Filesystem Installation & Setup

- **Docker:** Mount directories to `/projects`
- **NPX:** Direct command-line installation
- **VS Code:** Configuration through settings or `.vscode/mcp.json`
- **Dependencies:** Node.js runtime, no external services

#### Supported Operations

- Read/write files
- Create/list/delete directories
- Move files and directories
- Search files
- Retrieve file metadata
- Edit files with advanced pattern matching
- Simultaneous multi-file operations

#### Filesystem Configuration

- JSON-based settings
- Read-only directory mounting support
- Sandboxed directory configurations
- Requires at least one allowed directory to operate

#### Filesystem Limitations & Characteristics

- UTF-8 encoding for file operations
- Requires explicit directory permissions
- Depends on client capabilities for dynamic root updates
- MIT License
- Performance: Supports streaming and batch file processing

## Third-Party MCP Memory Servers

### 3. Memory-Plus

**Repository:** `github.com/Yuchen20/Memory-Plus`  
**Status:** Active  
**Maintainer:** Yuchen20

#### Memory-Plus Description

"A lightweight, local RAG memory store for MCP agents. Easily record, retrieve, update, delete, and visualize persistent 'memories' across sessionsperfect for developers working with multiple AI coders."

#### Memory-Plus Technical Details

- **Storage:** Local RAG (Retrieval-Augmented Generation) memory store
- **Visualization:** Interactive graph clusters revealing relationships
- **Versioning:** Memory versioning system (since v0.1.4) keeps old versions for full history

#### Memory-Plus Key Features

- Record Memories: Save user data, ideas, and important context
- Retrieve Memories: Search by keywords or topics over past entries
- Recent Memories: Fetch the last N items quickly
- Update Memories: Append or modify existing entries seamlessly
- Delete Memories: Remove unwanted entries (since v0.1.2)
- File Import: Ingest documents directly into memory (since v0.1.2)
- Memory for Memories: Uses resources to teach AI when to recall interactions (since v0.1.4)

#### Memory-Plus Installation & Setup

- **Requirements:**
  - Google API Key (from Google AI Studio, set as `GOOGLE_API_KEY`)
  - UV Runtime (required to serve the MCP plugin)
- **Cost:** Entirely free (uses only Gemini Embedding API)
- **Setup:** Add MCP JSON configuration to your MCP setup

#### Performance & Characteristics

- Lightweight design optimized for developer workflows
- Works across multiple AI coding assistants (Windsurf, Cursor, Copilot)
- Persistent context that survives across different sessions and tools
- First Place winner at Infosys Cambridge AI Centre Hackathon

#### Dependencies

- Google API for embeddings (free tier)
- UV Runtime
- Local storage

### 4. Basic Memory

**Repository:** `github.com/basicmachines-co/basic-memory`  
**Status:** Active  
**Maintainer:** Basic Machines

#### Basic Memory Description

"Local-first knowledge management system that builds a semantic graph from Markdown files, enabling persistent memory across conversations with LLMs."

#### Basic Memory Technical Details

- **Storage Format:** Standard Markdown files with semantic patterns
- **Location:** Typically stored in `~/basic-memory` directory
- **Structure:** Structured Markdown files that both humans and LLMs can read and write
- **Integration:** Direct integration with Obsidian.md and standard editors

#### Basic Memory Key Features

- **Local-first Storage:** All data stored as Markdown files on your computer
- **Bi-directional Access:** Both humans and LLMs can read and write
- **Semantic Graph:** Traversable knowledge graph using Markdown linking
- **Real-time Updates:** Data stored in real time during conversations
- **Standard Format:** Compatible with existing Markdown tools and editors

#### How It Works

- LLMs can build rich context from the knowledge graph
- Follow relations between topics to create semantic understanding
- Natural conversations with LLMs by reading and writing Markdown files
- Explore content and gain project insights
- Continue conversations with full context

#### Dependencies & Setup

- Local file system access
- Compatible with existing Markdown editors (Obsidian, etc.)
- No external API dependencies
- Self-contained system

#### Characteristics

- Human-readable and editable
- Version control friendly (Markdown/Git integration)
- Zero external dependencies
- Full data ownership and control

### 5. Neo4j Memory Servers

**Repository:** `github.com/neo4j-contrib/mcp-neo4j` (and various implementations)  
**Status:** Active  
**Maintainer:** Neo4j Community & Various

#### Neo4j Description

"Store and retrieve entities and relationships from your personal knowledge graph in a local or remote Neo4j instance. Access that information over different sessions, conversations, clients."

#### Neo4j Technical Details

- **Database:** Neo4j graph database (local or remote)
- **Storage:** Entities with observations and relationships
- **Query Language:** Cypher queries for complex graph operations

#### Neo4j Key Features

- **Database Operations:**
  - Get database schema
  - Execute Cypher queries (READ, CREATE, UPDATE, DELETE)
  - Create nodes with labels and properties
  - Create relationships with type, direction, and properties
- **Search Capabilities:**
  - Fuzzy search functionality
  - Precise matching capabilities
  - Subgraph retrieval
- **Enhanced Versions:** Superior graph querying, performance, and scalability

#### Neo4j Installation & Setup

- **Docker Support:** Straightforward deployment
- **Local Installation:** Neo4j database required
- **Remote Option:** Can connect to Neo4j Aura or remote instances
- **Dependencies:** Neo4j database (local or cloud)

#### Integration

- Works with Claude Desktop, VS Code, Cursor, Windsurf
- Natural language to Cypher query translation
- MCP protocol integration for AI assistants

#### Neo4j Performance & Characteristics

- Handles complex knowledge graph applications
- Real-time data access for AI assistants
- Scalable for large datasets
- Professional graph database capabilities

#### Use Cases

- Long conversations that turn into comprehensive knowledge graphs
- Complex relationship mapping
- Professional knowledge management
- AI assistants requiring vast data access

### 6. GraphRAG MCP Server

**Repository:** `github.com/rileylemm/graphrag_mcp`  
**Status:** Active  
**Maintainer:** Riley Lemm

#### GraphRAG Description

"A Model Context Protocol server for querying a hybrid graph and vector database system, combining Neo4j and Qdrant for powerful semantic and graph-based document retrieval."

#### GraphRAG Technical Details

- **Architecture:** Hybrid Neo4j graph database + Qdrant vector database
- **Search Types:** Semantic document search, graph-based context expansion, hybrid search
- **Data Storage:** Pre-indexed document data in both graph and vector formats
- **Language:** Python 3.12+

#### GraphRAG Key Features

- **Semantic Search:** Vector-based document retrieval via Qdrant
- **Graph Expansion:** Context expansion through Neo4j relationships
- **Hybrid Search:** Combined vector similarity and graph traversal
- **Flexible Configuration:** Configurable search limits and category filters
- **Advanced Retrieval:** Context-aware information extraction

#### GraphRAG Installation & Setup

- **Requirements:**
  - Python 3.12+
  - Neo4j database (localhost:7687)
  - Qdrant vector database (localhost:6333)
  - UV package manager
- **Setup Steps:**
  1. Clone repository
  2. Install dependencies: `uv install`
  3. Configure `.env` with database credentials
  4. Run server: `uv run main.py`
- **Dependencies:** Neo4j, Qdrant, MCP SDK, pre-indexed data

#### GraphRAG Performance & Characteristics

- Combines strengths of graph and vector databases
- Efficient context expansion through relationships
- Designed for advanced document retrieval workflows
- Open-source with MIT license
- Compatible with Claude, Cursor, and other MCP clients

#### GraphRAG Use Cases

- Advanced document retrieval and research
- Contextual information extraction
- Knowledge management with complex relationships
- Research workflows requiring both semantic and structural search

### 7. Qdrant MCP Server

**Repository:** `github.com/qdrant/mcp-server-qdrant` (Official)  
**Status:** Active  
**Maintainer:** Qdrant Team

#### Qdrant Description

"An official Qdrant Model Context Protocol server implementation that acts as a semantic memory layer on top of the Qdrant vector search engine."

#### Qdrant Technical Details

- **Database:** Qdrant vector search engine
- **Storage:** Vector embeddings with semantic search capabilities
- **Embedding Model:** sentence-transformers/all-MiniLM-L6-v2 (default, FastEmbed models supported)
- **Architecture:** Semantic memory layer for contextual information storage

#### Qdrant Key Features

- **Semantic Memory:** Store and retrieve memories using vector similarity
- **Embedding Support:** Multiple embedding models via FastEmbed
- **Persistent Storage:** POSIX-compatible file system requirements
- **Scalable Search:** Efficient vector similarity search
- **Context Management:** Designed for AI application memory needs

#### Qdrant Installation & Setup

- **Docker Deployment:**

  ```bash
  docker run -p 6333:6333 -v $(pwd)/data:/qdrant/storage qdrant/qdrant
  ```

- **MCP Server Installation:**
  - `uvx mcp-server-qdrant`
  - `uvx mcp-server-qdrant --transport sse`
- **Requirements:**
  - Docker/Podman or container runtime
  - QDRANT_URL environment variable
  - OPENAI_API_KEY for embeddings
- **Storage:** Block-level access required, SSD/NVMe recommended

#### Qdrant Configuration

- **Environment Variables:**
  - `QDRANT_LOCAL_PATH`: Database path
  - `COLLECTION_NAME`: Collection identifier
  - `EMBEDDING_MODEL`: Model for encoding memories
- **Networking:** Ports 6333 and 6334 for client connections
- **Development Mode:** MCP dev command with browser inspector

#### Qdrant Performance & Characteristics

- High-performance vector similarity search
- Rust-based engine for speed and reliability
- Persistent storage with data management
- Local deployment with Docker Compose support
- Semantic search optimized for AI applications

#### Qdrant Use Cases

- Semantic memory for AI applications
- Code snippet and documentation storage
- Contextual information retrieval
- Long-term memory extension for complex tasks

### 8. Elasticsearch MCP Server

**Repository:** `github.com/elastic/mcp-server-elasticsearch` (Official)  
**Status:** Active (Experimental)  
**Maintainer:** Elastic

#### Elasticsearch Description

"Official Elasticsearch MCP server that connects conversational AI with Elasticsearch data, enabling natural language interactions with your search indices."

#### Elasticsearch Technical Details

- **Search Engine:** Full Elasticsearch platform with advanced query DSL
- **Vector Support:** Semantic search via `semantic_text` mapping
- **Language:** TypeScript/JavaScript
- **Architecture:** Enterprise-grade search and analytics platform

#### Elasticsearch Key Features

- **Full-text Search:** Advanced query DSL with highlighting and profiling
- **Semantic Search:** Vector search with `semantic_text` mapping
- **Index Management:** Complete index and mapping analysis
- **Natural Language Queries:** Conversational interface to complex data
- **Enterprise Features:** Aggregations, analytics, and advanced search capabilities

#### Elasticsearch Installation & Setup

- **Docker Deployment:**

  ```json
  {
    "mcpServers": {
      "elasticsearch-mcp-server": {
        "command": "docker",
        "args": ["run", "--rm", "-i", "-e", "ES_URL", "-e", "ES_API_KEY", 
                "docker.elastic.co/mcp/elasticsearch", "stdio"]
      }
    }
  }
  ```

- **NPX Installation:**

  ```json
  {
    "mcpServers": {
      "elasticsearch-mcp-server": {
        "command": "npx",
        "args": ["-y", "@elastic/mcp-server-elasticsearch"]
      }
    }
  }
  ```

- **Requirements:** Elasticsearch instance, authentication credentials

#### Elasticsearch Configuration

- **Environment Variables:**
  - `ES_URL`: Elasticsearch instance URL (required)
  - `ES_API_KEY`: Authentication key
  - `ES_USERNAME/PASSWORD`: Alternative authentication
  - `ES_CA_CERT`: Custom SSL/TLS certificate
  - `ES_SSL_SKIP_VERIFY`: Optional SSL verification bypass

#### Elasticsearch API/Tools

- `list_indices`: List all available Elasticsearch indices
- `get_mappings`: Get field mappings for specific index
- `search`: Perform Elasticsearch search with query DSL
- `get_shards`: Get shard information for indices

#### Elasticsearch Security Features

- Fine-grained access control with dedicated API keys
- Index-level access restrictions
- SSL/TLS certificate support
- Minimal permission recommendations

#### Elasticsearch Performance & Characteristics

- Enterprise-grade search performance
- Mature and battle-tested platform
- Advanced text analysis and aggregation capabilities
- Experimental MCP implementation (not production-ready)
- Apache-2.0 License

#### Elasticsearch Use Cases

- Enterprise search and analytics
- Complex document retrieval with advanced queries
- Data exploration and index investigation
- Large-scale text analysis and semantic search
- Business intelligence and reporting workflows

## Analysis Framework for Evaluation

### Rubric Criteria Mapping

For Opus analysis, each server should be evaluated against these weighted criteria:

#### High Priority (3x Weight)

1. **Setup Simplicity** - Installation and configuration complexity
2. **Local/Self-hosted** - Local performance vs external service requirements
3. **Integration** - Compatibility with Claude Code, Node.js, existing toolchain

#### Medium Priority (2x Weight)

1. **Performance** - Read/write speed, memory usage, startup time
2. **Data Format** - Human readability, version control compatibility
3. **Maintenance** - Backup, updates, troubleshooting overhead

#### Standard Priority (1x Weight)

1. **Query Capabilities** - Search, filtering, relationship handling
2. **Scalability** - Dataset growth handling
3. **Security** - Data protection and access control

### Final Evaluation Set: 8 MCP Servers

The research covers a comprehensive range of approaches from lightweight to enterprise-grade solutions:

**Lightweight → Heavyweight Spectrum:**

1. **Basic Memory** - Markdown files with semantic patterns
2. **Memory Server (Official)** - Simple knowledge graph, fully local
3. **Filesystem Server (Official)** - Secure file operations
4. **Memory-Plus** - Local RAG with visualization and versioning
5. **Qdrant** - High-performance vector database
6. **Neo4j Memory** - Professional graph database
7. **GraphRAG** - Hybrid Neo4j + Qdrant system
8. **Elasticsearch** - Enterprise search and analytics platform

### Key Evaluation Considerations

#### Stonekin Project Alignment

- **Repository as Truth:** Memory should complement, not replace repository
- **Session Continuity:** Must persist between Claude Code sessions
- **Git Integration:** Version control compatibility
- **Node.js Ecosystem:** npm integration preferences
- **No Lock-in:** Easy migration paths
- **Time to First Commit:** Setup impact on development velocity

#### Deployment Models

- **Local-first:** Fully local operation (Memory, Basic Memory, Filesystem)
- **Local with External APIs:** Local storage with external enhancements (Memory-Plus)
- **Database-backed:** Local or remote database requirements (Neo4j)
- **Cloud/External:** Requires external services (archived PostgreSQL, Redis)

#### Data Formats

- **Knowledge Graph:** Structured entities and relations (Memory, Neo4j)
- **Markdown Files:** Human-readable, git-friendly (Basic Memory)
- **RAG Store:** Vector embeddings with retrieval (Memory-Plus)
- **File System:** Direct file operations (Filesystem)

#### Integration Complexity

- **Zero Setup:** Built-in functionality (Memory, Filesystem)
- **Simple Setup:** npm install or basic configuration (Memory-Plus, Basic Memory)
- **Database Setup:** Requires database installation/configuration (Neo4j)
- **API Dependencies:** Requires external API keys (Memory-Plus Google API)

### Missing Information Requiring N/A Scoring

Some servers lack detailed documentation in the following areas:

- Specific performance benchmarks
- Detailed security implementations
- Exact scalability limits
- Precise maintenance requirements

These gaps should be noted in the evaluation and scored as N/A where data cannot be determined.
