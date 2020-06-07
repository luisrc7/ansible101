## Ep. 5
https://www.youtube.com/watch?v=HU-dkXBCPdU

### Playbooks.
Starting with 2 AWS servers one centOS and one Ubuntu.
We start with a basic apache playbook to install apache in the centos server.
**Step 1**: Add a handler to restart apache.
**Step 2**: Add an apache config file and call the handler in the task.
The handler will be executed at the end of the playbook, in order to inmediatly execute the handler you may add a task to flush the handlers so they will execute right away. (we've added the task "Make sure handlers are flushed inmediatly.")
If the playbook fails and we don't have the task to flush handlers the handlers will not execute.
Unless you run the ansible-playbook command with the option `--force-handlers`.
When working with handlers be careful and don't presume they will always run and that they run at the end of the playbook by default.
**Step 3**: if you need to run a second handler after executing your first handler.
There are various ways, one is that notify in your task can be a list, not just a string.
e.g. 
```
notify:
  - restart apache
  - restart memcached
```
Or the first handler cna actually notify another handler. So, handlers are basically ansible tasks.
**Step 4**: Env variables. There are several ways of doing it.
A quick way is a new task to add the vars into the `.bash_profile` of the remote user. like:
```
  tasks:
    - name: Add an environment variable to remote user's shell.
      lineinfile:
        dest: "~/.bash_profile"
        regex: '^ENV_VAR='
        line: 'ENV_VAR=value'
      become: false
```
To get the environment variable out you can use also a task like:
```
    - name: Get the value of an environemnt variable.
      shell: 'source ~/.bash_profile && echo $ENV_VAR'
      register: foo
      become: false

    - debug: msg="The variable is {{ foo.stdout }}"
```
And you can add persistent environments for all users with: 
```
    - name: Add an environment variable to remote user's shell.
      lineinfile:
        dest: "/etc/environment"
        regex: '^ENV_VAR='
        line: 'ENV_VAR=value'
```
Now task based environment setting.
You can set environment vars in the task with `environment:` like:
```
    - name: Download a file.
      get_url:
        url: http://ipv4.download.thinkbroadband.com/20MB.zip
        dest: /tmp
      environment:
        http_proxy: http:example-proxy:80/
```
In order to share these environment variables between different tasks you can set a variable at the playbook level with:
```
  vars:
    proxy_vars:
      http_proxy: http://example-proxy:80/
      https_proxy: https://example-proxy:80/

  handlers: 
    ...

  tasks:
    - name: Download a file.
      get_url:
        url: http://ipv4.download.thinkbroadband.com/20MB.zip
        dest: /tmp
      environment: proxy_vars        

```
And use them as in the example task calling that vars in the task.
If you want those enviroenmnt cariables to apply to all your playboo tasks you can set the environment at the playbook level as well.
```
  environment:
    http_proxy: http://example-proxy:80/
    https_proxy: https://example-proxy:80/

  handlers: 
    ...

  tasks:
    - name: Download a file.
      get_url:
        url: http://ipv4.download.thinkbroadband.com/20MB.zip
        dest: /tmp
```
Then you don't have to explicitly set them in the tasks as they will apply to all tasks in the playbook. !Note!: But they won't be persistent in the server.
**Step 5**: to include variables in the playbook you can do it in different ways:
```
  vars:
    key: value

  vars_files:
    - vars/main.yml
```
**Step 6**: modify the playbook to install apache in CentOS and Ubuntu with the same playbook using variables.
In order to may this works, first we abstract the differences between the OS and set variables for those items.
e.g.
```
  vars:
    apache_package: apache2
    apache_service: apache2
    apache_config_dir: /etc/apache2/sites-enabled
```
If we want to use different vars files we can configure a pre_task: 
```
  pre_tasks:
    - name: Load variable files.
      include_vars: "{{ item }}"
      with_first_found: 
        - vars/apache_{{ ansible_os_family }}.yml
        - vars/apache_default.yml
```
or try with Vars: 
```
vars_files:
  - vars/apache_default.yml
  - vars/apache_{{ ansible_os_family }}.yml
```
So, relying on the `ansible_os_family` variable you can have dinamically loaded files into your playbook with differnt settings.
That `ansible_os_family` comes from the Ansible facts that gather from each server (first task), you can check what is available with the `setup` module. e.g.
```
ansible -i inventory centos -m setup
```
**Step 7**: you can register any task and check the output with `debug` like:
```
    - name: Ensure apache is installed.
      package: 
        name: "{{ apache_package }}"
        state: present
      register: foo

    - debug: var=foo
```
To see information about that task.