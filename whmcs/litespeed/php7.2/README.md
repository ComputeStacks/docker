# WHMCS Container with PHP 7.2 and OpenLitespeed

```bash

docker run -d --rm --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD="sUper3R4nd0m" mariadb:10.3

docker run --rm -it \
  -e LS_ADMIN_PW="changeme0" \
  -e DB_HOST="host.docker.internal" \
  -e DB_USER="root" \
  -e DB_PASSWORD="sUper3R4nd0m" \
  -e DB_NAME="whmcs" \
  -p 3000:80 \
  -p 7080:7080 \
  cmptstks/whmcs:v762-php7.2 /sbin/my_init -- bash -l

```