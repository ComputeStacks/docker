#!/bin/bash

docker build --no-cache -t cmptstks/php:7.2-apache apache/7.2-apache
docker build --no-cache -t cmptstks/php:7.3-apache apache/7.3-apache
docker build --no-cache -t cmptstks/php:7.2-litespeed open-litespeed/7.2-litespeed
docker build --no-cache -t cmptstks/php:7.3-litespeed open-litespeed/7.3-litespeed

docker tag cmptstks/php:7.3-litespeed cmptstks/php:latest

# docker push cmptstks/php:7.2-apache
# docker push cmptstks/php:7.3-apache
# docker push cmptstks/php:7.2-litespeed
# docker push cmptstks/php:7.3-litespeed
# docker push cmptstks/php:latest