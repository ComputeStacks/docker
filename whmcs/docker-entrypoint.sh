#!/bin/bash
set -e

if [ ! -d "/var/www/html/whmcs" ]; then
  mkdir -p /var/www/html/whmcs
  echo >&2 "No files found in $PWD - copying sample files..."
  cp /usr/src/sample/index.html /var/www/html/whmcs/
  echo >&2 "Complete! Sample files have been successfully copied to $PWD"
  chown -R www-data:www-data /var/www/html
else
  echo >&2 "Files exist in volume, will not move sample files.."
fi

exec "$@"
