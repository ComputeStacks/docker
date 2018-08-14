FROM cmptstks/php:5.6-apache
MAINTAINER ComputeStacks <support@computestacks.com>

RUN apt-get update \
		&& apt-get install -y \
       cron \
       supervisor \
		&& rm -rf /var/lib/apt/lists/* 

COPY 000-default.conf /etc/apache2/sites-enabled
COPY whmcs-cron /etc/crontab
COPY index.html /usr/src/sample/index.html
COPY docker-entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
