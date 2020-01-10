FROM dockage/alpine:3.10-openrc

LABEL maintainer="ComputeStacks <hello@computestacks.com>"

RUN apk update \
    && apk add rsync openssh-keygen mariadb-client openssh

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY cron.sh /root/cron.sh
ADD https://github.com/ComputeStacks/mysql-dumper/releases/download/1.0.0/mysql-dumper /usr/local/bin/
COPY crond.init /etc/init.d/crond

RUN chmod 755 /usr/local/bin/entrypoint.sh \
    && chmod 755 /root/cron.sh \
    && chmod 755 /usr/local/bin/mysql-dumper \
    && chmod 755 /etc/init.d/crond \
    && rc-update add crond default

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/sbin/init"]