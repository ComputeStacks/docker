#!/bin/bash

set -e

docker build --no-cache -t cmptstks/baseimage:latest ubuntu-full/

docker push cmptstks/baseimage:latest