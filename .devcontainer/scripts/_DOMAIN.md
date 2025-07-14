# DevContainer Scripts Domain

## Problem Domain

The DevContainer requires comprehensive validation to ensure all components work correctly across different development environments and user configurations. This includes:

1. **Progressive Validation**: Multi-phase validation that builds from basic environment checks to full integration testing
2. **Multi-User Support**: Validation that works correctly for isolated user environments
3. **Container Integration**: Seamless validation both on host and inside containers
4. **MCP Server Validation**: Ensuring Model Context Protocol servers are properly configured and accessible
5. **VSCode Integration**: Validating DevContainer configuration and IDE integration

## Key Constraints

### Environment Detection Complexity

- Scripts must work on both host and container environments
- Different validation requirements for different phases
- User-specific parameterization must be validated

### Multi-User Isolation Requirements

- Each user gets isolated container and memory
- Validation must verify user-specific configuration
- Container naming must be dynamic and user-specific

## Solution Architecture

### Doctor Script Architecture

The project includes a progressive validation framework:

**Symlink Architecture:**
```text
scripts/doctor.sh -> ../.devcontainer/scripts/doctor.sh
```
- **Canonical Location**: `.devcontainer/scripts/doctor.sh`
- **Root Symlink**: `scripts/doctor.sh` for backward compatibility
- **Windows Requirement**: Symlinks must be enabled for proper operation

**Validation Capabilities:**
- **Host Validation**: Docker, Node.js, required files, environment setup
- **Package Management**: npm script validation, package.json syntax, required dev scripts
- **Container Validation**: Environment variables, multi-user configuration, MCP server availability
- **Multi-User Support**: User-specific validation when `CLAUDE_USER` is set
- **Container Integration**: `--include-devcontainer` flag starts and validates inside container
- **Progressive Framework**: Each phase adds validation capabilities incrementally

**Script Organization:**
```text
.devcontainer/scripts/
├── doctor.sh                    # Main validation orchestrator
└── doctor/                      # Container-specific validations
    ├── environment.sh          # Environment variable validation
    ├── mcp-servers.sh          # MCP server configuration and availability
    ├── multi-user.sh           # Multi-user configuration validation
    ├── memory-system.sh        # Container memory system validation
    └── vscode-integration.sh   # VSCode DevContainer integration

scripts/doctor/                  # Host validation scripts
├── docker.sh                   # Docker installation/daemon
├── docker-compose.sh           # Compose with user parameterization
├── memory-system.sh            # Memory system validation
├── node.sh                     # Node.js environment with required script validation
├── package-scripts.sh          # npm script validation and testing
├── required-files.sh           # File structure validation
└── vscode.sh                   # VSCode installation and extension validation
```

### Container Validation Architecture

**Automatic Environment Detection:**
- Doctor script detects container environment by checking for `/workspace` directory
- Host validation runs when outside container
- Container validation runs when inside container (same script, different behavior)

**Container-Specific Validations:**
- **environment.sh**: Validates container environment variables and paths
- **multi-user.sh**: Validates user-specific mounting and isolation
- **mcp-servers.sh**: Validates MCP server configuration and availability
- **vscode-integration.sh**: Validates VSCode DevContainer integration
- **Automatic User Detection**: Uses `$CLAUDE_USER` to validate user-specific configuration

**Integration Testing:**
- `--include-devcontainer` flag enables full integration testing
- Starts user-specific container and runs validation inside
- Validates complete development environment end-to-end
- Comprehensive MCP server and VSCode integration testing

### MCP Server and VSCode Integration Validation

**MCP Server Configuration Validation:**
- **JSON Syntax Validation**: Comprehensive validation of `.devcontainer/.mcp.json` configuration syntax
- **Server Availability Testing**: Verifies both basic-memory and sequential-thinking MCP servers are installed and accessible
- **Container Environment Testing**: Validates MCP server functionality within container environment
- **Integration with Basic Memory**: Tests basic-memory server installation via `pip3 install --user basic-memory`
- **Integration with Sequential Thinking**: Tests sequential-thinking server via npm global installation or node modules

**VSCode DevContainer Integration Validation:**
- **Container Configuration Validation**: Validates `devcontainer.json` syntax and required settings
- **Remote User Configuration**: Ensures `remoteUser` is correctly set to `claudreyality`
- **Workspace Folder Mapping**: Validates `workspaceFolder` points to `/workspace`
- **User Environment Testing**: Confirms container runs with correct user (`claudreyality`)
- **Host VSCode Detection**: Detects VSCode installation and DevContainer extension availability
- **Multi-User Container Support**: Validates VSCode can connect to user-specific containers

**Host-Level VSCode Validation:**
- **Installation Detection**: Checks multiple VSCode variants (code, code-insiders, macOS app)
- **Extension Management**: Validates DevContainer extension installation
- **Graceful Degradation**: Provides informational warnings without blocking validation
- **Alternative Access**: Documents fallback options via `npm run dev:shell`

**Integration Architecture:**
```text
Host VSCode → DevContainer Extension → ${CLAUDE_USER}-stonekin-dev
     ↓                ↓                        ↓
VSCode validates  →  Container config  →  MCP servers ready
container setup      validates syntax      stdio communication
```

**Validation Capabilities Added:**
- **scripts/doctor/vscode.sh**: Host-level VSCode installation and extension validation
- **.devcontainer/scripts/doctor/mcp-servers.sh**: Container-level MCP server validation
- **.devcontainer/scripts/doctor/vscode-integration.sh**: Container-level VSCode integration validation
- **Complete Integration Testing**: Full validation chain from host to container services

## Final Validation Framework (Phase 8 Complete)

### Comprehensive Test Suite

**Complete Test Suite:** `scripts/run-full-tests.sh`
- **Phase 1**: Basic Environment Validation
- **Phase 2**: Single User Container Testing  
- **Phase 3**: Multi-User Container Testing
- **Phase 4**: Package Management Validation
- **Phase 5**: Documentation Validation

**Multi-User Testing:** `scripts/test-multi-user.sh`
- Tests multiple users (alice, bob, claude-test) with full container lifecycle
- Validates memory isolation and user-specific container naming
- Includes comprehensive cleanup after testing

**Validation Implementation:**
See [scripts/run-full-tests.sh](../../scripts/run-full-tests.sh) and [scripts/test-multi-user.sh](../../scripts/test-multi-user.sh) for validation implementation. For validation commands, see [CONTRIBUTING.md](../../CONTRIBUTING.md).

## Technical Decisions

### Progressive Validation Approach

**Choice**: Multi-phase validation building from basic to complex

**Rationale**:
- Early failure detection reduces debugging time
- Clear separation of concerns for different validation types
- Enables targeted testing of specific components
- Supports both development and CI/CD scenarios

### Environment Detection Strategy

**Choice**: Automatic detection based on filesystem markers

**Rationale**:
- `/workspace` directory presence indicates container environment
- Allows same script to work in different contexts
- Reduces complexity of separate host/container scripts
- Enables seamless integration testing

### Script Organization Pattern

**Choice**: Hierarchical organization with domain separation

**Rationale**:
- Clear separation between host and container validations
- Modular approach enables independent testing
- Easy to extend with new validation capabilities
- Maintains backward compatibility through symlinks

## Conclusion

This validation framework provides comprehensive testing capabilities for the DevContainer environment while maintaining simplicity and extensibility. The progressive validation approach ensures robust environment setup across different user configurations and development scenarios.
