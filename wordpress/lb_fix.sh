#!/bin/bash env
set -e

function append {
  cat <<EOF
if ( isset( \$_SERVER['HTTP_X_FORWARDED_FOR'] ) ) {
	\$http_x_headers = explode( ',', \$_SERVER['HTTP_X_FORWARDED_FOR'] );

	\$_SERVER['REMOTE_ADDR'] = \$http_x_headers[0];
}
EOF
}

function run
{
    append >> /var/www/html/wp-config.php
}

run
exit 0
