#!/bin/sh

set -e

CURRENT_DAY=$(date '+%Y%m%d')
cd /tmp

echo "Preparing MySQL Backup Files..."
mysql-dumper

echo "Transporting backups..."
rsync -aP /tmp/*.gz backup:$DEST_PATH/$CURRENT_DAY
rm -rf /tmp/*.tar.gz
rm -rf /tmp/*.sql

echo "...Completed."

exit 0