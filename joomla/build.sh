#!/bin/bash

set -e 

docker build --no-cache -t cmptstks/joomla:php7.4 .

docker tag cmptstks/joomla:php7.4 cmptstks/joomla:latest

docker push cmptstks/joomla:php7.4
docker push cmptstks/joomla:latest
