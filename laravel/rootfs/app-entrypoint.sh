#!/bin/bash -e
. /opt/bitnami/base/functions

print_welcome_page
check_for_updates &

INIT_SEM=/tmp/initialized.sem
PACKAGE_FILE=/app/composer.json

fresh_container() {
  [ ! -f $INIT_SEM ]
}

app_present() {
  [ -f /app/config/database.php ]
}

dependencies_up_to_date() {
  # It it up to date if the package file is older than
  # the last time the container was initialized
  [ ! $PACKAGE_FILE -nt $INIT_SEM ]
}

wait_for_db() {
  counter=0
  log "Connecting to mariadb at $DB_HOST"
  while ! curl --silent $DB_HOST:3306 >/dev/null; do
    counter=$((counter+1))
    if [ $counter == 30 ]; then
      log "Error: Couldn't connect to mariadb."
      exit 1
    fi
    log "Trying to connect to mariadb at $DB_HOST. Attempt $counter."
    sleep 5
  done
}

setup_db() {
  log "Configuring the database"
  sed -i "s/utf8mb4/utf8/g" /app/config/database.php
  DB_EXISTS=`/usr/bin/mysql -h $DB_HOST -u $DB_USERNAME -p$DB_PASSWORD --skip-column-names -e "SHOW DATABASES LIKE '$DB_DATABASE'"`
  if [ ! "$DB_EXISTS" == '$DB_DATABASE' ]; then
    /usr/bin/mysql -h $DB_HOST -u $DB_USERNAME -p$DB_PASSWORD --skip-column-names -e "CREATE DATABASE $DB_DATABASE;"
    php artisan migrate --force
  else
    echo "Database $DB_DATABASE already exists. Skipping migration."
  fi
}

if [ "${1}" == "php" -a "$2" == "artisan" -a "$3" == "serve" ]; then
  if ! app_present; then
    log "Creating laravel application"
    sudo cp -r /tmp/app/* /app/
    sudo chown -R bitnami:bitnami /app
  fi

  if ! dependencies_up_to_date; then
    log "Installing/Updating Laravel dependencies (composer)"
    composer update
    log "Dependencies updated"
  fi

  wait_for_db

  if ! fresh_container; then
    echo "#########################################################################"
    echo "                                                                         "
    echo " App initialization skipped:                                             "
    echo " Delete the file $INIT_SEM and restart the container to reinitialize     "
    echo " You can alternatively run specific commands using docker-compose exec   "
    echo " e.g docker-compose exec myapp php artisan make:console FooCommand       "
    echo "                                                                         "
    echo "#########################################################################"
  else
    setup_db
    log "Initialization finished"
    touch $INIT_SEM
  fi
fi

exec tini -- "$@"
