# DevContainer Boundary Reorganization - Research & Validation

**Date:** 2025-07-13  
**Purpose:** Validate the reorganization plan against official DevContainer and Docker Compose specifications

## Official DevContainer Specification Research

### Source: containers.dev/implementors/json_reference/

#### remoteUser Property

- **Official Definition**: Can override the user that tools run as inside the container
- **Default Behavior**: Defaults to the container's current running user (often root)
- **Inheritance**: Inherits from base image configuration
- **Usage**: Can be set to change user for processes and terminals
- **UID/GID Sync**: Optional task for Linux that executes if `updateRemoteUserUID` is set to true

**✅ Plan Validation**: Our plan to use fixed `remoteUser: "claudreyality"` aligns with specification requirements. The specification supports custom user names and proper user management.

#### workspaceFolder Property

- **Official Definition**: Sets the default path where development tools will open in the container
- **Customization**: Can be customized with `workspaceFolder` property
- **Default**: Defaults to automatic source code mount location
- **Mount Requirement**: Requires `workspaceMount` to be set if manually specifying a custom path
- **Use Cases**: Particularly important for monorepos where developers interact with sub-projects

**✅ Plan Validation**: Our plan to use `/workspace` as workspaceFolder follows DevContainer standards and best practices.

#### Container Environment Variables

- **containerEnv**: Sets variables for all container processes
- **remoteEnv**: Sets variables for specific tools/services
- **Variable References**: Supports referencing existing environment variables
- **Pre-defined Variables**: Can use variables like `${localEnv:VARIABLE_NAME}`
- **Default Values**: Variables can include default values if not set

**✅ Plan Validation**: Our plan to use `containerEnv` with `CLAUDE_USER` and `MEMORY_FILE_PATH` follows official patterns.

## Docker Compose Environment Variable Research

### Source: docs.docker.com/compose/environment-variables/

#### Environment Variable Substitution

- **Syntax**: Uses `${VARIABLE}` or `${VARIABLE:-default}` format
- **Runtime Injection**: Allows dynamic value injection at runtime
- **Shell Environment**: Compose looks for variables in shell and substitutes values
- **Empty String Handling**: Unset variables substitute with empty string

**✅ Plan Validation**: Our use of `${CLAUDE_USER}` in service names and volume paths follows Docker Compose best practices.

#### Volume Parameterization

- **Dynamic Volumes**: Supports parameterized volume names using environment variables
- **Mount Sources**: Environment variables can parameterize mount source paths
- **Bind Mounts**: Variable substitution works with bind mount paths

**✅ Plan Validation**: Our parameterized volume approach (`${CLAUDE_USER}-stonekin-history`) and bind mount paths (`../.claude/${CLAUDE_USER}/`) are supported patterns.

#### Security Best Practices

- **Sensitive Data**: Don't use environment variables for passwords or secrets
- **Default Values**: Set sensible defaults for missing variables
- **Documentation**: Document required environment variables
- **Version Control**: Exclude sensitive .env files from version control

**✅ Plan Validation**: Our plan doesn't expose sensitive data through environment variables and requires explicit user specification.

## Linux User/Home Directory Mounting

### Research Findings

- **Home Directory Standards**: Linux users get standard home directories at `/home/{username}`
- **Mount Permissions**: Bind mounts preserve host file permissions
- **User Mapping**: Container users can mount different host user configurations
- **SSH Key Permissions**: Private keys require 600 permissions, public keys 644

**✅ Plan Validation**: Our approach of mounting different host user configs into a fixed container user home (`/home/claudreyality`) is a valid Linux pattern.

## MCP Server Configuration Requirements

### Current Analysis

- **Storage Path**: MCP basic-memory server requires `--storage` argument with writable directory
- **Path Flexibility**: Server doesn't impose specific path requirements
- **Environment Variables**: MCP configuration can use environment variables in paths
- **Isolation**: Different agents can use different storage paths

**✅ Plan Validation**: Our plan to use `/memory/${CLAUDE_USER}` for MCP storage with environment variable substitution meets all requirements.

## Validation Summary

### ✅ DevContainer Standard Compliance

- **remoteUser**: Fixed `claudreyality` user follows specification
- **workspaceFolder**: `/workspace` aligns with standard practices
- **containerEnv**: Environment variable usage follows official patterns
- **Mount Separation**: Clear workspace, home, and memory boundaries

### ✅ Docker Compose Best Practices

- **Variable Substitution**: `${CLAUDE_USER}` pattern is officially supported
- **Parameterized Services**: Dynamic container names follow best practices
- **Volume Management**: User-specific volumes with environment variables
- **Security**: No sensitive data in environment variables

### ✅ Linux System Conventions

- **User Management**: Fixed container user with dynamic config mounting
- **Home Directory**: Standard `/home/claudreyality` structure
- **File Permissions**: SSH key permission requirements addressed
- **Mount Patterns**: Bind mount approach is standard practice

### ✅ MCP Server Requirements

- **Storage Configuration**: Environment variable paths supported
- **Agent Isolation**: Per-user storage paths enable proper isolation
- **Path Flexibility**: No conflicts with proposed memory structure

## Recommendations from Research

### 1. Environment Variable Defaults

Consider adding a fallback mechanism for `CLAUDE_USER` to provide better error messages when unset, rather than silent failures.

### 2. Documentation Requirements

Based on Docker Compose best practices, document all required environment variables and their purposes.

### 3. Permission Handling

Ensure SSH key permissions are explicitly managed during file moves to maintain security.

### 4. Testing Strategy

Validate that VSCode DevContainer integration works correctly with parameterized configurations.

## Conclusion

The research validates that our reorganization plan follows official specifications and best practices:

- **DevContainer Specification**: All proposed configurations align with official requirements
- **Docker Compose Standards**: Environment variable usage follows documented patterns  
- **Linux Conventions**: User and mount management approaches are standard
- **MCP Requirements**: Storage configuration meets all server needs

The plan is technically sound and ready for implementation.
