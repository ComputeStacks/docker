FROM joomla:3.8-php7.2-apache

RUN usermod -u 1001 www-data \
    && groupmod -g 1001 www-data \
    && chown -R www-data:www-data /usr/src/joomla \
    && chown -R www-data:www-data /var/www/html