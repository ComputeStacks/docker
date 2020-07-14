FROM cmptstks/php:7.3-apache

LABEL maintainer="ComputeStacks <hello@computestacks.com>"

ENV PMA_VERSION 5.0.2
ENV PMA_HASH a6ea4f16ced9f2ce3a9b23d47c1cd0fee5a46ead9bd5f9ec76f8edfb7a153edc

RUN wget -O /usr/src/phpmyadmin.zip https://files.phpmyadmin.net/phpMyAdmin/${PMA_VERSION}/phpMyAdmin-${PMA_VERSION}-all-languages.zip

RUN cd /usr/src \
    && echo "$PMA_HASH /usr/src/phpmyadmin.zip" | sha256sum -c -; \
    unzip phpmyadmin.zip \
    && mv phpMyAdmin* pma

COPY pma.ini /usr/local/etc/php/conf.d

COPY docker-entrypoint.sh /usr/local/bin/

CMD ["apache2-foreground"]
