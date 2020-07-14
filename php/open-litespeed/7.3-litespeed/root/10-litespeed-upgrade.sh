#!/bin/bash

set -e

if [ ! -d /usr/src/lsws ]; then
  echo "/usr/src/lsws does not exist, exiting upgrade process."
  exit 0
fi

if [ ! -f /usr/src/lsws/VERSION ]; then
  echo "/usr/src/lsws/VERSION does not exist, exiting upgrade process."
  exit 0
fi

if [ -f /usr/local/lsws/.upgrade-lock ]; then
  echo "Upgrade process already running, exiting upgrade process."
  exit 0
fi

touch /usr/local/lsws/.upgrade-lock

CURRENT_VERSION=$(cat /usr/local/lsws/VERSION)
NEW_VERSION=$(cat /usr/src/lsws/VERSION)

if [ $CURRENT_VERSION != $NEW_VERSION ]; then
  echo "Current OpenLiteSpeed version is $CURRENT_VERSION, upgrading to $NEW_VERSION"
  if [ -f /usr/src/openlitespeed_${LS_VERSION}_amd64.deb ]; then
    dpkg -i /usr/src/openlitespeed_${LS_VERSION}_amd64.deb
  else
    echo "Fatal error, /usr/src/openlitespeed_${LS_VERSION}_amd64.deb"
  fi
else
  echo "Installed version matches current version, exiting upgrade process."
fi

rm /usr/local/lsws/.upgrade-lock
