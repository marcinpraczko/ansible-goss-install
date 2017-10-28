# Ansible-goss-install

**Version 0.1.0**

This role aims help with installation of validation tool: ``goss``

- [Goss](https://github.com/aelsabbahy/goss)

There are already modules:

- [Goss Module 01 - Ansible Galaxy](https://galaxy.ansible.com/mcorbin/goss-module)
- [Goss Module 02 - Ansible Galaxy](https://galaxy.ansible.com/naftulikay/degoss/)

## Installation

### Directly from ansible-galaxy (latest release)
```bash
$ ansible-galaxy install marcinpraczko.goss-install
```

### Directly from github repository

Sometimes some changes has been applied to ``develop`` or ``feature`` branch and are not yet released.
Ansible-galaxy allows install roles directly from ``GitHub``.

```bash
mkdir testing-roles
cd testing-roles
ansible-galaxy install -p roles git+https://github.com/marcinpraczko/ansible-goss-install.git,develop
```

Above example will install ``develop`` branch. This can be adjusted to any git SHA commit, tag or branch
name - depends of requirements.

Checking what version is installed can be done with command:
```bash
ansible-galaxy list -p roles
```

## Variables

All important variables are in file: ``default/main.yml``.

## Example of playbooks

### Install to user directory

Following example will install ``goss`` in user home directory: ``${HOME}/bin``:

- ``${HOME}/bin`` - folder will be created.

```yaml
- name: "Install goss in home directory"
  hosts: all
  become: False
  gather_facts: False

  roles:
    - "marcinpraczko.goss-install"
```

### Install on system

Following example will install ``goss`` in system: ``/usr/local/bin``:

- ``${HOME}/bin`` - folder will be created.

```yaml
- name: "Install goss in system"
  hosts: all
  become: True
  gather_facts: False

  roles:
    - role: marcinpraczko.goss-install
      goss_dst_dir: /usr/local/bin
```

## Testing

Role this can be tested via ``molecule`` (need to be installed first) with commands:

```bash
# Docker and docker-py is required to allow to run full test
molecule test
```

For more detail about molecule, please visit:

- [Molecule](https://molecule.readthedocs.io/en/latest/)
