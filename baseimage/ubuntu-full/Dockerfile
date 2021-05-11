FROM phusion/baseimage:focal-1.0.0

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
            ca-certificates \
            wget \
            lsb-release \
            iputils-ping \
    ; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;