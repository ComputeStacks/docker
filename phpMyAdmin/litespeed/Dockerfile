FROM cmptstks/php:7.4-litespeed

LABEL maintainer="ComputeStacks <hello@computestacks.com>"

ENV PMA_VERSION 5.1.0
ENV PMA_HASH 2f29fbfc8884c42290f950b077e0a8af2766507f959f30caef0edaa5fd3e04b9

RUN wget -O /usr/src/phpmyadmin.zip https://files.phpmyadmin.net/phpMyAdmin/${PMA_VERSION}/phpMyAdmin-${PMA_VERSION}-all-languages.zip

RUN cd /usr/src \
    && echo "$PMA_HASH /usr/src/phpmyadmin.zip" | sha256sum -c -; \
    unzip phpmyadmin.zip \
    && mv phpMyAdmin* pma

RUN sed -i 's/memory_limit = .*/memory_limit = 256M/g' /usr/src/lsws/lsphp74/etc/php/7.4/litespeed/php.ini \
    && sed -i 's/upload_max_filesize = .*/upload_max_filesize = 1024M/g' /usr/src/lsws/lsphp74/etc/php/7.4/litespeed/php.ini \
    && echo "post_max_size = 1200M" >> /usr/src/lsws/lsphp74/etc/php/7.4/litespeed/php.ini

COPY 05-pma-startup.sh /etc/my_init.d/

