# AGENTS.md

This document is the standard OpenCode agents documentation file. It provides a concise overview of all agents defined in `oh-my-opencode.json`, including their configuration details such as model, reasoning, tool‑call capability, and any additional options. It replaces any previous documentation and serves as the single source of truth for agent definitions in this repository.

---

## Agent Definitions

| Agent | Model | Reasoning | Tool Call | Additional Options |
|-------|-------|-----------|----------|--------------------|
| **Sisyphus** | `custom/gpt-oss-120b` | ✅ Enabled | ✅ Enabled | `variant: high` (high reasoning effort), `maxTokens: 16384` |
| **oracle** | `custom/gpt-oss-120b` | ✅ Enabled | ❌ Disabled | `reasoningEffort: xhigh` (maximum logic for debugging) |
| **librarian** | `custom/mistral-small-24b` | ❌ Disabled | ✅ Enabled | `context: 114688` |
| **executor** | `custom/llama-3-3-70b-instruct` | ✅ Enabled | ✅ Enabled | — |
| **explore** | `custom/codestral-22b` | ❌ Disabled | ✅ Enabled | — |
| **frontend_engineer** | `custom/pixtral-12b` | ❌ Disabled | ✅ Enabled | `context: 114688` |

---

*Note: The absence of a flag means the default value (`false` for boolean options) is applied.*
