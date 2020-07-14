#!/bin/bash

set -e

docker build --no-cache -t cmptstks/nginx:stable .

docker tag cmptstks/nginx:stable cmptstks/nginx:latest
docker push cmptstks/nginx:stable
docker push cmptstks/nginx:latest
