FROM php:5.6-apache
MAINTAINER ComputeStacks <support@computestacks.com>

# Hash can be found here: https://www.drupal.org/drupal-${DRUPAL_VERSION}-release-notes
ENV DRUPAL_VERSION=7.53
ENV DRUPAL_TARBALL_MD5=4230279ecca4f0cde652a219e10327e7

# Provide compatibility for images depending on previous versions
RUN ln -s /var/www/html /app

RUN a2enmod rewrite

# Install packages and PHP-extensions
RUN apt-get -q update \
 && DEBIAN_FRONTEND=noninteractive apt-get -yq --no-install-recommends install \
	file \
    libfreetype6 \
    libjpeg62 \
    libpng12-0 \
    libpq-dev \
    libx11-6 \
    libxpm4 \
    mysql-client \
    libxml2-dev \
    postgresql-client \
    vim \
 && BUILD_DEPS="libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng12-dev libxpm-dev re2c zlib1g-dev"; \
    DEBIAN_FRONTEND=noninteractive apt-get -yq --no-install-recommends install $BUILD_DEPS \
 && docker-php-ext-configure gd \
        --with-jpeg-dir=/usr/lib/x86_64-linux-gnu --with-png-dir=/usr/lib/x86_64-linux-gnu \
        --with-xpm-dir=/usr/lib/x86_64-linux-gnu --with-freetype-dir=/usr/lib/x86_64-linux-gnu \
 && docker-php-ext-install gd mbstring pdo_mysql pdo_pgsql zip \
 && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $BUILD_DEPS \
 && rm -rf /var/lib/apt/lists/* \
 && pecl install uploadprogress


RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/3.1.0.tar.gz \
    && tar -xzvf /tmp/redis.tar.gz -C /tmp \
    && mkdir -p /usr/src/php/ext \
    && mv /tmp/phpredis-3.1.0 /usr/src/php/ext/redis \
    && rm -rf /tmp/redis.tar.gz \
    && docker-php-ext-install redis

# Soap
RUN docker-php-ext-install soap

WORKDIR /var/www
RUN rm -R html \
    && curl -OsS https://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz \
    && echo "${DRUPAL_TARBALL_MD5}  drupal-${DRUPAL_VERSION}.tar.gz" | md5sum -c \
    && tar -xf drupal-${DRUPAL_VERSION}.tar.gz && rm drupal-${DRUPAL_VERSION}.tar.gz \
    && mv drupal-${DRUPAL_VERSION} html \
    && cd html \
    && rm [A-Z]*.txt install.php web.config sites/default/default.settings.php

# Install composer and drush by using composer
ENV COMPOSER_BIN_DIR=/usr/local/bin
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer global require drush/drush:7.* \
    && drush cc drush \
    && mkdir /etc/drush && echo "<?php\n\$options['yes'] = TRUE;\n\$options['v'] = TRUE;\n" > /etc/drush/drushrc.php

# Add PHP-settings
ADD php-conf.d/ $PHP_INI_DIR/conf.d/

RUN rm /etc/apache2/sites-enabled/000-default.conf
COPY 000-default.conf /etc/apache2/sites-enabled
COPY logging.conf /etc/apache2/conf-enabled

# copy sites/default's defaults
WORKDIR html
ADD sites/ sites/

ADD entrypoint.sh /
ADD /scripts/ /scripts/

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
