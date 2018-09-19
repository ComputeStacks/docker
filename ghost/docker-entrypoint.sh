#!/bin/bash
set -e

if [ -z "$(ls -A /var/lib/ghost)" ]; then
  cp -R /var/lib/ghost-source/* /var/lib/ghost/
  chown node:node -R /var/lib/ghost
fi

if [[ "$*" == node*current/index.js* ]]; then
  baseDir="$GHOST_INSTALL/content.orig"
  for src in "$baseDir"/*/ "$baseDir"/themes/*; do
    src="${src%/}"
    target="$GHOST_CONTENT/${src#$baseDir/}"
    mkdir -p "$(dirname "$target")"
    if [ ! -e "$target" ]; then
      tar -cC "$(dirname "$src")" "$(basename "$src")" | tar -xC "$(dirname "$target")"
    fi
  done
fi

exec "$@"