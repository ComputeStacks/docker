FROM cmptstks/php:7.1-apache
MAINTAINER ComputeStacks <support@computestacks.com>

ARG whmcs_version=760

RUN apt-get update \
		&& apt-get install -y \
       cron \
       supervisor \
		&& rm -rf /var/lib/apt/lists/* 

RUN curl https://storage.googleapis.com/cstacks/docker_assets/whmcs/whmcs_v${whmcs_version}_full.zip > /usr/src/whmcs.zip \
    && unzip -d /usr/src/ /usr/src/whmcs.zip \
    && mv /usr/src/whmcs /usr/src/whmcs-public \
    && mkdir /usr/src/whmcs \
    && mv /usr/src/whmcs-public /usr/src/whmcs/ \
    && mv /usr/src/whmcs/whmcs-public/crons /usr/src/whmcs/ \
    && mv /usr/src/whmcs/whmcs-public/configuration.php.new /usr/src/whmcs/whmcs-public/configuration.php \
    && mkdir /usr/src/whmcs/whmcs-updates

COPY 000-default.conf /etc/apache2/sites-enabled
COPY docker-entrypoint.sh /usr/local/bin/
COPY whmcs-cron /usr/src/whmcs/crontab

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
