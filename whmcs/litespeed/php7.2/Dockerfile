# docker run --rm -it -e LS_ADMIN_PW=changeme -p 3000:80 -p 7080:7080 cmptstks/whmcs:v762-php7.2-litespeed /sbin/my_init -- bash -l
FROM cmptstks/php:7.2-litespeed

LABEL maintainer="ComputeStacks <hello@computestacks.com>"

ENV WHMCS_VERSION 762
# shasum -a 256 <filepath>
ENV WHMCS_HASH "364a2ce7e0001f8e992e2b214b75ca30eefe2d62b4407ec29e9a83defd47b3f0"

COPY 05-whmcs.sh /etc/my_init.d/

RUN curl https://cdn.cmptstks.com/packages/whmcs/whmcs_v${WHMCS_VERSION}_full.zip > /usr/src/whmcs.zip \
    && echo "%{WHMCS_HASH} /usr/src/whmcs.zip | shasum -c -"; \
    unzip -d /usr/src/ /usr/src/whmcs.zip \
    && mv /usr/src/whmcs /usr/src/whmcs-public \
    && mkdir /usr/src/whmcs \
    && mv /usr/src/whmcs-public /usr/src/whmcs/ \
    && mv /usr/src/whmcs/whmcs-public/configuration.php.new /usr/src/whmcs/whmcs-public/configuration.php \
    && echo "#*/5 * * * * www-data /usr/local/lsws/lsphp72/bin/php -q /var/www/html/whmcs/whmcs-public/crons/cron.php" >> /usr/src/default/crontab \
    && mkdir /usr/src/whmcs/whmcs-updates \
    && chmod +x /etc/my_init.d/05-whmcs.sh

COPY vhconf.conf /usr/src/lsws/conf/vhosts/Default/
