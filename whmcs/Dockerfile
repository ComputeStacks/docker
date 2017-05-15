FROM php:7.0-apache
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

COPY 000-default.conf /etc/apache2/sites-enabled
COPY logging.conf /etc/apache2/conf-enabled
COPY ioncube_loader_lin_7.0.so /usr/local/lib/php/extensions/no-debug-non-zts-20151012
COPY 00-ioncube.ini /usr/local/etc/php/conf.d

RUN chown root:staff /usr/local/lib/php/extensions/no-debug-non-zts-20151012/ioncube_loader_lin_7.0.so \
    && chmod +x /usr/local/lib/php/extensions/no-debug-non-zts-20151012/ioncube_loader_lin_7.0.so

VOLUME ["/var/www/html"]
CMD ["apache2-foreground"]
