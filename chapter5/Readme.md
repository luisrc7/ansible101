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