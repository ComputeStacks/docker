#!/bin/bash
set -e

if [ ! -d "/var/www/html/magento" ]; then
  mysql -h $MAGENTO_MYSQL_HOST -u$MAGENTO_MYSQL_USER -p$MAGENTO_MYSQL_PASS -e "CREATE DATABASE IF NOT EXISTS ${MAGENTO_MYSQL_DBNAME};"
  mv /usr/src/magento /var/www/html/
  chown -R www-data:www-data /var/www/html
  sed -i 's#CACHE_SERVER_HOST#'"$MEMCACHE_HOST"'#' /var/www/html/magento/app/etc/mage-cache.xml
  sed -i 's#CACHE_SERVER_PORT#'"$MEMCACHE_PORT"'#' /var/www/html/magento/app/etc/mage-cache.xml
fi

exec "$@"
