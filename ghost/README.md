# Ghost Blog for ComputeStacks

This follows the official Ghost [Dockerfile](https://github.com/docker-library/ghost/tree/9d29c5d929829dc623e04ca8cc522fba2d6f87de/2/debian).

Changes made are:

 - Setting UID/GID of `node` user
 - Moving `/var/lib/ghost` to `/var/lib/ghost-source`
 - Changed `VOLUME` definition to `/var/lib/ghost` instead of `/var/lib/ghost/content`
 - Entrypoint will copy contents from `/var/lib/ghost-source` to `/var/lib/ghost` if the directory is _not_ empty.


These changes were made because:

  1. ComputeStacks users use an SFTP container to mount the volume and will need full access to the ghost directory.
  2. We force a UID to match what their SFTP container will be. This ensures no user permission issues arise.
  3. Because we're mounting the entire ghost directory, we need to place that outside of the volume directory, and move that _after_ the volume is mounted.
