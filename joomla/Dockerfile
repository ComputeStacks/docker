FROM joomla:php7.4

RUN usermod -u 1001 www-data \
    && groupmod -g 1001 www-data \
    && chown -R www-data:www-data /usr/src/joomla \
    && chown -R www-data:www-data /var/www/html
