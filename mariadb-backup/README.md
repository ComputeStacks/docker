# MariaDB Backup Utility

See: https://mariadb.com/kb/en/library/mariabackup-overview/ 

This image, unlike other similar container images, is designed to startup and run detached (using runinit) and have the mariadb volumes mounted to `/data`. 

When it's time to perform a backup, execute: `docker exec -i <container> mariabackup <options>`