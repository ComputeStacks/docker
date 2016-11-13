FROM wordpress:4

MAINTAINER ComputeStacks

RUN apt-get update \
    && apt-get install -y libmemcached-dev libxml2-dev

RUN docker-php-ext-install soap

RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/2.2.8.tar.gz \
    && tar -xzvf /tmp/redis.tar.gz -C /tmp \
    && mkdir -p /usr/src/php/ext \
    && mv /tmp/phpredis-2.2.8 /usr/src/php/ext/redis \
    && rm -rf /tmp/redis.tar.gz \
    && docker-php-ext-install redis

RUN curl -L -o /tmp/memcached.tar.gz http://pecl.php.net/get/memcached-2.2.0.tgz \
    && tar -xzvf /tmp/memcached.tar.gz \
    && mv memcached-2.2.0 /usr/src/php/ext/memcached \
    && rm /tmp/memcached.tar.gz \
    && docker-php-ext-install memcached
