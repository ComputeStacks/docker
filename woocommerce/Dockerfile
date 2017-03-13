FROM cmptstks/wordpress

RUN apt-get -y update \
    && apt-get -y install unzip wget \
    && wget https://downloads.wordpress.org/plugin/woocommerce.2.6.14.zip -O /tmp/temp.zip \
    && cd /usr/src/wordpress/wp-content/plugins \
    && unzip /tmp/temp.zip \
    && rm /tmp/temp.zip \
    && chown www-data:www-data -R /usr/src/wordpress/wp-content/plugins
