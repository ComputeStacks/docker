FROM cmptstks/wordpress:4-php7.2-apache

RUN wget https://downloads.wordpress.org/plugin/woocommerce.3.3.5.zip -O /tmp/temp.zip \
    && cd /usr/src/wordpress/wp-content/plugins \
    && unzip /tmp/temp.zip \
    && rm /tmp/temp.zip \
    && chown www-data:www-data -R /usr/src/wordpress/wp-content/plugins
