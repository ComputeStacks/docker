FROM cmptstks/php:7.3-apache

LABEL maintainer="ComputeStacks <hello@computestacks.com>"

ENV PMA_VERSION 5.0.4
ENV PMA_HASH 830bbca930d5e417ae4249931838e2c70ca0365044268fa0ede75e33aff677de

RUN wget -O /usr/src/phpmyadmin.zip https://files.phpmyadmin.net/phpMyAdmin/${PMA_VERSION}/phpMyAdmin-${PMA_VERSION}-all-languages.zip

RUN cd /usr/src \
    && echo "$PMA_HASH /usr/src/phpmyadmin.zip" | sha256sum -c -; \
    unzip phpmyadmin.zip \
    && mv phpMyAdmin* pma

COPY pma.ini /usr/local/etc/php/conf.d

COPY docker-entrypoint.sh /usr/local/bin/

CMD ["apache2-foreground"]
