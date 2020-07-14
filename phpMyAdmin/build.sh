#!/bin/bash

set -e

docker build --no-cache -t cmptstks/phpmyadmin:latest .

docker push cmptstks/phpmyadmin:latest
