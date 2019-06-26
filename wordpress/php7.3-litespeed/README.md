# Wordpress with PHP 7.3 Open Litespeed

```bash

docker run -d --rm --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD="sUper3R4nd0m" mariadb:10.3

docker run --rm -it \
  -e LS_ADMIN_PW="changeme0" \
  -e WORDPRESS_DB_HOST="host.docker.internal" \
  -e WORDPRESS_DB_USER="root" \
  -e WORDPRESS_DB_PASSWORD="sUper3R4nd0m" \
  -e WORDPRESS_DB_NAME="wordpress" \
  -e WORDPRESS_DB_PORT="3306" \
  -e WORDPRESS_URL="localhost:3000" \
  -e WORDPRESS_TITLE="mysite" \
  -e WORDPRESS_USER="admin" \
  -e WORDPRESS_PASSWORD="sUper3R4nd0m" \
  -e WORDPRESS_EMAIL="user@example.com" \
  -p 3000:80 \
  -p 3001:443 \
  -p 7080:7080 \
  cmptstks/wordpress:php7.3-litespeed /sbin/my_init -- bash -l

```