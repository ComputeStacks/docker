#!/bin/bash

set -eux

docker build -t cmptstks/alpine-passenger:r2.6-6.0.5 .
docker tag cmptstks/alpine-passenger:r2.6-6.0.5 cmptstks/alpine-passenger:latest
