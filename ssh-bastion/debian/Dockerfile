FROM debian:stretch

MAINTAINER ComputeStacks <support@computestacks.com>

# - Install packages
# - Fix default group (1000 does not exist)
# - OpenSSH needs /var/run/sshd to run
# - Remove generic host keys, entrypoint generates unique keys
RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y \
            zip \
            unzip \
            vim \
            nano \
            libxml2-dev \
            libbz2-dev \
            libmcrypt-dev \
            libcurl4-gnutls-dev \
            libc-client-dev \
            libkrb5-dev \
            libxslt-dev \
            zlib1g-dev \
            libicu-dev \
            g++ \
            wget \
            rsync \
            tmux \
            git \
            curl \
            mysql-client \
            php \
            php-curl \
            php-json \
            php-phar \
            php-dom \
            php-mysql \
            php-cli \
            php-pgsql \
            php-mcrypt \
            php-readline \
            openssl \
            ca-certificates \
            openssh-server \
            gnupg2 \
            make \
    ;

COPY nodejs.sh /
RUN bash /nodejs.sh

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y \
            nodejs \
    ; \
    rm -rf /var/lib/apt/lists/*;


RUN sed -i 's/GROUP=1000/GROUP=100/' /etc/default/useradd \
    && mkdir -p /var/run/sshd \
    && rm -f /etc/ssh/ssh_host_*key*

COPY fix_perms.sh /

RUN mkdir /etc/sftp.d \
    && mv /fix_perms.sh /etc/sftp.d/fix-permissions \
    && chmod +x /etc/sftp.d/fix-permissions

# Install PHP Composer
RUN wget https://getcomposer.org/composer.phar -O composer \
    && mv composer /usr/bin/composer \
    && chmod +x /usr/bin/composer \
    && composer self-update

COPY sshd_config /etc/ssh/sshd_config
COPY vimrc /
COPY tmux /
COPY motd /etc/motd

COPY entrypoint.sh /entrypoint
RUN chmod +x /entrypoint

EXPOSE 22

ENTRYPOINT ["/entrypoint"]
