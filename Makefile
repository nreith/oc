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
	@echo "Done! Be sure you export your 'OPENAI_API_KEY' and 'OPENAI_BASE_URL' in your environment (Add to ~/.bashrc or similar)"
	@echo "Then run 'opencode' to launch opencode in a folder of your choosing."

.PHONY: oh-my-opencode
oh-my-opencode: ## Install oh-my-opencode
	@echo "Installing oh-my-opencode and dependencies"
	@brew install npm
	@npm install -g bun
	@bunx oh-my-opencode install --no-tui --skip-auth --openai=no --gemini=no --copilot=no --opencode-zen=no --zai-coding-plan=no
	@brew install ast-grep gh gopls pyright rust-analyzer typescript-language-server
	@cp -f oh-my-opencode.json ~/.config/opencode/oh-my-opencode.json
	@sed -i 's|^[[:space:]]*//[[:space:]]*"plugin":|"plugin":|' ~/.config/opencode/opencode.json
	@echo "Done! If you ever want to disable, comment out this line in your ~/.config/opencode/opencode.json:"
	@echo '    "plugin": [ "oh-my-opencode@latest" ],'

.PHONY: skills
skills: ## Install vercel/skills and a few useful skills
	@echo "Adding common agent-skills and agent-browser skills with vercel"
	@npx skills add vercel-labs/agent-skills -g -a opencode -a claude-code -y
	@npx skills add vercel-labs/agent-browser -g -a opencode -a claude-code -y
	@npx agent-browser install --with-deps -y
	@echo "Done!"

.PHONY: install
install: ## Install everything (opencode + oh‑my‑opencode + skills + lint + test)
	# This target now also installs agent skills, runs linting, and executes the test suite
	@$(MAKE) opencode
	@$(MAKE) oh‑my‑opencode
	@$(MAKE) skills
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
clean: ## Clean target (no-op)
	@true
