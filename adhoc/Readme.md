## Ep. 3
https://www.youtube.com/watch?v=WNmKjtWtqIc


### Running in the background.
1. Add "timeout" to ansible command with `-B` and then No. seconds.
1. `-P` gives you a pulling time in seconds. You can run and have it in the background and then report if it has finished.

e.g. `ansible -i inventory multi -b -B 3600 -P 0 -a "yum -y update"`


This will give you an Ansible jobID you can use later to check the progress.
e.g. `ansible -i inventory db -b -m async_status -a "jid=77132174950.4698"`


Ansible modules: 
* Cron.
* Git.
