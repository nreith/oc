#!/usr/bin/env bash
# shellcheck disable=SC1089,SC2288
SHELL := /bin/bash

.SHELLFLAGS := -eu -o pipefail -c

.PHONY: help
help: ## Show this help message
	@printf "Available targets:\n"
	@grep -E '^([a-zA-Z_-]+):.*?##' "$(MAKEFILE_LIST)" | awk 'BEGIN {FS = ":.*?##"} {printf "  %-15s %s\n", $$1, $$2}'

.PHONY: install-opencode
install-opencode: ## Install and configure opencode basics
	@echo "Installing opencode and setting configuration"
	@command -v brew >/dev/null 2>&1 || { \
		echo "Error: Homebrew is not installed. Please install homebrew from https://brew.sh/ and try again."; \
		exit 1; \
	}
	@brew install opencode
	@mkdir -p ~/.config/opencode
	@cp -f opencode.json ~/.config/opencode/opencode.json
	@echo "Creating useful oc functions such as 'oc_plugin add plugin-name' or 'oc_plugin remove plugin-name"
	@echo "    which will add or remove a plugin in the plugins section of the ~/.config/opencode/opencode.json using sed."
	@cp -f .opencode_functions ~/.config/opencode/.opencode_functions
	@for file in $$HOME/.bashrc $$HOME/.zshrc $$HOME/.profile; do if [ -f "$$file" ]; then if ! grep -qF 'source ~/.config/opencode/.opencode_functions' "$$file"; then echo 'source ~/.config/opencode/.opencode_functions' >> "$$file"; fi; fi; done
	@echo "Done! Be sure you export your 'OPENAI_API_KEY' and 'OPENAI_BASE_URL' in your environment (Add to ~/.bashrc or similar)"
	@echo "Then run 'opencode' to launch opencode in a folder of your choosing, with all current config."
	@echo "Plugins can be enabled or disabled (unrelated to installation), with 'ocp' comamnds:"
	@echo "# Usage:"
	@echo "#   ocp list              -> Show all plugins"
	@echo "#   ocp enable <name>     -> Explicitly enable"
	@echo "#   ocp disable <name>    -> Explicitly disable"
	@echo "#   ocp remove <name>     -> Delete the line"
	@echo "#   ocp <name>            -> Toggle (classic behavior)"

# Plugin is rather useless as it doesn't have many registries yet
# .PHONY: ocx
# ocx: ocx ## Install ocx opencode plugin manager, and set some aliases
# 	@echo "Adding ocx (opencode extension/plugin manager)"
# 	@npm install -g ocx
# 	@ocx init --global
# 	@ocx registry add --global https://registry.kdco.dev --name kdco
# 	@ocx registry add --global https://github.com/awesome-opencode/awesome-opencode --name awesomeoc


.PHONY: install-plugins
install-plugins: oh-my-opencode superpowers skills ## Install opencode plugins and skills

.PHONY: install-oh-my-opencode
install-oh-my-opencode: ## Install oh-my-opencode (plugins:)
	@echo "Installing oh-my-opencode and dependencies"
	@brew install npm
	@npm install -g bun
	@bunx oh-my-opencode install --no-tui --skip-auth --openai=no --gemini=no --claude=no \
		--copilot=no --opencode-zen=no --zai-coding-plan=no
	@brew install ast-grep gh gopls pyright rust-analyzer typescript-language-server
	@cp -f oh-my-opencode.json ~/.config/opencode/oh-my-opencode.json
	source ~/.config/opencode/.opencode_functions; ocp enable oh-my-opencode@latest
	@echo "Done! Use the 'omo' function / shortcut to launch opencode with oh-my-opencode enabled."
	@echo "Or run 'oc' to run opencode specifically without oh-my-opencode installed, to have only default build/plan agents and behavior."

.PHONY: install-superpowers
install-superpowers: ## Install and configure superpowers plugin
	@echo "# Install Superpowers (or update existing)"
	@if [ -d ~/.config/opencode/superpowers ]; then \
		cd ~/.config/opencode/superpowers && git pull; \
	else \
		git clone https://github.com/obra/superpowers.git ~/.config/opencode/superpowers; \
	fi
	@mkdir -p ~/.config/opencode/plugins ~/.config/opencode/skills
	@rm -f ~/.config/opencode/plugins/superpowers.js
	@rm -rf ~/.config/opencode/skills/superpowers
	@ln -s ~/.config/opencode/superpowers/.opencode/plugins/superpowers.js ~/.config/opencode/plugins/superpowers.js
	@ln -s ~/.config/opencode/superpowers/skills ~/.config/opencode/skills/superpowers
	@source ~/.config/opencode/.opencode_functions && ocp enable superpowers@latest

.PHONY: install-skills
install-skills: ## Install vercel/skills and a few useful skills
	@echo "Adding common agent-skills and agent-browser skills with vercel"
	@if command -v agent-browser > /dev/null; then \
		echo "agent-browser already installed, skipping installation."; \
	else \
		npx -y skills add vercel-labs/agent-skills -g -a opencode -a claude-code -y && \
		npx -y skills add vercel-labs/agent-browser -g -a opencode -a claude-code -y && \
		npx -y agent-browser install --with-deps -y; \
	fi
	# Ensure Playwright browsers are installed if Playwright is a dependency
	@if grep -q '@playwright/test' package.json 2>/dev/null; then \
		echo "Installing Playwright dependencies..."; \
		npm install && npx playwright install; \
	fi
	@echo "Done!"

# May need more work on this skills thing above for installing playwright
# @npm install @playwright/test
# 	@npx playwright install


.PHONY: install
install: install-opencode plugins ## Install everything
	@echo "OpenCode environment installed with oh-my-opencode, superpowers and skills."

.PHONY: update
update: ## Update opencode and other installs
	@echo "Updating Homebrew formulas..."
	@brew update && brew upgrade
	@echo "Updating npm global packages..."
	@npm update -g || true
	@echo "Updating bun (if installed)..."
	@if command -v bun > /dev/null; then bun upgrade || true; fi
	@echo "Update complete."

.PHONY: test
test: ## Run test suite (placeholder)
	@echo "Testing not configured – add your test commands here"

.PHONY: docs
docs: ## Generate documentation from markdown files
	@echo "Generating docs..."
	@pandoc README.md -o README.html

.PHONY: lint
lint: ## Run linters (placeholder)
	@echo "Running linters..."
	-@if command -v shellcheck > /dev/null; then \
		find . -type f -name "*.sh" -exec shellcheck {} +; \
		find . -type f -name "Makefile" -exec shellcheck {} +; \
	else \
		echo "shellcheck not installed, skipping shell script lint"; \
	fi
	-@if command -v jq > /dev/null; then \
		find . -type f -name "*.json" -exec jq -e . {} > /dev/null 2>/dev/null \; || echo "JSON lint errors found"; \
	else \
		echo "jq not installed, skipping JSON lint"; \
	fi
	-@if command -v markdownlint > /dev/null; then \
		markdownlint "**/*.md"; \
	else \
		echo "markdownlint not installed, skipping markdown lint"; \
	fi

.PHONY: all clean
all: ## Default target (no-op)
	@true
clean: ## Clean generated repository files (node_modules, lock files, build artifacts, .sisyphus, etc.)
	@rm -rf node_modules bun.lock package-lock.json yarn.lock .sisyphus .out .dist build tmp package.json
	@echo "Cleaned repository generated files."

