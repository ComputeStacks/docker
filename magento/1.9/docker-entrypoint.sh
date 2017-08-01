#!/bin/bash
set -euo pipefail

if [ ! -d "/var/www/html/magento" ]; then
  sleep 10
  mysql -h $MAGENTO_MYSQL_HOST -u $MAGENTO_MYSQL_USER -P $MAGENTO_MYSQL_PORT -p$MAGENTO_MYSQL_PASS -e "CREATE DATABASE IF NOT EXISTS ${MAGENTO_MYSQL_DBNAME};"
  mv /usr/src/magento /var/www/html/
  chown -R www-data:www-data /var/www/html
  sed -i 's#CACHE_SERVER_HOST#'"$MEMCACHE_HOST"'#' /var/www/html/magento/app/etc/mage-cache.xml
  sed -i 's#CACHE_SERVER_PORT#'"$MEMCACHE_PORT"'#' /var/www/html/magento/app/etc/mage-cache.xml
  sed -i "s/<dbname>magento/<dbname>${MAGENTO_MYSQL_DBNAME}/" /var/www/html/magento/app/etc/config.xml
  sed -i "s/<host>localhost/<host>${MAGENTO_MYSQL_HOST}:${MAGENTO_MYSQL_PORT}/" /var/www/html/magento/app/etc/config.xml
  sed -i "s/<username\/>/<username>${MAGENTO_MYSQL_USER}<\/username>/" /var/www/html/magento/app/etc/config.xml
  sed -i "s/<password\/>/<password>${MAGENTO_MYSQL_PASS}<\/password>/" /var/www/html/magento/app/etc/config.xml  
fi

exec "$@"