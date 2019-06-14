# MySQL Automated Backup Tool

This is a simple tool which:

  * Pulls a list of known mysql containers from the ComputeStacks API
  * Runs `mysqldump` on an hourly basis, creating a single compressed archive per database
  * Uses `rsync` to push the backups to a remote server


This image only supports using SSH keys to connect to the destination server. Upon initial boot, check the container logs for the public SSH key.

MySQL dumps will be rsynced to the remote directory and saved in the following format:

`YYYYMMDD/dbname_YYYY-MM-DD-HHMM.tar.gz`

# Example:

_**NOTE:** Because this will connect using the private ip of the MySQL container, this will currently only work while running on ComputeStacks_

```bash

docker run --rm -d \
  -e API_KEY="ComputeStacks API Key" \
  -e API_SECRET="ComputeStacks Secret API Key" \
  -e API_HOST="ComputeStacks API Endpoint, ex: https://portal.example.com/api" \
  -e PROJECT_ID="ComputeStacks Project ID" \
  -e DEST_USER="rsync SSH user" \
  -e DEST_HOST="SSH server" \
  -e DEST_PATH="/path/to/my/backup/dir/on/ssh/server" \
  -e DEST_PORT="SSH Port (22)" \
  -e FREQ="One of: 15min, hourly, daily, monthly" \
  cmptstks/mysql-backup  

```


Sources:

  * `crond.init` [Alpine Linux Repo](https://git.alpinelinux.org/aports/tree/main/busybox-initscripts/crond.initd)
  * [Alpine OpenRC Image](https://github.com/dockage/alpine/blob/master/3.9/openrc/Dockerfile)
  * [Mysql Backup tool](https://github.com/ComputeStacks/mysql-dumper)