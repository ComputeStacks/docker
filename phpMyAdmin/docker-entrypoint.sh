#!/bin/bash

if ! [ -e index.php -a -e config.inc.php ]; then
  echo >&2 "phpMyAdmin not found in $PWD - copying now..."
  if [ "$(ls -A)" ]; then
    echo >&2 "WARNING: $PWD is not empty - press Ctrl+C now if this is an error!"
    ( set -x; ls -A; sleep 10 )
  fi
  tar cf - --one-file-system -C /usr/src/pma . | tar xf -
  echo >&2 "Complete! phpMyAdmin has been successfully copied to $PWD"
  chown -R www-data:www-data /var/www/html
  rm -rf /var/www/html/setup
fi

if [ -f "/var/www/html/config.sample.inc.php" ]; then
  rm /var/www/html/config.sample.inc.php
fi

if [ ! -f "/var/www/html/.htaccess" ]; then
  echo "SetEnvIf X-Forwarded-Proto \"https\" HTTPS=on" > /var/www/html/.htaccess
fi

wget -O /var/www/html/config.inc.php $BASE_URL/$API_URL?h=$HOSTNAME
chown www-data:www-data /var/www/html/config.inc.php
chmod 640 /var/www/html/config.inc.php

exec "$@"
