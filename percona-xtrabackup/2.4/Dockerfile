# Percona: https://www.percona.com/doc/percona-xtrabackup/2.4/xtrabackup_bin/xbk_option_reference.html 
# BaseImage: https://github.com/phusion/baseimage-docker

FROM cmptstks/baseimage:ubuntu-full

LABEL maintainer="ComputeStacks <hello@computestacks.com>"

RUN wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb \
    && dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y \
            percona-xtrabackup-24 \
            mysql-client \
    ; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;
