## Ep. 4
https://www.youtube.com/watch?v=SLW4LX7lbvE

### Inventory
Add a new AWS ubuntu image, user is ubuntu. Open port 8983 in the AWS instance.

### Installation and configuration of solr server in ubuntu remote server
Name playbook `main.yml` or other things, but be consistent, and also added `vars.yml` for the variables.

We are going to download and install solr in the server via this playbook.

**Notes**:
`command: >` will allow to add commands down that definitio and they will be expanded with a space between them, so it will be more readable.
e.g.
```
command: >
  ls 
  -asl
```
is equal to: 
```
command: ls -asl
```