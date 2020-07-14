#!/bin/bash

set -e 

docker build --no-cache -t cmptstks/wordpress:php7.3-litespeed php7.3-litespeed/

docker tag cmptstks/wordpress:php7.3-litespeed cmptstks/wordpress:latest

docker push cmptstks/wordpress:php7.3-litespeed
docker push cmptstks/wordpress:latest