FROM cmptstks/php:7.3-apache

LABEL maintainer="ComputeStacks <hello@computestacks.com>"

ENV PMA_VERSION 4.9.0.1
ENV PMA_HASH 04ef793d42c70e891429de134d91de38464801abe195022786486c3e88c9e403

RUN wget -O /usr/src/phpmyadmin.zip https://files.phpmyadmin.net/phpMyAdmin/${PMA_VERSION}/phpMyAdmin-${PMA_VERSION}-all-languages.zip

RUN cd /usr/src \
		&& echo "$PMA_HASH /usr/src/phpmyadmin.zip" | sha256sum -c -; \
		unzip phpmyadmin.zip \
		&& mv phpMyAdmin* pma

COPY pma.ini /usr/local/etc/php/conf.d

COPY docker-entrypoint.sh /usr/local/bin/

CMD ["apache2-foreground"]