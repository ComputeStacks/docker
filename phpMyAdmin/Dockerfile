FROM cmptstks/php:7.2-apache

MAINTAINER ComputeStacks <support@computestacks.com>

RUN wget -O /usr/src/phpmyadmin.zip https://files.phpmyadmin.net/phpMyAdmin/4.8.2/phpMyAdmin-4.8.2-all-languages.zip

RUN cd /usr/src \
		&& unzip phpmyadmin.zip \
		&& mv phpMyAdmin* pma

COPY pma.ini /usr/local/etc/php/conf.d

COPY docker-entrypoint.sh /usr/local/bin/

CMD ["apache2-foreground"]