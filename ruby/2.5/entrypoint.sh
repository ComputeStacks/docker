#!/bin/bash
set -e

if ! [ "$(ls -A)" ]; then
  echo >&2 "No files found in $PWD - copying sample files..."
  tar cf - --one-file-system -C /usr/src/sample . | tar xf -
  echo >&2 "Complete! Sample files have been successfully copied to $PWD"
  echo >&2 "Running bundler.."
  bundle
  chown -R www-data:www-data /var/www
else
  echo >&2 "Files exist in volume, will not move sample files."
  echo >&2 "Running bundler.."
  bundle
fi

exec "$@"
