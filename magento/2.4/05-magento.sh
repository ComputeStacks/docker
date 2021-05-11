#!/bin/bash
set -euo pipefail

wait_for_db() {
  counter=0
  echo >&2 "Connecting to database at $MYSQL_HOST"
  while ! mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PW -e "USE mysql;" >/dev/null; do
    counter=$((counter+1))
    if [ $counter == 30 ]; then
      echo >&2 "Error: Couldn't connect to database."
      exit 1
    fi
    echo >&2 "Trying to connect to database at $MYSQL_HOST. Attempt $counter..."
    sleep 5
  done
}

setup_db() {
  echo >&2 "Creating the database..."
  mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PW --skip-column-names -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DB_NAME;"
}

cron_template() {
  cat<<EOF
##
# Magento crontab
#
# This will be loaded into the container's crontab on boot. 
#

# See: https://www.optiweb.com/magento-2-cron-issues/
10 0 * * * flock -n /var/www/html/.cron-clean.lock /usr/bin/mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PW -e 'DELETE FROM $MYSQL_DB_NAME.cron_schedule WHERE created_at < DATE_SUB(NOW(), INTERVAL 1 DAY)';

#~ MAGENTO START f37deed947b2ea951ad6f939b8ab752bc79587e3d77f40d06f20f0657c98e94d
* * * * * flock -n /var/www/html/.magento-cron.lock /usr/local/lsws/lsphp72/bin/php /var/www/html/magento/bin/magento cron:run 2>&1 | grep -v "Ran jobs by schedule" >> /var/www/html/magento/var/log/magento.cron.log
* * * * * flock -n /var/www/html/.magento-cron.lock /usr/local/lsws/lsphp72/bin/php /var/www/html/magento/update/cron.php >> /var/www/html/magento/var/log/update.cron.log
* * * * * flock -n /var/www/html/.magento-cron.lock /usr/local/lsws/lsphp72/bin/php /var/www/html/magento/bin/magento setup:cron:run >> /var/www/html/magento/var/log/setup.cron.log
#~ MAGENTO END f37deed947b2ea951ad6f939b8ab752bc79587e3d77f40d06f20f0657c98e94d
EOF
}

persist_cron() {  
  if ! [ -f /var/www/html/magento_crontab ]; then
    cron_template > /var/www/html/magento_crontab    
  fi
  echo >&2 "Enabling Magento Cron"
  chown user:www-data /var/www/html/magento_crontab
  chmod 664 /var/www/html/magento_crontab
  touch /root/clear_crontab
  crontab -u user /root/clear_crontab
  crontab -u user /var/www/html/magento_crontab
}

# Always wait for database before allowing the container to start.
wait_for_db

if [ ! -d /var/www/html/magento ]; then  
  setup_db

  echo >&2 "Copying files..."
  mkdir -p /var/www/html/magento
  cd /var/www/html/magento
  tar --create \
      --file - \
      --one-file-system \
      --directory /usr/src/magento \
      --owner "www-data" --group "www-data" \
      . | tar --extract --file -    
  
  
  echo >&2 "Begining Installation..."
  # Installation Process 
  php bin/magento setup:install --base-url $PROTO://$DEFAULT_DOMAIN --db-host $MYSQL_HOST --db-name $MYSQL_DB_NAME --db-user $MYSQL_USER --db-password $MYSQL_PW --admin-firstname admin --admin-lastname admin --admin-email $MAGE_EMAIL --admin-user $MAGE_USERNAME --admin-password $MAGE_PW --language en_GB --currency $CURRENCY --timezone $TIMEZONE --use-rewrites 1 --backend-frontname admin  --search-engine elasticsearch7 --elasticsearch-host $ES_HOST --elasticsearch-enable-auth false --elasticsearch-port 9200 --elasticsearch-index-prefix magento2 --elasticsearch-timeout 15
  chown -R www-data:www-data /var/www/html  

  # Ensure proper permissions for the www-data group (owner may be user or www-data)
  echo >&2 "Please wait...Configuring permissions..."
  chmod 775 /var/www/html/magento
  echo >&2 "...Setting file permissions..."
  find . -type f -exec chmod 664 {} \;
  echo >&2 "...Setting folder permissions..."
  find . -type d -exec chmod 775 {} \;
  echo >&2 "Magento has been successfully installed, finalizing system configuration..." 
fi

persist_cron