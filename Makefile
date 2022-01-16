# ============================================================================
# Self-documented makefile
# ============================================================================

.PHONY: help
help: ## HELP: Show this help message
	@echo 'usage: make [target] ...'
	@echo
	@echo 'Targets:'
	@echo '========'
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'


.PHONY: bump-version-patch
bump-version-patch: ## DEVELOP: Bump version - patch level
	bumpversion patch


.PHONY: create-python3-venv
create-python3-venv: ## DEVELOP: Create python venv and install PIP packages
	scripts/create-python3-venv.sh

# .PHONY: test-molecule
# test-molecule: ## DEVELOP: Test installing role with molecule
# 	molecule test
