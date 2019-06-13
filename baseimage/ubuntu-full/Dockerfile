FROM phusion/baseimage:0.11

LABEL maintainer="ComputeStacks <hello@computestacks.com>"

RUN groupadd -r mysql && useradd -r -g mysql mysql

RUN set -ex; \
    \
    apt-get update; \
    apt-get upgrade -y; \
    apt-get install -y \
            apt-utils \
            build-essential \
            software-properties-common \
            wget \
            lsb-release \
    ; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;