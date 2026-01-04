# Makefile for ghflow tests
.PHONY: help install test e2e skills clean
.PHONY: test-issue-expander test-pr-creator test-code-reviewer
.PHONY: test-feature-implementer test-orchestrator test-project-setup

SKILLS_DIR := ../.claude/skills

help:
	@echo "ghflow Test Commands:"
	@echo ""
	@echo "  make install              Install test dependencies"
	@echo "  make test                 Run all tests (E2E + all skills)"
	@echo "  make e2e                  Run end-to-end workflow test only"
	@echo "  make skills               Run all skill unit tests"
	@echo ""
	@echo "Individual Skill Tests:"
	@echo "  make test-issue-expander       Test ghflow-issue-expander"
	@echo "  make test-pr-creator           Test ghflow-pr-creator"
	@echo "  make test-code-reviewer        Test ghflow-code-reviewer"
	@echo "  make test-feature-implementer  Test ghflow-feature-implementer"
	@echo "  make test-orchestrator         Test ghflow-orchestrator"
	@echo "  make test-project-setup        Test ghflow-project-setup"
	@echo ""
	@echo "  make clean                Remove test artifacts"
	@echo ""
	@echo "Prerequisites:"
	@echo "  - gh CLI authenticated (gh auth login)"
	@echo ""

install:
	@echo "Installing test dependencies with uv..."
	uv venv
	uv pip install -r requirements.txt
	@echo "✓ Dependencies installed"

test:
	@echo "Running all tests (E2E + all skills)..."
	bash run_all_tests.sh

e2e:
	@echo "Running end-to-end workflow test..."
	source .venv/bin/activate && pytest test_e2e_workflow.py -v -s

skills: test-issue-expander test-pr-creator test-code-reviewer test-feature-implementer test-orchestrator test-project-setup
	@echo ""
	@echo "🎉 All skill tests complete!"

test-issue-expander:
	@echo "Testing ghflow-issue-expander..."
	bash $(SKILLS_DIR)/ghflow-issue-expander/tests/test_scripts.sh

test-pr-creator:
	@echo "Testing ghflow-pr-creator..."
	bash $(SKILLS_DIR)/ghflow-pr-creator/tests/test_scripts.sh

test-code-reviewer:
	@echo "Testing ghflow-code-reviewer..."
	bash $(SKILLS_DIR)/ghflow-code-reviewer/tests/test_scripts.sh

test-feature-implementer:
	@echo "Testing ghflow-feature-implementer..."
	bash $(SKILLS_DIR)/ghflow-feature-implementer/tests/test_scripts.sh

test-orchestrator:
	@echo "Testing ghflow-orchestrator..."
	bash $(SKILLS_DIR)/ghflow-orchestrator/tests/test_scripts.sh

test-project-setup:
	@echo "Testing ghflow-project-setup..."
	bash $(SKILLS_DIR)/ghflow-project-setup/tests/test_scripts.sh

clean:
	@echo "Cleaning up test artifacts..."
	rm -rf __pycache__ .pytest_cache .venv
	rm -f .coverage
	@echo "✓ Cleaned"
