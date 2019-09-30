# docker run --rm -it -e LS_ADMIN_PW=changeme -p 3000:80 -p 7080:7080 cmptstks/whmcs:v762-php7.2-litespeed /sbin/my_init -- bash -l
FROM cmptstks/php:7.2-litespeed

LABEL maintainer="ComputeStacks <hello@computestacks.com>"

ENV WHMCS_VERSION 783
# shasum -a 256 <filepath>
ENV WHMCS_HASH "3bb2600a8c5d89b73a9243e3990cb1461a07c8703fe3726c2e3c6a7cfb19a638"

COPY 05-whmcs.sh /etc/my_init.d/

RUN curl https://cdn.computestacks.net/packages/whmcs/whmcs_v${WHMCS_VERSION}_full.zip > /usr/src/whmcs.zip \
    && echo "%{WHMCS_HASH} /usr/src/whmcs.zip | shasum -c -"; \
    unzip -d /usr/src/ /usr/src/whmcs.zip \
    && mv /usr/src/whmcs /usr/src/whmcs-public \
    && mkdir /usr/src/whmcs \    
    && mv /usr/src/whmcs-public /usr/src/whmcs/ \
    && echo "#*/5 * * * * www-data /usr/local/lsws/lsphp72/bin/php -q /var/www/html/whmcs/whmcs-public/crons/cron.php" >> /usr/src/default/crontab \
    && mkdir /usr/src/whmcs/whmcs-updates \
    && mkdir /usr/src/whmcs/whmcs-private \
    && chmod +x /etc/my_init.d/05-whmcs.sh

COPY vhconf.conf /usr/src/lsws/conf/vhosts/Default/
