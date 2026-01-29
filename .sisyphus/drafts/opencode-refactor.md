# Draft: opencode-refactor

## Requirements (confirmed)
- Convert CLAUDE.md to AGENTS.md documenting agents, configurations, usage for OpenCode.
- Refactor Makefile to replace Claude-specific targets with opencode equivalents.
- Delete claude-init script, screenshot.png, CLAUDE.md after conversion.
- Review any test folder (none present) and ensure any tests would relate to the new opencode repo.
- Rewrite README.md to reflect new repository purpose and usage (opencode instead of Claude).
- Review and redo AGENTS.md to reflect all changes (new AGENTS.md should document agents defined in opencode.json and oh‑my‑opencode.json, and any other relevant config).
- After completing, check back with the user.

## Open Questions
- **Test Strategy**: Do you want to set up a test infrastructure (e.g., a simple test suite) for the new repository, or just note that no tests are required?
- **Makefile Targets**: Do you have preferred opencode command equivalents for the current Claude-specific targets (install, setup, update, remove-config, uninstall)?
- **High Accuracy Review**: Would you like the plan to undergo a high‑accuracy Momus review before execution?
- **Additional Files**: Apart from the listed items, are there any other files or configurations that should be removed or updated?

## Draft Update Log
- Initial draft created with requirements and open questions.

## Next Steps
- Await clarification on open questions before proceeding to full plan generation.

## Scope Boundaries
- **INCLUDE**: All documentation updates, Makefile refactor, file deletions, README rewrite, AGENTS.md creation.
- **EXCLUDE**: Adding new functional code beyond documentation and build script adjustments.
