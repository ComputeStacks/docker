#!/bin/bash

set -e

docker build --no-cache -t cmptstks/whmcs:php7.3-litespeed litespeed/php7.3
docker build --no-cache -t cmptstks/whmcs:php7.4-litespeed litespeed/php7.4

docker tag cmptstks/whmcs:php7.4-litespeed cmptstks/whmcs:latest

docker push cmptstks/whmcs:php7.3-litespeed
docker push cmptstks/whmcs:php7.4-litespeed
docker push cmptstks/whmcs:latest
