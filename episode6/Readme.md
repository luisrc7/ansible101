## Ep. 6
https://www.youtube.com/watch?v=JFweg2dUvqM

### Ansible Vault. (chapter 5)
It is better to be safe than to be sorry, you may be following the secure best practices, but you can't esnure all the devs will, so you must not use sensitive data like keys in your code. You need a way to encrypt them.
**Step 1**: You can use the ansible vault to encrypt the file under a prompt password with:
```
ansible-vault encrypt vars/api_key.yml
```
Asks for a prompt password and we type `test` for this demo only (not secure...)
Now the `api_key.yml` looks like: 
```
$ANSIBLE_VAULT;1.1;AES256
64653161663562336562343361326137663337346463636565343831663439303366316632386465
6461613863306536346631396563356561383031363532310a303437643035653430636134633034
61343861346234373934393137363261303437626464313531633237353164663562313765326364
3261363235323161610a656364623961616162363135313062386235616135653334336237393632
33653534396336396535326362303630346232616563393337623034363231366134316639396333
3562356234333731303962383235373861653434393162666636
```
Now in order to run the same playbook as before, to print the API Key, we need to run the playbook passing the password. You can run the playbook command with `--ask-valut-pass` and you can enter the passwd in the prompt.
Having to enter the passwd is not the best option when automating, so you can supply a passwd file.
You can do that having a plain text passwd file and using the parameter `--vault-password-file=/path/to/plaintext/password.txt` to the playbook command.
Instead of decrypting the file to be able to edit it, you can use `ansible-vault edit vars/api_key.yml` so you can edit the file without decrypting it and risking any accidental leak of secrets.
You can also inline encrypt some variables in a file instead the full file, but it looks cleaner to use a separate vars file for all the encrypted variables and others with public vars.

### Ansible Roles. (chapter 6)
In order to reduce the number of lines in a playbook and organise the playbooks better by families or related tasks they can be included.
You can use `- import_tasks: filename` to include a full file.
Also available `- include_tasks: filename` this way you can have dynamically information in the tasks.
You can also include a whole playbook with `- import_playbook: filename`.
This is quite handy to organise the playbook under the different technologies or group of tasks that you have to do, here an example of the simplified playbook:
```
---
- name: Install apache.
  hosts: all
  become: true

  handlers:
    - import_tasks: handlers/apache.yml

  pre_tasks:
    - name: Load variable files.
      include_vars: "{{ item }}"
      with_first_found: 
        - vars/apache_{{ ansible_os_family }}.yml
        - vars/apache_default.yml

  tasks:
    - import_tasks: tasks/apache.yml

- import_playbook: app.yml
```
But when there is still complexity Ansible has also the option to organise tasks as roles.
