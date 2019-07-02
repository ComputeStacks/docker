# PHP 7.2 Open Litespeed Container

## Litespeed Configuration
All configuration is stored in a separate, persistent, volume under `/usr/local/lsws`. To modify this, either mount the volume and edit the files directly, or use the built-in OpenLiteSpeed administrator located here: `https://<container-service>:7080`.

## Cron
Place your cronjobs in the `crontab` file located under `/var/www/`. This will automatically be copied to `/etc/cron.d` when the container is booted. Please be sure to restart the container after any change to this file.