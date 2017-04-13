FROM php:5.6-apache

MAINTAINER ComputeStacks <support@computestacks.com>

RUN a2enmod rewrite

RUN apt-get update \
		&& apt-get install -y \
		zip \
		unzip \
		libpng12-dev \
		libjpeg62-turbo-dev \
		mysql-client \
		libxml2-dev \
		libmcrypt-dev \
		libmemcached-dev \
		libfreetype6-dev \
		&& rm -rf /var/lib/apt/lists/* \
		&& docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
		&& docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
		&& docker-php-ext-install soap \
		&& docker-php-ext-install mcrypt \
		&& docker-php-ext-install mbstring

RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/3.1.1.tar.gz \
    && tar -xzvf /tmp/redis.tar.gz -C /tmp \
    && mkdir -p /usr/src/php/ext \
    && mv /tmp/phpredis-3.1.1 /usr/src/php/ext/redis \
    && rm -rf /tmp/redis.tar.gz \
    && docker-php-ext-install redis

RUN curl -L -o /tmp/memcached.tar.gz http://pecl.php.net/get/memcached-2.2.0.tgz \
    && tar -xzvf /tmp/memcached.tar.gz \
    && mv memcached-2.2.0 /usr/src/php/ext/memcached \
    && rm /tmp/memcached.tar.gz \
    && docker-php-ext-install memcached

COPY 000-default.conf /etc/apache2/sites-enabled
COPY logging.conf /etc/apache2/conf-enabled

VOLUME /var/www/html

CMD ["apache2-foreground"]
