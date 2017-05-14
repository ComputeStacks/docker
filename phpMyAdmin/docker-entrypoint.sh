#!/bin/bash
set -e

if [ ! -f "/var/www/html/config.inc.php" ]; then
  cd /var/www/html
  rm config.sample.inc.php
  wget -O /var/www/html/config.inc.php $BASE_URL/$API_URL?h=$HOSTNAME
  chown www-data:www-data /var/www/html/config.inc.php
  chmod 640 /var/www/html/config.inc.php
fi

exec "$@"
