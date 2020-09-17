FROM debian:buster-slim

LABEL maintainer="ComputeStacks <support@computestacks.com>"

# - Install packages
# - Fix default group (1000 does not exist)
# - OpenSSH needs /var/run/sshd to run
# - Remove generic host keys, entrypoint generates unique keys
RUN set -ex; \
    \
    apt-get update; \
    apt-get -y upgrade; \
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
            mariadb-client \
            postgresql-client \
            php \
            php-curl \
            php-json \
            php-phar \
            php-dom \
            php-mysql \
            php-cli \
            php-pgsql \
            php-readline \
            openssl \
            ca-certificates \
            openssh-server \
            gnupg2 \
            make \
            iputils-ping \
    ; \
    curl -sL https://deb.nodesource.com/setup_12.x | bash -; \
    apt-get install -y nodejs; \
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -; \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list; \
    apt-get update && apt-get install yarn \
    ; \
    apt-get clean \
    && rm -rf /var/lib/apt/lists/*;
    
RUN sed -i 's/GROUP=1000/GROUP=1000/' /etc/default/useradd \
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

# Install WP CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O wp \
    && mv wp /usr/bin/ \
    && chmod +x /usr/bin/wp

COPY sshd_config /etc/ssh/sshd_config
COPY vimrc /
COPY tmux /
COPY motd /etc/motd

COPY entrypoint.sh /entrypoint
RUN chmod +x /entrypoint

EXPOSE 22

ENTRYPOINT ["/entrypoint"]
