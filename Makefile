# ============================================================================
# Based on page: https://gist.github.com/prwhite/8168133
#
# Example of self-documented makefile
#
# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
# ============================================================================

##
## General
##

################################################################################
# Help target
################################################################################
# TODO: For now this is displaying '^' charater between target and description
help:: ## Help: Show this help text
	@gawk -vG=$$(tput setaf 2) -vR=$$(tput sgr0) ' \
		match($$0, "^(([^#:]*[^ :]) *:)?([^#]*)##([^#].+|)$$",a) { \
			if (a[2] != "") { printf "    make %s%-30s%s %s\n", G, a[2], R, a[4]; next } \
			if (a[3] == "") { print a[4]; next } \
			printf "\n%-36s %s\n","",a[4] \
		}' $(MAKEFILE_LIST)
	@echo "" # blank line at the end
.DEFAULT_GOAL := help

.PHONY: bump-version-patch
bump-version-patch: ## Bump version - patch level
	bumpversion patch --verbose

.PHONY: python3-create-venv
python3-create-venv: ## Create python venv and install PIP packages
	scripts/create-python3-venv.sh

##
## Goss - release versions
##
GOSS_VERSION_TO_CHECK := 0.4.10
GOSS_ARCHIVE_FILENAME := goss_$(GOSS_VERSION_TO_CHECK)_linux_x86_64.tar.gz
GOSS_SHA256SUMS_FILENAME := goss_$(GOSS_VERSION_TO_CHECK)_SHA256SUMS

.PHONY: goss-check-releases-versions
goss-check-releases-versions: ## Check the latest goss releases versions
	@echo ""
	@echo "Checking implemented versions in 'defaults/main.yml'"
	@grep -E "^goss_(version|sha256sum)"  defaults/main.yml
	@echo ""
	@echo "Checking the latest goss releases versions (GH CLI)"
	@gh release list -R github.com/goss-org/goss

.PHONY: goss-download-release
goss-download-release: ## Download goss release
	@echo "Downloading goss release v$(GOSS_VERSION_TO_CHECK)"
	wget -c -o tmp/$(GOSS_ARCHIVE_FILENAME).log -O tmp/$(GOSS_ARCHIVE_FILENAME) \
		https://github.com/goss-org/goss/releases/download/v$(GOSS_VERSION_TO_CHECK)/$(GOSS_ARCHIVE_FILENAME)
	wget -c -o tmp/$(GOSS_SHA256SUMS_FILENAME).log -O tmp/$(GOSS_SHA256SUMS_FILENAME) \
		https://github.com/goss-org/goss/releases/download/v$(GOSS_VERSION_TO_CHECK)/$(GOSS_SHA256SUMS_FILENAME)

.PHONY: goss-verify-release-sha256sum
goss-verify-release-sha256sum: ## Verify sha256 sum for goss release
	@echo "Checking goss release sha256sum"
	@cd tmp && grep "  $(GOSS_ARCHIVE_FILENAME)$$" $(GOSS_SHA256SUMS_FILENAME) | sha256sum -c

.PHONY: goss-clean-release-files
goss-clean-release-files: ## Clean goss release files
	@echo "Cleaning goss release"
	rm -vf tmp/$(GOSS_ARCHIVE_FILENAME)* tmp/$(GOSS_SHA256SUMS_FILENAME)*

##
## Testing ansible role
##

.PHONY: testing-installation
testing-installation: ## Testing installation ansible role running on vagrant
	@echo ""
	@echo "For testing please navigate to 'tests' folders and run"
	@echo ""
	@echo "  make                                - for general help"
	@echo "  make vagrant-up-prepare             - Prepare vagrant"
	@echo "  make test-all-afer-build-and-deploy - Prepare vagrant"
	@echo ""
