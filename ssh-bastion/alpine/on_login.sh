#!/bin/bash
# Configure permissions on SSH login
chown :users /home/sftpuser/apps
chown -R :users /home/sftpuser/apps
/bin/bash