#!/bin/bash

set -e

docker build --no-cache -t cmptstks/php:7.3-litespeed open-litespeed/7.3-litespeed
docker build --no-cache -t cmptstks/php:7.4-litespeed open-litespeed/7.4-litespeed

docker tag cmptstks/php:7.4-litespeed cmptstks/php:latest

docker push cmptstks/php:7.3-litespeed
docker push cmptstks/php:7.4-litespeed
docker push cmptstks/php:latest