#!/bin/bash
set -euo pipefail

wait_for_db() {
  counter=0
  echo >&2 "Connecting to database at $DB_HOST"
  while ! mysql -h $DB_HOST -P ${DB_PORT:-3306} -u $DB_USER -p$DB_PASSWORD -e "USE mysql;" >/dev/null; do
    counter=$((counter+1))
    if [ $counter == 30 ]; then
      echo >&2 "Error: Couldn't connect to database."
      exit 1
    fi
    echo >&2 "Trying to connect to database at $DB_HOST. Attempt $counter..."
    sleep 5
  done
}

setup_db() {
  echo >&2 "Creating the database..."
  mysql -h $DB_HOST -P ${DB_PORT:-3306} -u $DB_USER -p$DB_PASSWORD --skip-column-names -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
}

if [ ! -d /var/www/html/whmcs ]; then
  echo >&2 "No whmcs installation found in volume - copying default files..."
  mv /usr/src/whmcs /var/www/html/
  chown -R www-data:www-data /var/www/html/
  echo >&2 "Complete! Sample files have been successfully copied to /var/www/html/whmcs"

  wait_for_db
  setup_db
fi
