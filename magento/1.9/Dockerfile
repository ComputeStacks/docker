FROM php:5.6-apache

MAINTAINER ComputeStacks

RUN a2enmod rewrite

RUN apt-get update \
		&& apt-get install -y libpng12-dev libjpeg-dev mariadb-client-10.0 libxml2-dev libmcrypt-dev \
		&& rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
		&& docker-php-ext-install gd

RUN docker-php-ext-install pdo_mysql \
		&& docker-php-ext-install soap \
		&& docker-php-ext-install mcrypt \
		&& docker-php-ext-install mbstring

VOLUME /var/www/html

COPY magento-1.9.2.4.tar.gz /usr/src/

RUN cd /usr/src \
    && tar -xzf magento-1.9.2.4.tar.gz -C /usr/src/ \
    && rm /usr/src/magento-1.9.2.4.tar.gz \
    && chown -R www-data:www-data /usr/src/magento \
    && cd /usr/src/magento \
    && rm -rf index.php.sample .htaccess.sample php.ini.sample LICENSE.txt STATUS.txt \
    && find . -type d -exec chmod 750 {} \; && find . -type f -exec chmod 640 {} \; \
    && chmod o+w var var/.htaccess app/etc \
    && chmod -R o+w media

RUN sed -i 's#DocumentRoot /var/www/html#DocumentRoot /var/www/html/magento#' /etc/apache2/sites-available/000-default.conf \
		&& sed -i 's#DocumentRoot /var/www/html#DocumentRoot /var/www/html/magento#' /etc/apache2/sites-available/default-ssl.conf \
		&& sed -i 's#DocumentRoot /var/www/html#DocumentRoot /var/www/html/magento#' /etc/apache2/apache2.conf

COPY cache.xml /usr/src/magento/app/etc/mage-cache.xml
COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
