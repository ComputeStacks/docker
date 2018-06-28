FROM php:7.1-apache
MAINTAINER ComputeStacks <support@computestacks.com>

ARG php_redis=3.1.6
ARG php_memcache=3.0.4

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y \
            zip \
            unzip \
            libpng-dev \
            libjpeg62-turbo-dev \
            mysql-client \
            libxml2-dev \
            libbz2-dev \
            libmcrypt-dev \
            libmemcached-dev \
            libfreetype6-dev \
            libcurl4-gnutls-dev \
            libc-client-dev \
            libkrb5-dev \
            libxslt-dev \
            vim \
            nano \
            zlib1g-dev \
            libicu-dev \
            g++ \
            wget \
            imagemagick \
            libmagickwand-dev \
    ; \
    rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && pecl install imagick-3.4.3 \
    && docker-php-ext-enable imagick \
    && docker-php-ext-install -j$(nproc) \
                                pdo_mysql \
                                mysqli \
                                soap \
                                mbstring \
                                opcache \
                                bcmath \
                                bz2 \
                                curl \
                                iconv \
                                ftp \
                                soap \
                                json \
                                posix \
                                session \
                                sockets \
                                xml \
                                xmlrpc \
                                xmlwriter \
                                xsl \
                                zip \
                                wddx \
                                mcrypt

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=2'; \
        echo 'opcache.fast_shutdown=1'; \
        echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN a2enmod rewrite expires

COPY 000-default.conf /etc/apache2/sites-enabled
COPY logging.conf /etc/apache2/conf-enabled
COPY sample /usr/src/sample
COPY docker-entrypoint.sh /entrypoint.sh

RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/$php_redis.tar.gz \
    && tar -xzvf /tmp/redis.tar.gz -C /tmp \
    && mkdir -p /usr/src/php/ext \
    && mv /tmp/phpredis-$php_redis /usr/src/php/ext/redis \
    && rm -rf /tmp/redis.tar.gz \
    && docker-php-ext-install redis

COPY vendor/memcached-$php_memcache.tgz /tmp/memcached.tgz
RUN tar -xzvf /tmp/memcached.tgz \
    && mv memcached-$php_memcache /usr/src/php/ext/memcached \
    && rm /tmp/memcached.tgz \
    && docker-php-ext-install memcached

COPY vendor/ioncube_loader_lin_7.1.so /usr/local/lib/php/extensions/no-debug-non-zts-20160303
COPY vendor/00-ioncube.ini /usr/local/etc/php/conf.d

RUN chown root:staff /usr/local/lib/php/extensions/no-debug-non-zts-20160303/ioncube_loader_lin_7.1.so \
    && chmod +x /usr/local/lib/php/extensions/no-debug-non-zts-20160303/ioncube_loader_lin_7.1.so

RUN rm /var/www/html/package.xml

RUN usermod -u 1001 www-data \
    && groupmod -g 1001 www-data

WORKDIR /var/www/html

ENTRYPOINT ["/entrypoint.sh"]

CMD ["apache2-foreground"]
