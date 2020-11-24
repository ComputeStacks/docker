#!/bin/bash
set -e

docker build -t cmptstks/ghost:3 .
docker tag cmptstks/ghost:3 cmptstks/ghost:latest

docker push cmptstks/ghost:3
docker push cmptstks/ghost:latest
