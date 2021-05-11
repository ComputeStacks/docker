FROM cmptstks/php:7.3-apache

LABEL maintainer="ComputeStacks <hello@computestacks.com>"

ENV PMA_VERSION 5.1.0
ENV PMA_HASH 2f29fbfc8884c42290f950b077e0a8af2766507f959f30caef0edaa5fd3e04b9

RUN wget -O /usr/src/phpmyadmin.zip https://files.phpmyadmin.net/phpMyAdmin/${PMA_VERSION}/phpMyAdmin-${PMA_VERSION}-all-languages.zip

RUN cd /usr/src \
    && echo "$PMA_HASH /usr/src/phpmyadmin.zip" | sha256sum -c -; \
    unzip phpmyadmin.zip \
    && mv phpMyAdmin* pma

COPY pma.ini /usr/local/etc/php/conf.d

COPY docker-entrypoint.sh /usr/local/bin/

CMD ["apache2-foreground"]
