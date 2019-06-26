#!/bin/bash
set -e

if ! [ "$(ls -A)" ]; then
  echo >&2 "No files found in $PWD - copying sample files..."
  tar cf - --one-file-system -C /usr/src/sample . | tar xf -
  echo >&2 "Complete! Sample files have been successfully copied to $PWD"
  chown -R www-data:www-data /var/www/html
else
  echo >&2 "Files exist in volume, will not move sample files.."
fi

exec "$@"
