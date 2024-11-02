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

GIT_WORKSPACE := $(shell git rev-parse --show-toplevel)


################################################################################
# Help target
################################################################################
# TODO: For now this is displaying '^' charater between target and description
help:: ## Help: Show this help text
	@gawk -vG=$$(tput setaf 2) -vR=$$(tput sgr0) ' \
		match($$0, "^(([^#:]*[^ :]) *:)?([^#]*)##([^#].+|)$$",a) { \
			if (a[2] != "") { printf "    make %s%-45s%s %s\n", G, a[2], R, a[4]; next } \
			if (a[3] == "") { print a[4]; next } \
			printf "\n%-36s %s\n","",a[4] \
		}' $(MAKEFILE_LIST)
	@echo "" # blank line at the end
.DEFAULT_GOAL := help


##
## Vagrant preparation and worklow
##

.PHONY: vagrant-up-prepare
vagrant-up-prepare: ## Prepare Vagrant environment
	@echo ""
	@echo "Starting Vagrant environment"
	cd $(GIT_WORKSPACE) && vagrant up
	@echo ""

# FIXME: Not working - vagrant is not able boot after snapshot
# @echo "Creating Vagrant snapshots (before tests)"
# cd $(GIT_WORKSPACE) && vagrant snapshot save before-ansible-role-testing
# echo ""
# echo "List of Vagrant snapshots"
# cd $(GIT_WORKSPACE) && vagrant snapshot list

.PHONY: vagrant-halt
vagrant-halt: ## Stop Vagrant environment (halt)
	@echo ""
	@echo "Stopping Vagrant environment"
	cd $(GIT_WORKSPACE) && vagrant halt
	@echo ""

.PHONY: vagrant-destroy
vagrant-destroy: ## Destory Vagrant environment (Force)
	@echo ""
	@echo "Destroying Vagrant environment"
	cd $(GIT_WORKSPACE) && vagrant destroy -f
	@echo ""

##
## Testing installation ansible role running on vagrant (Expected PASS)
##

# FIXME: B001: Setting ANSIBLE_CONFIG has no effect
# export ANSIBLE_CONFIG=/some/path/ansible-goss-install/tests/init-install-role/ansible.cfg

.PHONY: test01-install-as-user-gather-facts-enabled
test01-install-as-user-gather-facts-enabled: ## Install as user - 'gather facts' enabled
	@echo ""
	@echo "Running test01 - Install as user - 'gather facts' enabled"
	vagrant ssh -c 'cd /vagrant/tests/ && \
		ANSIBLE_STDOUT_CALLBACK=yaml ansible-playbook /vagrant/tests/playbook-install-as-user-with-gather-facts.yml'

.PHONY: test03-install-as-root-gather-facts-enabled
test03-install-as-root-gather-facts-enabled: ## Install as root - 'gather facts' enabled
	@echo ""
	@echo "Running test03 - Install as root - 'gather facts' enabled"
	vagrant ssh -c 'cd /vagrant/tests/ && \
		ANSIBLE_STDOUT_CALLBACK=yaml ansible-playbook /vagrant/tests/playbook-install-as-root-with-gather-facts.yml'

##
## Testing installation ansible role running on vagrant (Expected FAIL)
##

.PHONY: test02-install-as-user-gather-facts-disabled
test02-install-as-user-gather-facts-disabled: ## Install as user - 'gather facts' disabled
	@echo ""
	@echo "Running test02 - Install as user - 'gather facts' disabled"
	vagrant ssh -c 'cd /vagrant/tests/ && \
		ANSIBLE_STDOUT_CALLBACK=yaml ansible-playbook /vagrant/tests/playbook-install-as-user-without-gather-facts.yml'

.PHONY: test04-install-as-root-gather-facts-disabled
test04-install-as-root-gather-facts-disabled: ## Install as root - 'gather facts' disabled
	@echo ""
	@echo "Running test04 - Install as root - 'gather facts' disabled"
	vagrant ssh -c 'cd /vagrant/tests/ && \
		ANSIBLE_STDOUT_CALLBACK=yaml ansible-playbook /vagrant/tests/playbook-install-as-root-without-gather-facts.yml'

##
## Verifying installation of ansible role with goss on Vagrant
##

.PHONY: verify-all
verify-all: ## Verify all installations
verify-all: \
	verify-as-user-installation \
	verify-as-root-installation

.PHONY: verify-as-user-installation
verify-as-user-installation: ## Verify goss - normal user installation
	@echo ""
	@echo "Verifining with goss - NORMAL user installation"
	vagrant ssh -c '/home/vagrant/bin/goss -g /vagrant/tests/test-goss-as-user.yml validate --format tap'

.PHONY: verify-as-root-installation
verify-as-root-installation: ## Verify goss - root installation
	@echo ""
	@echo "Verifining with goss - ROOT installation"
	vagrant ssh -c '/usr/local/bin/goss -g /vagrant/tests/test-goss-as-root.yml validate --format tap'

##
## Building ansible role tarball and deploying on Vagrant
##

TARBALL_VERSION := $(shell cat $(GIT_WORKSPACE)/VERSION | cut -d "=" -f 2)-devel-next
TARBALL_DIR := $(GIT_WORKSPACE)/build
TARBALL_FILENAME := $(TARBALL_DIR)/marcinpraczko.goss-install-$(TARBALL_VERSION).tar.gz
TARBALL_FILES_TO_ADD := $(shell cd $(GIT_WORKSPACE) && git ls-files)

.PHONY: build-and-deploy-tarball
build-and-deploy-tarball: ## Build and deploy tarball on Vagrant
build-and-deploy-tarball: \
	build-tarball \
	deploy-tarball

.PHONY: build-tarball
build-tarball: ## Create tarball with role (excluding all files from .gitignore)
	@echo "Creating tarball for version $(TARBALL_VERSION) - exclude all files from .gitignore"
	@cd $(GIT_WORKSPACE) && tar -czf $(TARBALL_FILENAME) $(TARBALL_FILES_TO_ADD)
	@echo "Tarball created: $(TARBALL_FILENAME)"
	@ls -l $(TARBALL_FILENAME)

.PHONY: deploy-tarball
deploy-tarball: ## Deploy tarball on Vagrant
	vagrant ssh -c '/vagrant/tests/init-install-role/build-and-install-ansible-role.sh $(TARBALL_VERSION)'

##
## Testing - Install and verify goss installation on Vagrant
##

.PHONY: test-all-after-build-and-deploy
test-all-after-build-and-deploy: ## Test all installations after build and deploy tarball
test-all-after-build-and-deploy: \
	build-and-deploy-tarball \
	test-all

.PHONY: test-all
test-all: ## Test all installations
test-all: \
	test-as-user-installation \
	test-as-root-installation

.PHONY: test-as-user-installation
test-as-user-installation: ## Test Installation as user - 'gather facts' enabled and verify
test-as-user-installation: \
	test01-install-as-user-gather-facts-enabled \
	verify-as-user-installation

.PHONY: test-as-root-installation
test-as-root-installation: ## Test Installation as root - 'gather facts' enabled and verify
test-as-root-installation: \
	test03-install-as-root-gather-facts-enabled \
	verify-as-root-installation
