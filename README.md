# OpenCode Configuration Repository

## Purpose

This repository provides configuration files and helper scripts for **OpenCode** and **Oh‑My‑OpenCode**. It simplifies installing, configuring, and managing these tools on macOS or Linux.

## Prerequisites

- Homebrew installed (`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`).
- Access to the internet to download Homebrew packages.
- Optional: `pandoc` if you wish to generate HTML documentation (`brew install pandoc`).

## Setup workflow

1. **Install dependencies and tools**

   ```bash
   make install
   ```

   This target runs the following sub‑targets:
   - `opencode` – installs the OpenCode CLI, copies `opencode.json` to `~/.config/opencode/`, and installs the helper functions from `.oc_functions`.
   - `oh-my-opencode` – installs Oh‑My‑OpenCode, Node.js, Bun, and a set of language servers, then registers the `oh‑my‑opencode` plugin.
   - `skills` – installs Vercel agent‑skills and the `agent-browser` skill.
   - (Later) runs linting and the placeholder test suite.

2. **Configure the tools**

   The installation copies required configuration files into `~/.config/opencode` and appends `source ~/.oc_functions` to your shell startup files (`~/.bashrc`, `~/.zshrc`, `~/.profile`).

   > **Note:** Ensure you export `OPENAI_API_KEY` and `OPENAI_BASE_URL` in your environment (e.g., add them to `~/.bashrc`).

3. **Start using OpenCode**

   ```bash
   opencode
   ```

   This launches the OpenCode CLI in the current directory.

## Bash Functions (`.oc_functions`)

The repository ships a small library of convenience functions that are sourced automatically after running `make opencode`.

- `oc_plugin <add|remove> <plugin-name>` – Adds or removes a plugin name from the `plugin` array in `~/.config/opencode/opencode.json`.
- `oc` – Runs `opencode` after ensuring the `oh‑my‑opencode` plugin is disabled.
- `omo` – Enables the `oh‑my‑opencode` plugin, selects an available port, and starts an OpenCode session inside a TMUX window (or directly if TMUX is not running). It also sets `OPENCODE_PORT` for the session.

These helpers simplify switching between a plain OpenCode environment and the feature‑rich Oh‑My‑OpenCode setup.

## Makefile Targets

| Target | Description |
|--------|-------------|
| `help` | Show a list of available make targets. |
| `opencode` | Install OpenCode, copy configuration, and install the `.oc_functions` helpers. |
| `oh-my-opencode` | Install Oh‑My‑OpenCode, Node.js, Bun, language servers, and register the Oh‑My‑OpenCode plugin. |
| `skills` | Install Vercel agent‑skills and the `agent-browser` skill. |
| `install` | Run `opencode`, `oh‑my‑opencode`, and `skills` together (full environment setup). |
| `update` | Update Homebrew and upgrade installed formulas. |
| `test` | Placeholder for running the test suite. |
| `docs` | Generate HTML documentation from `README.md` using `pandoc`. |
| `lint` | Run optional linters: ShellCheck, `jq` for JSON, and `markdownlint`. |
| `clean` | Remove generated files such as `node_modules`, lock files, `.sisyphus`, and build artifacts. |
| `all` | Default no‑op target. |

## Generating Documentation

```bash
make docs   # Produces README.html from the markdown source
```

## Linting

```bash
make lint   # Runs shellcheck, jq, and markdownlint if they are installed
```

## Cleaning Up

```bash
make clean  # Deletes generated files and directories
```

## Contributing

Contributions are welcome. Since this repository mainly contains configuration files, please ensure any changes maintain compatibility across supported platforms. Feel free to open issues or pull requests to improve documentation, add new make targets, or enhance existing scripts.
