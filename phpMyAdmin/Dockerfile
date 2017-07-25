FROM cmptstks/php:7.1-apache

MAINTAINER ComputeStacks <support@computestacks.com>

RUN wget -O /usr/src/phpmyadmin.zip https://files.phpmyadmin.net/phpMyAdmin/4.7.3/phpMyAdmin-4.7.3-all-languages.zip

RUN cd /usr/src \
		&& unzip phpmyadmin.zip \
		&& mv phpMyAdmin* pma

COPY pma.ini /usr/local/etc/php/conf.d

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["apache2-foreground"]