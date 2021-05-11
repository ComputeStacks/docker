# PHP 7.4 Open Litespeed Container

## Litespeed Configuration
All configuration is stored in a separate, persistent, volume under `/usr/local/lsws`. To modify this, use the built-in OpenLiteSpeed administrator. View the domain in the control panel; it's using port `7080`.

## Cron
Place your cronjobs in the `crontab` file located under `/var/www/`. This will automatically be copied to `/etc/cron.d` when the container is booted. Please be sure to restart the container after any change to this file.