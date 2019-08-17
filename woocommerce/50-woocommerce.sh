#!/bin/bash
set -euo pipefail

cd /var/www/html/wordpress

if [ -d "/var/www/html/wordpress/wp-content/plugins/woocommerce" ]; then
  echo "WooCommerce appears to already exist, skipping installation."
else
  wp plugin install woocommerce --activate --allow-root
fi