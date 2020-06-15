## Ep. 6
https://www.youtube.com/watch?v=FaXVZ60o8L8
Recomended: https://www.ansible.com/theres-a-role-for-that

### Ansible Galaxy. (chapter 6)
We can include roles from an expterna source like ansible galaxy from other people or ourselves in a centralised repository with `ansible-galaxy` command, we can include roles from a requirements file like in the 00-galaxy example.

```
ansible-galaxy install -r requirements.yml
```

Please note if not specified in the ansible.cfg the roles will be installed globally in the machine, you may want to keep then inside your Ansible structure like in the example.

### Ansible Testing and Validation.
We need different level of testing and validation in descendent order.

```
yamllint
ansible-playbook --syntax-check
ansible-lint
molecule test (integration)
ansible-playbook --check (against production)
Parallel infrastructure (have a pre-prod env. that you rebuild on each change)
```

Options:
Use a syntax highliter in your editor.

Using `debug` module in your playbook.

Using `fail` and `assert` modules in your playbook.
you can assert that a port is open, that a content in your web is present, etc.

Use `yamllint` to capture lint errors in your yaml syntax, install with `pip3 install yamllint` and then use it with your yaml files with `yamllint .`
You can configure the level of errors or to ignore some with a `.yamllint` file with somethign like:
```
---
extends: default

rules:
  truthy:
    allowed-values:
      - 'true'
      - 'false'
      - 'yes'
      - 'no'
```

Next would be to use an Ansible syntax-check. Running the playbook with the `--syntax-check` will flag any Ansible syntax error.
It will give a basick level of syntax check, is not clever enough to fix all runtime errors that may happen.

Ansible-lint will also check best practices for Ansible. First you need to install ansible lint with `pip3 install ansible-lint` then run it passing a playbook or role file e.g. `ansible-lint debug.yml` You can also configure some rules to ignore with a `.ansible-lint` file.

#### Molucule testing.

To install molecule you need to install `pip3 install molecule` then you can:

Create a new role with molecule:
```
molecule init role myrole
```

Then test it:
```
molecule test
```
You will need `pip3 install docker` to run your molecule test.

And test it but leaving the container running for further debugging:
```
molecule converge
```
then you can use `molecule login` to log into the container, or use docker.

Set a breakpoint using `fail:` in the tasks.

And you can remove everything with `molecule destroy`.