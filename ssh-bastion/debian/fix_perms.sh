#!/bin/bash
cd /home
for user in *; do
    chown -R $user:users $user/*
done