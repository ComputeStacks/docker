#!/bin/bash

set -e

docker build --no-cache -t cmptstks/woocommerce:php7.4-litespeed .

docker tag cmptstks/woocommerce:php7.4-litespeed cmptstks/woocommerce:latest

docker push cmptstks/woocommerce:php7.4-litespeed
docker push cmptstks/woocommerce:latest