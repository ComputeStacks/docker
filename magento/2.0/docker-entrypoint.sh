#!/bin/bash
set -e

# Always ensure `user` password is correct.
echo "user:$SSH_PASS" | chpasswd

wait_for_db() {
  counter=0
  echo >&2 "Connecting to database at $MYSQL_HOST"
  while ! curl --silent $MYSQL_HOST:$MYSQL_PORT >/dev/null; do
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
# See: https://www.optiweb.com/magento-2-cron-issues/
10 0 * * * flock -n /var/www/html/.cron-clean.lock /usr/bin/mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PW -e 'DELETE FROM $MYSQL_DB_NAME.cron_schedule WHERE created_at < DATE_SUB(NOW(), INTERVAL 1 DAY)';

#~ MAGENTO START deff52d65faca28212b87b919287022e
* * * * * flock -n /var/www/html/.cron.lock /usr/local/bin/php /var/www/html/magento/bin/magento cron:run 2>&1 | grep -v "Ran jobs by schedule" >> /var/www/html/magento/var/log/magento.cron.log
* * * * * flock -n /var/www/html/.update-cron.lock /usr/local/bin/php /var/www/html/magento/update/cron.php >> /var/www/html/magento/var/log/update.cron.log
* * * * * flock -n /var/www/html/.setup-cron.lock /usr/local/bin/php /var/www/html/magento/bin/magento setup:cron:run >> /var/www/html/magento/var/log/setup.cron.log
#~ MAGENTO END deff52d65faca28212b87b919287022e
EOF
}

persist_cron() {  
  if ! [ -f /var/www/html/crontab_template ]; then
    cron_template > /var/www/html/crontab_template
  fi
  echo >&2 "Installing Magento Cron"
  # cd /var/www/html/magento && su user -c "php bin/magento cron:install"
  chown user:www-data /var/www/html/crontab_template
  touch /root/clear_crontab
  crontab -u user /root/clear_crontab
  crontab -u user /var/www/html/crontab_template
}

postfix_config() {
  cat<<EOF
# Postfix SMTP Relay Configuration
# Note: This file replaces the main.cf file, so you can completely customize Postfix's settings here.
#
# Once you've made your changes, you either need to restart the container, if from a shell run:
#    supervisorctl restart postfix
#

# General Configuration
smtpd_banner = \$myhostname ESMTP $mail_name (Debian/GNU)
biff = no
append_dot_mydomain = no
readme_directory = no
compatibility_level = 2
smtpd_tls_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
smtpd_tls_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
smtpd_use_tls=yes
smtpd_tls_session_cache_database = btree:\${data_directory}/smtpd_scache
smtp_tls_session_cache_database = btree:\${data_directory}/smtp_scache
smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination
myhostname = $HOSTNAME
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
myorigin = /etc/mailname
mydestination = \$myhostname, docker.local, $HOSTNAME, localhost.localdomain, localhost
mynetworks = 127.0.0.0/8
mailbox_size_limit = 0
recipient_delimiter = +
inet_interfaces = all
inet_protocols = ipv4
smtp_always_send_ehlo = yes
smtp_helo_name = $HOSTNAME

# SMTP Relay Information
smtp_sasl_auth_enable = yes 
smtp_sasl_password_maps = static:$SMTP_USERNAME:$SMTP_PASSWORD
smtp_sasl_security_options = noanonymous 
smtp_sasl_tls_security_options = noanonymous
smtp_tls_security_level = encrypt
smtp_tls_loglevel = 1
header_size_limit = 4096000
relayhost = [$SMTP_SERVER]:$SMTP_PORT
EOF
}

config_postfix() {
  echo >&2 "Configuring postfix..."
  if ! [ -f /var/www/html/postfix.cf ]; then    
    postfix_config > /var/www/html/postfix.cf
    chown user:www-data /var/www/html/postfix.cf
  fi
  rm /etc/postfix/main.cf
  ln -s /var/www/html/postfix.cf /etc/postfix/main.cf
  FILES="etc/localtime etc/services etc/resolv.conf etc/hosts etc/nsswitch.conf"
  for file in $FILES; do
    if [ -f /var/spool/postfix/${file} ]; then
      rm /var/spool/postfix/${file}
    fi
    cp /${file} /var/spool/postfix/${file}
    chmod a+rX /var/spool/postfix/${file}
  done
}

if ! [ "$(ls -A)" ]; then
  echo >&2 "No files found in $PWD - installing magento..."

  # Update Motd

  cat << 'EOF' > /etc/motd

Magento 2 Container Image

WARNING: Any changes made outside of your volume (/var/www/html) will be lost!

EOF
  
  # Create DB
  wait_for_db
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
  php bin/magento setup:install --base-url https://$DEFAULT_DOMAIN --db-host $MYSQL_HOST --db-name $MYSQL_DB_NAME --db-user $MYSQL_USER --db-password $MYSQL_PW --admin-firstname admin --admin-lastname admin --admin-email $MAGE_EMAIL --admin-user $MAGE_USERNAME --admin-password $MAGE_PW --language en_GB --currency $CURRENCY --timezone $TIMEZONE --use-rewrites 1 --backend-frontname admin
  chown -R www-data:www-data /var/www/html
  chmod 550 /var/www/html/magento/app/etc
  echo >&2 "Magento has been successfully installed, finalizing system configuration..."
  persist_cron
  config_postfix
  echo >&2 "Final configuration completed, booting application..."
  
else
  echo >&2 "Files exist in volume, skipping installation..."
  echo >&2 "Checking configuration..."
  persist_cron
  config_postfix
  echo >&2 "App configured, booting application..."
fi

exec "$@"
