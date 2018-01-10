FROM alpine:3.5

MAINTAINER ComputeStacks <support@computestacks.com>

# - Install packages
# - Fix default group (1000 does not exist)
# - OpenSSH needs /var/run/sshd to run
# - Remove generic host keys, entrypoint generates unique keys
RUN echo "@community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk add --no-cache bash shadow@community openssl openssl-dev ca-certificates openssh openssh-sftp-server vim nano rsync tmux git curl mysql-client php5 php5-curl php5-openssl php5-json php5-phar php5-dom php5-mysql php5-cli php5-pgsql php5-pdo_mysql php5-mcrypt && \
    sed -i 's/GROUP=1000/GROUP=100/' /etc/default/useradd && \
    mkdir -p /var/run/sshd && \
    rm -f /etc/ssh/ssh_host_*key*


# Configure SSH Startup Script
COPY on_login.sh /usr/bin/on_login
RUN chmod 1750 /usr/bin/on_login

# Install PHP Composer
RUN wget https://getcomposer.org/composer.phar -O composer \
    && mv composer /usr/bin/composer \
    && chmod +x /usr/bin/composer \
    && composer self-update

COPY sshd_config /etc/ssh/sshd_config
COPY entrypoint /
COPY vimrc /
COPY tmux /
COPY motd /etc/motd

EXPOSE 22

ENTRYPOINT ["/entrypoint"]