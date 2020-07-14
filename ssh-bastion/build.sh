#!/bin/bash

set -e

docker build --no-cache -t cmptstks/ssh:beta .

docker tag cmptstks/ssh:beta cmptstks/ssh:latest
docker push cmptstks/ssh:beta
docker push cmptstks/ssh:latest
