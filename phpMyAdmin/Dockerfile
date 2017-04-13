FROM php:5.6-apache

MAINTAINER ComputeStacks <support@computestacks.com>

RUN a2enmod rewrite

RUN apt-get update \
		&& apt-get install -y wget vim unzip zip mariadb-client-10.0 libxml2-dev libmcrypt-dev \
		&& rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install mysqli \
		&& docker-php-ext-install mcrypt \
		&& docker-php-ext-install mbstring

RUN wget -O /usr/src/phpmyadmin.zip https://files.phpmyadmin.net/phpMyAdmin/4.6.6/phpMyAdmin-4.6.6-all-languages.zip

RUN rm -rf /var/www/html

RUN cd /usr/src \
		&& unzip phpmyadmin.zip \
		&& mv phpMyAdmin* html \
		&& mv html /var/www

RUN chown -R www-data:www-data /var/www/html \
		&& rm -rf /var/www/html/setup

RUN rm /etc/apache2/sites-enabled/000-default.conf

COPY 000-default.conf /etc/apache2/sites-enabled
COPY logging.conf /etc/apache2/conf-enabled

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["apache2-foreground"]
