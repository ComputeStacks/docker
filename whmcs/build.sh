#!/bin/bash

docker build --no-cache -t cmptstks/whmcs:php7.2-litespeed litespeed/php7.2

docker tag cmptstks/whmcs:php7.2-litespeed cmptstks/whmcs:latest

# docker push cmptstks/whmcs:php7.2-litespeed
# docker push cmptstks/whmcs:latest