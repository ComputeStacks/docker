#!/bin/bash

set -e

docker build -t cmptstks/php:7.2-litespeed open-litespeed/7.2-litespeed
docker build -t cmptstks/php:7.3-litespeed open-litespeed/7.3-litespeed

docker tag cmptstks/php:7.3-litespeed cmptstks/php:latest

docker push cmptstks/php:7.2-litespeed
docker push cmptstks/php:7.3-litespeed
docker push cmptstks/php:latest