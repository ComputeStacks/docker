#!/bin/bash
set -euo pipefail

# Always ensure `user` password is correct.
echo "user:$SSH_PASS" | chpasswd

cat << 'EOF' > /etc/motd

Magento 2 Container Image

WARNING: Any changes made outside of your volume (/var/www/) will be lost!

EOF
  
