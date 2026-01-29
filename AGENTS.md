# AGENTS.md

---

## Project Overview

- **Repository:** `oc` – OpenCode configuration and helper scripts.
- **Primary stack:** Bash scripts, Makefile, Node.js tooling (npm, bun), OpenCode JSON configs.
- **Languages detected:** Bash, JSON, Markdown.
- **Purpose:** Provide a reproducible environment for installing and configuring OpenCode and Oh‑My‑OpenCode, plus utility targets for linting, documentation, and cleanup.

---

## Build / Installation Commands

| Target | Command | Description |
|--------|---------|-------------|
| `install` | `make install` | Installs OpenCode, then Oh‑My‑OpenCode, and sets up configuration files. |
| `opencode` | `make opencode` | Installs OpenCode via Homebrew and copies `opencode.json` to `~/.config/opencode/`. |
| `oh‑my‑opencode` | `make oh‑my‑opencode` | Installs npm, bun, then Oh‑My‑OpenCode and required language servers. |
| `skills` | `make skills` | Installs Vercel agent‑skills and the `agent‑browser` skill. |
| `all` | `make` (default) | No‑op placeholder. |

---

## Linting Commands

The `lint` target runs three optional linters; they are skipped if not installed.

```bash
make lint
```

| Linter | Files checked | Command executed |
|--------|---------------|------------------|
| **ShellCheck** | `*.sh` | `find . -type f -name "*.sh" -exec shellcheck {} +` |
| **jq** (JSON validation) | `*.json` | `find . -type f -name "*.json" -exec jq -e . {} > /dev/null 2>/dev/null \;` |
| **markdownlint** | `*.md` | `markdownlint "**/*.md"` |

> **Note:** Linter failures only produce console output; they do **not** cause the make process to exit with an error code (the `-@` prefix silences failures).

---

## Testing Commands

The repository currently provides a placeholder test target. It can be extended with a real test suite later.

```bash
make test
```

- **Current behavior:** Prints `Testing not configured – add your test commands here`.
- **Running a single test:** When a concrete test runner is added (e.g., `bun test` or `npm test`), the pattern will be:

```bash
# Example for Bun test framework
bun test path/to/file.test.ts   # run a specific test file
bun test --filter "Test name"   # run a single test case by name
```

Update the `test` target accordingly once a framework is chosen.

---

## Code‑Style Guidelines

These guidelines are **project‑specific**; they complement the generic linting configuration above.

### Imports

- Use **relative imports** for intra‑repo modules (e.g., `./script.sh`).
- Prefer **named imports** over wildcard imports when using JavaScript/TypeScript (not currently present, but keep for future extensions).

### Formatting

- Bash scripts use two‑space indentation.
- JSON files must be **pretty‑printed** with 2‑space indentation.
- Markdown files follow the default `markdownlint` rules, with `MD013` (line length) and `MD060` (heading levels) disabled as per `.markdownlint.json`.

### Types & Validation

- No TypeScript/TS typings are currently used; future additions should enforce strict typing (`--strict` flag) and enable `eslint` + `typescript-eslint` rules.
- JSON files are validated by `jq` in the lint step.

### Naming Conventions

- Files: `snake_case` for scripts (`install.sh`, `opencode.sh`).
- Variables in Bash: `UPPER_SNAKE_CASE` for environment constants, `lower_snake_case` for locals.
- Targets in `Makefile`: lower‑case, descriptive, and match the command they invoke.

### Error Handling

- Bash commands are executed with `set -eu -o pipefail` (see line 3 of the `Makefile`).
- Each Makefile recipe checks for required tools and exits with a clear message if missing (e.g., Homebrew check in `opencode`).
- Do **not** suppress errors with `|| true` unless the command is non‑critical (as done for optional linters).

---

## Cursor & Copilot Rules

The repository does **not** contain any of the following files, so there are no custom rules for Cursor or GitHub Copilot:

- `.cursor/`
- `.cursorrules`
- `.github/copilot-instructions.md`

If you later add such files, document them here with a brief summary of the rules they enforce.

---

## Agent Definitions (unchanged)

| Agent | Model | Reasoning | Tool Call | Additional Options |
|-------|-------|-----------|----------|--------------------|
| **Sisyphus** | `custom/gpt-oss-120b` | ✅ Enabled | ✅ Enabled | `variant: high`, `maxTokens: 16384` |
| **oracle** | `custom/gpt-oss-120b` | ✅ Enabled | ❌ Disabled | `reasoningEffort: xhigh` |
| **librarian** | `custom/mistral-small-24b` | ❌ Disabled | ✅ Enabled | `context: 114688` |
| **executor** | `custom/llma-3-3-70b-instruct` | ✅ Enabled | ✅ Enabled | — |
| **explore** | `custom/codestral-22b` | ❌ Disabled | ✅ Enabled | — |
| **frontend_engineer** | `custom/pixtral-12b` | ❌ Disabled | ✅ Enabled | `context: 114688` |

---

End of AGENTS.md – generated on $(date '+%Y-%m-%d %H:%M:%S')
