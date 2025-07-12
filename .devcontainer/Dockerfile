# Multi-stage build for efficiency
FROM ubuntu:22.04 AS base

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Install base dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    sudo \
    zsh \
    build-essential \
    ca-certificates \
    locales \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# Generate locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Create claude user with sudo privileges
RUN useradd -m -s /bin/zsh claude && \
    echo "claude ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/claude && \
    chmod 0440 /etc/sudoers.d/claude

# Switch to claude user
USER claude
WORKDIR /home/claude

# Install oh-my-zsh for better shell experience
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc

# Install nvm and Node.js 23.11
ENV NVM_DIR="/home/claude/.nvm"
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash && \
    . "$NVM_DIR/nvm.sh" && \
    nvm install 23.11 && \
    nvm use 23.11 && \
    nvm alias default 23.11

# Add nvm to shell
RUN echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc && \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.zshrc

# Install Python 3.11 and UV
USER root
RUN apt-get update && apt-get install -y \
    python3.11 \
    python3.11-venv \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Switch back to claude user
USER claude

# Install UV for Python package management
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Add UV to PATH
RUN echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc

# Install Claude Code (Note: actual package name may differ)
# For now, we'll install it inside the container manually or via script
# RUN . "$NVM_DIR/nvm.sh" && npm install -g claude-code

# Install Python packages with UV
RUN /home/claude/.local/bin/uv tool install basic-memory

# Install Node packages for MCP servers
WORKDIR /workspace
USER root
RUN . "/home/claude/.nvm/nvm.sh" && \
    npm init -y && \
    npm install --save-dev @modelcontextprotocol/server-sequential-thinking

# Set up workspace permissions
RUN mkdir -p /workspace/memory && \
    chown -R claude:claude /workspace

# Copy MCP configuration
COPY --chown=claude:claude .mcp.json /workspace/.mcp.json

# Switch to claude user for runtime
USER claude
WORKDIR /workspace

# Set zsh as default shell
SHELL ["/bin/zsh", "-c"]

# Default command keeps container running
CMD ["sleep", "infinity"]