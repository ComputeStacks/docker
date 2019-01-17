#!/bin/bash
set -e

if ! [ "$(ls -A)" ]; then
  echo >&2 "No files found in $PWD - copying sample files..."
  tar cf - --one-file-system -C /usr/src/sample . | tar xf -
  echo >&2 "Complete! Sample files have been successfully copied to $PWD"
  if [ -f /usr/src/app/requirements.txt ]; then
    echo >&2 "Requirements file found, running pip.."
    pip install -r requirements.txt
  fi
  chown -R www-data:www-data /usr/src/app
else
  echo >&2 "Files exist in volume, will not move sample files."
  if [ -f /usr/src/app/requirements.txt ]; then
    echo >&2 "Requirements file found, running pip.."
    pip install -r requirements.txt
  fi
fi

if [ -f /usr/src/app/crontab ]; then
  if [ ! -L /etc/cron.d/myapp ]; then
    ln -s /usr/src/app/crontab /etc/cron.d/myapp
  fi
fi

if [ -f /usr/src/app/nginx.conf ]; then
  if [ ! -L /etc/nginx/conf.d/myapp.conf ]; then
    ln -s /usr/src/app/nginx.conf /etc/nginx/conf.d/myapp.conf
  fi
fi

if [ -f /usr/src/app/gunicorn.conf ]; then
  if [ ! -L /etc/supervisor/conf.d/gunicorn.conf ]; then
    ln -s /usr/src/app/gunicorn.conf /etc/supervisor/conf.d/gunicorn.conf
  fi
fi

exec "$@"
