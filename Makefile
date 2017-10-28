# Simple Makefile for faster running commands

LCD=$(shell pwd)

# Settings for colourful output
RED=$(shell tput setaf 1)
GREEN=$(shell tput setaf 2)
YELLOW=$(shell tput setaf 3)
CYAN=$(shell tput setaf 6)
NC=$(shell tput sgr0)


.PHONY: usage
usage:
	@echo ""
	@echo "$(GREEN)Targets:$(NC)"
	@echo ""
	@echo "  $(CYAN)bump-ver-patch$(NC)                - Bump version: Patch"
	@echo ""

.PHONY: bump-ver-patch
bump-ver-patch:
	bumpversion patch

