[![Snyk Known Vulnerabilities](https://snyk.io//test/github/marcinpraczko/ansible-goss-install/badge.svg?targetFile=requirements.txt)](https://snyk.io//test/github/marcinpraczko/ansible-goss-install?targetFile=requirements.txt) [![Galaxy](https://img.shields.io/badge/galaxy-dockpack.base__goss-blue.svg?style=flat)](https://galaxy.ansible.com/marcinpraczko/goss-install)  


# Ansible-goss-install

- Ansible Role Version: `0.1.10`
- Goss Version: `0.4.6`

## Goss resources

- [Goss Github](https://github.com/goss-org/goss)
- [Goss Github Relases](https://github.com/goss-org/goss/releases)

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

- ``/usr/local/bin`` - folder will be created.

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

### There is GitHub Action for testing

- [Molecule Test](https://github.com/marcinpraczko/ansible-goss-install/actions/workflows/molecule-test.yml)

### Locally

This role can be tested via ``molecule`` with commands (Following commands will install it):

```bash
make python3-create-venv
make test-molecule            # WARNING: Uses default Ansible driver, tests run on local machine as if installing.
```

For more detail about molecule, please visit:

- [Molecule](https://molecule.readthedocs.io/en/latest/)
- [Molecule CI](https://ansible.readthedocs.io/projects/molecule/ci/)
- [Ansible about molecule](https://ansible.readthedocs.io/projects/molecule/getting-started/)

