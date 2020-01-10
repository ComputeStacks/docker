# MySQL Automated Backup Tool

This is a simple tool which:

* Pulls a list of known mysql containers from the ComputeStacks API
* Runs `mysqldump` on an hourly basis, creating a single compressed archive per database
* Uses `rsync` to push the backups to a remote server


This image only supports using SSH keys to connect to the destination server. Upon initial boot, check the container logs for the public SSH key.

MySQL dumps will be rsynced to the remote directory and saved in the following format:

`YYYYMMDD/dbname_YYYY-MM-DD-HHMM.tar.gz`

## Motivations

**ComputeStacks already includes a backup tool that takes point-in-time snapshots of your entire volume, with specific plugins for MariaDB _(using Mariabackup)_ & MySQL _(using xtrabackup)_, why would I want this?**

This tool is specifically designed for situations where you're trying to either a) create per-database backups (rather than entire database server), and/or b) want to create automated off-site backups with another provider.

## Deploying on ComputeStacks

The image should already be installed and available in the order system, but if it's not, you can ask your provider for help getting that ready, or add it yourself as a custom image.

You will first want to make sure that a MariaDB or MySQL container already exists in the project you will be adding this to, or ensure that you include a new database container as part of the order process.

### Adding & Setting Up the Container

* Choose the MySQL Backup Tool container from the order screen
* The next screen will ask for a series of settings:
  * `Backup Server`: This is the IP Address of your backup server, where all backups will be uploaded.
  * `Backup To Path`: This is the path on the backup server where the files will be placed. 
  * `Backup Server User`: Username to connect to the backup server with
  * `Backup Server Port`: The SSH port on the backup server
  * `Backup Frequency`: The default is `daily`, but other possible options are: `15min`, `daily`, `monthly`. 
* After you've finalized the order process, your next step will be to add the _MySQL Backup Tool_'s SSH key to your backup server.
  * Navigate to the Container Logs page:
    * Navigate to your project -> Click on the _MySQL Backup Tool_ service -> In the upper right-hand corner, click the gear icon, and select _Container Logs_. 
    * One of the first few things printed out will be the public SSH key. Add this to the `~/.ssh/authorized_keys` file for the backup server user.

#### Next Steps

Now that you've successfully configured this tool, you will begin to see backups arrive on your backup server, in the directory you specified, following the format `YYYYMMDD/dbname_YYYY-MM-DD-HHMM.tar.gz`. 

Please note that this image does not do any pruning on the remote backup server, so you will need to monitor that outside of this program and ensure you don't fill up your hard drive.

## Deploying with Docker

_**NOTE:** Because this will connect using the private IP of the MySQL container, this will currently only work while running on ComputeStacks_

```bash

docker run --rm -d \
  -e METADATA_AUTH="Provided automatically when run in a ComputeStacks environment" \
  -e METADATA_URL="Provided automatically when run in a ComputeStacks environment" \
  -e DEST_USER="rsync SSH user" \
  -e DEST_HOST="SSH server" \
  -e DEST_PATH="/path/to/my/backup/dir/on/ssh/server" \
  -e DEST_PORT="SSH Port (22)" \
  -e FREQ="One of: 15min, hourly, daily, monthly" \
  cmptstks/mysql-backup-tool

```

## Sources

* `crond.init` [Alpine Linux Repo](https://git.alpinelinux.org/aports/tree/main/busybox-initscripts/crond.initd)
* [Alpine OpenRC Image](https://github.com/dockage/alpine/blob/master/3.10/openrc/Dockerfile)
* [MySQL Backup tool](https://github.com/ComputeStacks/mysql-dumper)
