.DEFAULT_GOAL := help

# Explicit, not reliant on ~/.bashrc having been sourced — same reasoning
# as the fnm-exec pattern in .pre-commit-config.yaml.
FNM_PATH := $(HOME)/.local/share/fnm
WEB_RUN := cd web && PATH="$(FNM_PATH):$$PATH" fnm exec --

.PHONY: help
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

.PHONY: setup
setup: ## Install both toolchains' dependencies and the git hooks (run once after cloning)
	cd pipeline && uv sync
	$(WEB_RUN) npm ci
	uvx pre-commit install

.PHONY: data
data: ## Run the pipeline: download/normalize IMLS data, emit JSON into web/public/data/
	@echo "pipeline has no CLI entry point yet — nothing to run" >&2
	@exit 1

.PHONY: dev
dev: ## Start the local dev server (web/; does not require `make data` first)
	$(WEB_RUN) npm run dev

.PHONY: build
build: data ## Regenerate data, then produce a deployable static bundle in web/dist/
	$(WEB_RUN) npm run build

.PHONY: test
test: ## Run the pipeline's test suite (no frontend tests exist yet)
	cd pipeline && uv run pytest --cov

.PHONY: lint
lint: ## Run every check pre-commit would run, across the whole tree
	uvx pre-commit run --all-files

.PHONY: clean
clean: ## Remove build artifacts and caches (venvs, node_modules, dist, ...)
	rm -rf pipeline/.venv pipeline/.mypy_cache pipeline/.ruff_cache pipeline/.pytest_cache pipeline/.coverage
	find pipeline -type d -name __pycache__ -exec rm -rf {} +
	rm -rf web/node_modules web/dist
