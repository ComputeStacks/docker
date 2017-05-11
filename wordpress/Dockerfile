FROM php:7.1-apache

MAINTAINER ComputeStacks <support@computestacks.com>

# install the PHP extensions we need
RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y \
            libjpeg-dev \
            libpng12-dev \
            libmemcached-dev \
            libxml2-dev \
            vim \
            nano \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    \
    docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
    docker-php-ext-install gd mysqli opcache soap

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

RUN rm /etc/apache2/sites-enabled/000-default.conf

VOLUME /var/www/html

RUN usermod -u 1001 www-data \
    && groupmod -g 1001 www-data

ENV WORDPRESS_VERSION 4.7.4
ENV WORDPRESS_SHA1 153592ccbb838cafa1220de9174ec965df2e9e1a

RUN set -ex; \
    curl -o wordpress.tar.gz -fSL "https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz"; \
    echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c -; \
# upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
    tar -xzf wordpress.tar.gz -C /usr/src/; \
    rm wordpress.tar.gz; \
    chown -R www-data:www-data /usr/src/wordpress

COPY 000-default.conf /etc/apache2/sites-enabled
COPY logging.conf /etc/apache2/conf-enabled
COPY lb_fix.sh /root

RUN bash /root/lb_fix.sh

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
