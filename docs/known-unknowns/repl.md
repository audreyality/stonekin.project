# REPL Exploration

## Overview

The REPL (Read-Eval-Print Loop) serves as a foundational interaction mechanism within the Stonekin SDK, enabling dynamic interaction between the user and the agent system. As part of the broader roadmap, this document outlines the REPL's decomposition into its core features and supporting domains, preparing it for full implementation.

### Core Objectives

* Provide a continuous, session-based interaction loop.
* Support real-time command execution and contextual feedback.
* Integrate seamlessly with reactive lifecycle signaling.
* Enable extensibility through additional agents (e.g., Memory, Stenographer).

## Feature Decomposition

### Facility Features

* Access to `stdin`, `stdout`, and `stderr` streams.
* Structured parsing of input/output for REPL interactions.
* Translation of raw I/O to observable streams.

### Agent Features

* Maintains internal session state (history, prompts, execution results).
* Processes input and dispatches commands to agent system.
* Emits lifecycle events (`live`, `error`, `complete`) via observables.
* Emits messages containing power state hints (e.g. `sleep`, `exit`).

### Controller Responsibilities

* Subscribes to REPL agent lifecycle observables.
* Coordinates REPL startup/shutdown based on project state.
* Enforces context boundaries and triggers recovery agents on failure.

## Integration Considerations

* REPL can be augmented with:

  * **Stenographer Agent** to persist interactions.
  * **Memory Agent** to contextualize commands with session memory.
* Must comply with SDK-wide boundary enforcement, observability, and lifecycle signaling patterns.

## Status

* [ ] Initial decomposition complete
* [ ] Lifecycle observables integrated
* [ ] Facilities abstracted and reactive
* [ ] Stenographer and Memory integration scoped

This roadmap entry will guide further design and implementation as the SDK matures.
