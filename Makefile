setup:
	cd coder/template && terraform init

run:
	set -a && . ./.env && set +a && coder server --config coder/config.yaml

TEMPLATE_NAME ?= tasks-docker
CONFIG_DIR ?= coder/template

build:
	set -a && . ./.env && set +a && coder templates push $(TEMPLATE_NAME) --directory $(CONFIG_DIR) --yes --var anthropic_api_key=$${ANTHROPIC_API_KEY}

clean:
	tasks=$$(coder task list -q) && [ -n "$$tasks" ] && echo "$$tasks" | xargs coder task delete --yes || echo "No tasks to delete"
