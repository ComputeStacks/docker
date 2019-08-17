#!/bin/bash

docker build --no-cache -t cmptstks/woocommerce:php7.3-litespeed .

docker tag cmptstks/woocommerce:php7.3-litespeed cmptstks/woocommerce:latest

# docker push cmptstks/woocommerce:php7.3-litespeed
# docker push cmptstks/woocommerce:latest