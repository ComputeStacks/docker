#!/bin/bash

docker build --no-cache -t cmptstks/mariadb-backup:10.1 10.1/
docker build --no-cache -t cmptstks/mariadb-backup:10.2 10.2/
docker build --no-cache -t cmptstks/mariadb-backup:10.3 10.3/
docker build --no-cache -t cmptstks/mariadb-backup:10.4 10.4/