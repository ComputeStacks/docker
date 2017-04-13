FROM wordpress:4-php7.1-apache

MAINTAINER ComputeStacks <support@computestacks.com>

RUN apt-get update \
    && apt-get install -y libmemcached-dev libxml2-dev vim nano

RUN docker-php-ext-install soap

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

RUN rm /etc/apache2/sites-enabled/000-default.conf

COPY 000-default.conf /etc/apache2/sites-enabled
COPY logging.conf /etc/apache2/conf-enabled
COPY lb_fix.sh /root

RUN bash /root/lb_fix.sh
