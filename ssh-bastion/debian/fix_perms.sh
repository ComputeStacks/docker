#!/bin/bash

cd /home
for user in *; do
    chown $user:users $user
done