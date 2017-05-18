FROM php:7.1-apache
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
        		libmcrypt-dev \
        		libmemcached-dev \
        		libfreetype6-dev \
            vim \
            nano \
    ; \
		rm -rf /var/lib/apt/lists/*; \		
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd iconv mcrypt \
		&& docker-php-ext-install pdo_mysql mysqli soap mbstring opcache

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

RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/3.1.1.tar.gz \
    && tar -xzvf /tmp/redis.tar.gz -C /tmp \
    && mkdir -p /usr/src/php/ext \
    && mv /tmp/phpredis-3.1.1 /usr/src/php/ext/redis \
    && rm -rf /tmp/redis.tar.gz \
    && docker-php-ext-install redis

RUN curl -L -o /tmp/memcached.tar.gz http://pecl.php.net/get/memcached-3.0.3.tgz \
    && tar -xzvf /tmp/memcached.tar.gz \
    && mv memcached-3.0.3 /usr/src/php/ext/memcached \
    && rm /tmp/memcached.tar.gz \
    && docker-php-ext-install memcached

COPY 000-default.conf /etc/apache2/sites-enabled
COPY logging.conf /etc/apache2/conf-enabled

RUN usermod -u 1001 www-data \
    && groupmod -g 1001 www-data

VOLUME /var/www/html

CMD ["apache2-foreground"]
