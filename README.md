# OpenCode Configuration Repository

## Purpose

This repository provides configuration files and helper scripts for **OpenCode** and **Oh‑My‑OpenCode**. It simplifies installing, configuring, and managing these tools on macOS or Linux.

## Prerequisites

- Homebrew installed (`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`).
- Access to the internet to download Homebrew packages.
- Optional: `pandoc` if you wish to generate HTML documentation (`brew install pandoc`).

## Setup workflow

1. **Install dependencies**

   ```bash
   make install
   ```

   This installs OpenCode and Oh‑My‑OpenCode, along with required dependencies.

2. **Configure the tools**

   The installation targets copy the necessary configuration files into `~/.config/opencode` and set up any required environment variables.

3. **Start using OpenCode**

   ```bash
   opencode
   ```

   This launches the OpenCode CLI in the current directory.

## Helper scripts and CLI commands

- **`opencode`** – The primary OpenCode command installed by the `install` target.
- **`oh‑my‑opencode`** – Installs the Oh‑My‑OpenCode plugin and its dependencies.
- **Manual commands** – You can invoke the OpenCode binary directly for advanced usage.

## Available commands

| Target | Description |
|--------|-------------|
| `install` | Install OpenCode and Oh‑My‑OpenCode together |
| `opencode` | Install OpenCode and set configuration |
| `oh‑my‑opencode` | Install Oh‑My‑OpenCode and dependencies |
| `update` | Update Homebrew and installed tools |
| `test` | Placeholder for test suite |
| `lint` | Run linters (ShellCheck, jq, markdownlint) |
| `docs` | Generate HTML documentation from markdown |
| `clean` | Placeholder for cleaning generated files |
| `help` | Show list of make targets |

## Contributing

Contributions are welcome. Since this repository mainly contains configuration files, please ensure any changes maintain compatibility across supported platforms. Feel free to open issues or pull requests to improve documentation, add new make targets, or enhance existing scripts.
