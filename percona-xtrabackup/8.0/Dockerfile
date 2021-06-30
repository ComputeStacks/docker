FROM cmptstks/baseimage:latest

LABEL maintainer="ComputeStacks <hello@computestacks.com>"

RUN wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb \
    && dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb \
    && percona-release enable-only tools

RUN export DEBIAN_FRONTEND=noninteractive \
    && wget -O mysqlconfig.deb https://dev.mysql.com/get/mysql-apt-config_0.8.17-1_all.deb \
    && echo mysql-apt-config mysql-apt-config/select-server select mysql-8.0 | debconf-set-selections \
    && dpkg -i mysqlconfig.deb

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y \
            percona-xtrabackup-80 \
            mysql-client \
    ; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;
