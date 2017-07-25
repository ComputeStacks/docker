FROM php:5.6-apache

MAINTAINER ComputeStacks <support@computestacks.com>

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y \
            zip \
            unzip \
            libpng12-dev \
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
    ; \
    rm -rf /var/lib/apt/lists/*;
    
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && docker-php-ext-install -j$(nproc) iconv mcrypt pdo_mysql mysqli soap mbstring intl

RUN a2enmod rewrite expires

RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/3.1.3.tar.gz \
    && tar -xzvf /tmp/redis.tar.gz -C /tmp \
    && mkdir -p /usr/src/php/ext \
    && mv /tmp/phpredis-3.1.3 /usr/src/php/ext/redis \
    && rm -rf /tmp/redis.tar.gz \
    && docker-php-ext-install redis

RUN curl -L -o /tmp/memcached.tar.gz http://pecl.php.net/get/memcached-2.2.0.tgz \
    && tar -xzvf /tmp/memcached.tar.gz \
    && mv memcached-2.2.0 /usr/src/php/ext/memcached \
    && rm /tmp/memcached.tar.gz \
    && docker-php-ext-install memcached

COPY 000-default.conf /etc/apache2/sites-enabled
COPY sample /usr/src/sample
COPY logging.conf /etc/apache2/conf-enabled
COPY docker-entrypoint.sh /entrypoint.sh

RUN rm /var/www/html/package.xml

RUN usermod -u 1001 www-data \
    && groupmod -g 1001 www-data

VOLUME /var/www/html

ENTRYPOINT ["/entrypoint.sh"]

CMD ["apache2-foreground"]
