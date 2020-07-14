#!/bin/bash

set -e

if [ -z ${HTTPASS+x} ]; then
  echo "Skipping htpasswd generation..."
else
  PASS=$(echo "$HTTPASS" | openssl passwd -apr1 -stdin)
  echo "admin:${PASS}" > /etc/nginx/htpasswd
fi

./usr/local/bin/nginx-lb &

exec "$@"
