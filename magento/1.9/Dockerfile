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
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
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

VOLUME /var/www/html

COPY magento-1.9.3.4.tar.gz /usr/src/

RUN cd /usr/src \
    && tar -xzf magento-1.9.3.4.tar.gz -C /usr/src/ \
    && rm /usr/src/magento-1.9.3.4.tar.gz \
    && chown -R www-data:www-data /usr/src/magento \
    && cd /usr/src/magento \
    && rm -rf index.php.sample .htaccess.sample php.ini.sample LICENSE.txt STATUS.txt \
    && find . -type d -exec chmod 750 {} \; && find . -type f -exec chmod 640 {} \; \
    && chmod o+w var var/.htaccess app/etc \
    && chmod -R o+w media

RUN sed -i 's#DocumentRoot /var/www/html#DocumentRoot /var/www/html/magento#' /etc/apache2/sites-available/000-default.conf \
    && sed -i 's#DocumentRoot /var/www/html#DocumentRoot /var/www/html/magento#' /etc/apache2/sites-available/default-ssl.conf \
    && sed -i 's#DocumentRoot /var/www/html#DocumentRoot /var/www/html/magento#' /etc/apache2/apache2.conf

COPY cache.xml /usr/src/magento/app/etc/mage-cache.xml
COPY docker-entrypoint.sh /entrypoint.sh

COPY mage.ini /usr/local/etc/php/conf.d

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
