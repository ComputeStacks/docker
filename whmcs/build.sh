#!/bin/bash

set -e

docker build --no-cache -t cmptstks/whmcs:php7.3-litespeed litespeed/php7.3

docker tag cmptstks/whmcs:php7.3-litespeed cmptstks/whmcs:latest

docker push cmptstks/whmcs:php7.3-litespeed
docker push cmptstks/whmcs:latest
