#!/bin/bash
set -e

wait_for_db() {
  counter=0
  echo >&2 "Connecting to database at $MYSQL_HOST"
  while ! curl --silent $MYSQL_HOST:$MYSQL_PORT >/dev/null; do
    counter=$((counter+1))
    if [ $counter == 30 ]; then
      echo >&2 "Error: Couldn't connect to database."
      exit 1
    fi
    echo >&2 "Trying to connect to database at $MYSQL_HOST. Attempt $counter."
    sleep 5
  done
}

setup_db() {
  echo >&2 "Creating the database"
  DB_EXISTS=`/usr/bin/mysql -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER -p$MYSQL_PW --skip-column-names -e "SHOW DATABASES LIKE '$MYSQL_DB_NAME'"`
  if [ ! $DB_EXISTS == $MYSQL_DB_NAME ]; then
    /usr/bin/mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PW --skip-column-names -e "CREATE DATABASE $MYSQL_DB_NAME;"
  else
    echo "Database $MYSQL_DB_NAME already exists. Skipping setup."
  fi
}

if [ ! -f "/var/www/html/whmcs/whmcs-public/index.php" ]; then
  mkdir -p /var/www/html/whmcs
  echo >&2 "No files found in $PWD - copying files..."
  cp -R /usr/src/whmcs/ /var/www/html/
  echo >&2 "Complete! WHMCS has been successfully copied to $PWD"
  chown -R www-data:www-data /var/www/html
  if [ ! -e "/var/www/html/whmcs/whmcs-public/.htaccess" ]; then
    cat > /var/www/html/whmcs/whmcs-public/.htaccess <<-'EOF'
SetEnvIf X-Forwarded-Proto "https" HTTPS=on
EOF

  fi
  chown -R www-data:www-data /var/www/html  

  wait_for_db
  setup_db

  ln -s /var/www/html/whmcs/crontab /etc/cron.d/whmcs

else
  echo >&2 "Files exist in volume, will not move sample files.."
fi

exec "$@"
