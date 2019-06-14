#!/bin/sh

set -e

if [ ! -f /root/.ssh/id_ed25519 ]
then
  ssh-keygen -t ed25519 -f /root/.ssh/id_ed25519 -q -N ""
  ssh-keyscan -p $DEST_PORT $DEST_HOST >> /root/.ssh/known_hosts
  cat <<EOF > /root/.ssh/config
Host backup
  HostName ${DEST_HOST}
  Port ${DEST_PORT}
  User ${DEST_USER}
  IdentityFile /root/.ssh/id_ed25519
EOF
fi

if [ -f /root/cron.sh ]
then

  case $FREQ in
    15min)
      mv /root/cron.sh /etc/periodic/15min/backup
      ;;
    hourly)
      mv /root/cron.sh /etc/periodic/hourly/backup
      ;;
    daily)
      mv /root/cron.sh /etc/periodic/daily/backup
      ;;
    monthly)
      mv /root/cron.sh /etc/periodic/monthly/backup
      ;;
    *)
      echo "Invalid FREQ. Must be one of: 15min, hourly, daily, monthly"
      exit 1
  esac
  
fi

echo "Install the following public SSH key onto your backup server:"
echo $(cat /root/.ssh/id_ed25519.pub)
exec "$@"