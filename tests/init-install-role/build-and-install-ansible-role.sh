#!/bin/bash 

function replace-version-in-requirements() {
    local version=$1
    echo ""
    echo "Replacing version in requirements.yml (VERSION: $version)"
    sed -e "s/|VERSION|/${version}/g" /vagrant/tests/init-install-role/requirements.yml.templ > /vagrant/tests/init-install-role/requirements.yml
}

function install_ansible_role() {
    echo ""
    echo "Using Ansible-Galaxy to install roles"
    echo "Installing Ansible Role"
    ansible-galaxy install --force -r /vagrant/tests/init-install-role/requirements.yml

    echo ""
    echo "Displaying list of roles"
    ansible-galaxy list
}

# === MAIN CODE ===
# Check if VERSION argument is provided
if [ -z "$1" ]; then
    echo "Error: VERSION argument is required"
    exit 1
fi

VERSION="$1"

replace-version-in-requirements $VERSION
install_ansible_role
