FROM cmptstks/baseimage:latest

LABEL maintainer="ComputeStacks <hello@computestacks.com>"

RUN set -ex; \
    \
    apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8; \
    add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.2/ubuntu bionic main';

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y \
            mariadb-backup-10.2 \
            mariadb-client-10.2 \
    ; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;
