FROM cmptstks/wordpress

RUN wget https://downloads.wordpress.org/plugin/woocommerce.3.3.2.zip -O /tmp/temp.zip \
    && cd /usr/src/wordpress/wp-content/plugins \
    && unzip /tmp/temp.zip \
    && rm /tmp/temp.zip \
    && chown www-data:www-data -R /usr/src/wordpress/wp-content/plugins
