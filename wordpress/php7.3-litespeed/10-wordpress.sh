#!/bin/bash
set -euo pipefail

mkdir -p /var/www/html/wordpress
cd /var/www/html/wordpress

wait_for_db() {
  counter=0
  echo >&2 "Connecting to database at $WORDPRESS_DB_HOST"
  while ! mysql -h $WORDPRESS_DB_HOST -u $WORDPRESS_DB_USER -p$WORDPRESS_DB_PASSWORD -e "USE mysql;" >/dev/null; do
    counter=$((counter+1))
    if [ $counter == 30 ]; then
      echo >&2 "Error: Couldn't connect to database."
      exit 1
    fi
    echo >&2 "Trying to connect to database at $WORDPRESS_DB_HOST. Attempt $counter..."
    sleep 5
  done
}

setup_db() {
  echo >&2 "Creating the database..."
  mysql -h $WORDPRESS_DB_HOST -u $WORDPRESS_DB_USER -p$WORDPRESS_DB_PASSWORD --skip-column-names -e "CREATE DATABASE IF NOT EXISTS $WORDPRESS_DB_NAME;"
}

if ! [ "$(ls -A)" ]; then
  echo >&2 "No files found in $PWD - installing wordpress..."  

  # Create DB
  wait_for_db
  setup_db

  mv /usr/src/wordpress/* .
  wp config create --dbhost=$WORDPRESS_DB_HOST --dbname=$WORDPRESS_DB_NAME --dbuser=$WORDPRESS_DB_USER --dbpass=$WORDPRESS_DB_PASSWORD --allow-root --extra-php << 'PHP'
// If we're behind a proxy server and using HTTPS, we need to alert Wordpress of that fact
// see also http://codex.wordpress.org/Administration_Over_SSL#Using_a_Reverse_Proxy
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
  $_SERVER['HTTPS'] = 'on';
}
define('FS_METHOD', 'direct'); 
define('WP_MEMORY_LIMIT', '96M');
PHP
  if [ ! -e .htaccess ]; then
    cat > .htaccess <<-'EOF'
# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPress
SetEnvIf X-Forwarded-Proto "https" HTTPS=on
EOF
    fi

  echo >&2 "Installing Wordpress..."
  wp core install --url=$WORDPRESS_URL --title="$WORDPRESS_TITLE" --admin_user=$WORDPRESS_USER --admin_password=$WORDPRESS_PASSWORD --admin_email="$WORDPRESS_EMAIL" --skip-email --allow-root

  echo >&2 "Installing litespeed cache..."
  wp plugin install litespeed-cache --allow-root

  echo >&2 "Installing SMTP plugin..."
  wp plugin install wp-mail-smtp --activate --allow-root

  echo >&2 "Restarting webserver to enable cache..."
  /usr/local/lsws/bin/lswsctrl restart

  chown -R www-data:www-data /var/www/html/

fi

# Take ownership of parent directories
chown www-data:www-data /var/www \
  && chown www-data:www-data /var/www/html \
  && chown www-data:www-data /var/www/html/wordpress
