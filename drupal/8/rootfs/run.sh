#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

DAEMON=httpd
EXEC=$(which $DAEMON)
ARGS="-f /opt/bitnami/apache/conf/httpd.conf -D FOREGROUND"

# drupal initialization leaves a running httpd instance
apachectl -k graceful-stop

# redirect apache logs to stdout/stderr
ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
ln -sf /dev/stdout /opt/bitnami/apache/logs/error_log

# Set permissions
chown -R daemon:daemon /bitnami

info "Starting ${DAEMON}..."
exec ${EXEC} ${ARGS}
