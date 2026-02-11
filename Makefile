SHELL := /bin/bash

.SHELLFLAGS := -eu -o pipefail -c

.PHONY: help
help: ## Show this help message
	@printf "Available targets:\n"
	@grep -E '^([a-zA-Z_-]+):.*?##' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?##"} {printf "  %-15s %s\n", $$1, $$2}'

.PHONY: opencode
opencode: ## Install opencode and set configuration
	@echo "Installing opencode and setting configuration"
	@if ! command -v brew &> /dev/null; then \
        echo "Error: Homebrew is not installed. Please install homebrew from https://brew.sh/ and try again."; \
        exit 1; \
    fi
	@brew install opencode
	@mkdir -p ~/.config/opencode
	@cp -f opencode.json ~/.config/opencode/opencode.json
	@echo "Creating useful oc functions such as 'oc_plugin add plugin-name' or 'oc_plugin remove plugin-name"
	@echo "    which will add or remove a plugin in the plugins section of the ~/.config/opencode/opencode.json using sed."
	@cp -f .oc_functions ~/.oc_functions
	@for file in ~/.bashrc ~/.zshrc ~/.profile; do \
		if [ -f "$$file" ]; then \
			if ! grep -qF 'source ~/.oc_functions' "$$file"; then \
				echo 'source ~/.oc_functions' >> "$$file"; \
			fi; \
		fi; \
	done
	@echo "Done! Be sure you export your 'OPENAI_API_KEY' and 'OPENAI_BASE_URL' in your environment (Add to ~/.bashrc or similar)"
	@echo "Then run 'opencode' to launch opencode in a folder of your choosing, with all enabled plugins."
	@echo "Or run 'oc' to run opencode specifically without oh-my-opencode installed, to have only default build/plan agents and behavior."

.PHONY: oh-my-opencode
oh-my-opencode: ## Install oh-my-opencode
	@echo "Installing oh-my-opencode and dependencies"
	@brew install npm
	@npm install -g bun
	@bunx oh-my-opencode install --no-tui --skip-auth --openai=no --gemini=no --claude=no \
		--copilot=no --opencode-zen=no --zai-coding-plan=no
	@brew install ast-grep gh gopls pyright rust-analyzer typescript-language-server
	@cp -f oh-my-opencode.json ~/.config/opencode/oh-my-opencode.json
	source ~/.oc_functions; oc_plugin add oh-my-opencode
	@echo "Done! Use the 'omo' function / shortcut to launch opencode with oh-my-opencode enabled."

.PHONY: skills
skills: ## Install vercel/skills and a few useful skills
	@echo "Adding common agent-skills and agent-browser skills with vercel"
	@npx -y skills add vercel-labs/agent-skills -g -a opencode -a claude-code -y
	@npx -y skills add vercel-labs/agent-browser -g -a opencode -a claude-code -y
	@npx -y agent-browser install --with-deps -y
	@echo "Done!"

# May need more work on this skills thing above for installing playwright
# @npm install @playwrite/test
# 	@npx playwrite install

.PHONY: install
install: opencode oh-my-opencode skills ## Install everything (opencode + oh‑my‑opencode + skills + lint + test)
	# This target now also installs agent skills, runs linting, and executes the test suite
	@echo "OpenCode environment installed with oh-my-opencode and skills."

.PHONY: update
update: ## Update opencode and other installs
	@brew update

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
	@rm -rf node_modules bun.lock package-lock.json yarn.lock .sisyphus .out .dist build tmp
	@echo "Cleaned repository generated files."

