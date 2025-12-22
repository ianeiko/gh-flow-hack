setup:
	cd coder/template && terraform init

run:
	set -a && . ./.env && set +a && coder server --config coder/config.yaml

TEMPLATE_NAME ?= tasks-docker
CONFIG_DIR ?= coder/template

push:
	set -a && . ./.env && set +a && coder templates push $(TEMPLATE_NAME) --directory $(CONFIG_DIR) --yes --var anthropic_api_key=$${ANTHROPIC_API_KEY}
