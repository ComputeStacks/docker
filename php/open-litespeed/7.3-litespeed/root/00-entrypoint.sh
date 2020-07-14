#!/bin/bash

set -euo pipefail

if ! [ "$(ls -A /var/www)" ]; then
  echo >&2 "No files found in volume - copying default files..."
  mv /usr/src/default/* /var/www/
  chown -R www-data:www-data /var/www
  echo >&2 "Complete! Sample files have been successfully copied to /var/www/"
fi

if [ -f /var/www/crontab ]; then
  echo >&2 "Crontab found, moving to cron.d directory..."
  cp /var/www/crontab /etc/cron.d/myapp && chown root:root /etc/cron.d/myapp
else
  if [ -f /etc/cron.d/myapp ]; then
    echo >&2 "Removing stale crontab..."
    rm /etc/cron.d/myapp
  fi
fi

if ! [ "$(ls -A /usr/local/lsws)" ]; then
  echo >&2 "No files found in config volume - copying files..."
  mv /usr/src/lsws/* /usr/local/lsws/
  chown -R lsadm: /usr/local/lsws/conf/vhosts
  echo >&2 "Complete! Configuration files have been successfully copied to /usr/local/lsws/"
fi

if [[ -z "${LS_ADMIN_PW}" ]]; then
  echo >&2 "Litespeed admin password not set, leaving default of 123456."
else
  ENCRYPT_PASS=`/usr/local/lsws/admin/fcgi-bin/admin_php -q /usr/local/lsws/admin/misc/htpasswd.php $LS_ADMIN_PW`
  echo "admin:$ENCRYPT_PASS" > /usr/local/lsws/admin/conf/htpasswd
  if [ $? -eq 0 ]; then
    echo "Litespeed admin password successfully changed to ${LS_ADMIN_PW}".
  else
    echo "Failed to set Litespeed admin password to ${LS_ADMIN_PW}, leaving default at 123456."
  fi
fi