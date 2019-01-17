FROM cmptstks/wordpress:5-php7.2-apache

LABEL maintainer="support@computestacks.com"

RUN wget https://downloads.wordpress.org/plugin/woocommerce.3.5.2.zip -O /tmp/temp.zip \
    && cd /usr/src/wordpress/wp-content/plugins \
    && unzip /tmp/temp.zip \
    && rm /tmp/temp.zip \
    && chown www-data:www-data -R /usr/src/wordpress/wp-content/
