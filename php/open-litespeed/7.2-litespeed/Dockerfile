# Local dev: docker run --rm -it -e LS_ADMIN_PW=changeme -p 3000:80 -p 7080:7080 cmptstks/php:7.2-litespeed /sbin/my_init -- bash -l  
FROM cmptstks/baseimage:latest

LABEL maintainer="ComputeStacks <hello@computestacks.com>"
ENV LS_VERSION 1.5.11-1+bionic

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      autoconf \
      build-essential \
      wget \
      dpkg-dev \
      file \
      g++ \
      gcc \
      libc-dev \
      make \
      pkg-config \
      re2c \
      dirmngr \
      gnupg \
      libcurl4-openssl-dev \
      libedit-dev \
      libsodium-dev \
      libsqlite3-dev \
      libssl-dev \
      libxml2-dev \
      zlib1g-dev \
      procps \
      vim \
      tree \
      zip \
      unzip \
      libpng-dev \
      libbz2-dev \
      libmemcached-dev \
      libfreetype6-dev \
      libc-client-dev \
      libkrb5-dev \
      libxslt-dev \
      libicu-dev \
      imagemagick \
      libmagickwand-dev \
      libmariadb-dev \
      mariadb-client \
      libmcrypt-dev \
      mcrypt \
      expect \
      net-tools \
      ca-certificates \
      curl \
      xz-utils \
      rcs \
    ; \
    wget -O - http://rpms.litespeedtech.com/debian/enable_lst_debain_repo.sh | bash \
    ; \
    apt-get install -y --no-install-recommends \
      lsphp72 \
      lsphp72-common \
      lsphp72-curl \
      lsphp72-dev \
      lsphp72-imap \
      lsphp72-intl \
      lsphp72-json \
      lsphp72-memcached \
      lsphp72-mysql \
      lsphp72-redis \
      php-cli \
      php-mysql \
    ; \
    cd /usr/src \
    && wget http://rpms.litespeedtech.com/debian/pool/main/bionic/openlitespeed_${LS_VERSION}_amd64.deb \
    ; \
    dpkg -i openlitespeed_${LS_VERSION}_amd64.deb \
    ; \
    apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    ; \
    mkdir -p /var/www && mkdir /usr/src/default
    

COPY root/www /usr/src/default/
COPY root/00-entrypoint.sh /etc/my_init.d/
COPY root/10-litespeed-upgrade.sh /etc/my_init.d/
COPY root/50-litespeed.sh /etc/my_init.d/
COPY root/vhosts /usr/local/lsws/conf/vhosts/
COPY root/pecl/install_pear.sh /root/
COPY root/pecl/install_mcrypt.sh /root/
COPY root/pecl/install_imagick.sh /root/
COPY root/ioncube_loader_lin_7.2.so /usr/local/lsws/lsphp72/lib/php/20170718/

RUN cd /usr/local/lsws/fcgi-bin/ \
    && rm lsphp \
    && ln -s /usr/local/lsws/lsphp72/bin/lsphp lsphp \
    && cd /usr/local/lsws/lsphp72/bin \
    && chmod +x /etc/my_init.d/00-entrypoint.sh \
    && chmod +x /etc/my_init.d/10-litespeed-upgrade.sh \
    && chmod +x /etc/my_init.d/50-litespeed.sh \
    && wget -O /tmp/go-pear.phar http://pear.php.net/go-pear.phar \
    && chmod +x -R /root/install_*.sh \
    && /root/install_pear.sh \
    && /usr/local/lsws/lsphp72/bin/pecl channel-update pecl.php.net \    
    && /root/install_mcrypt.sh \
    && echo "extension=mcrypt.so" >> /usr/local/lsws/lsphp72/etc/php/7.2/mods-available/50-mcrypt.ini \
    && /root/install_imagick.sh \
    && echo "extension=imagick.so" >> /usr/local/lsws/lsphp72/etc/php/7.2/mods-available/50-imagick.ini \
    && echo "zend_extension=ioncube_loader_lin_7.2.so" >> /usr/local/lsws/lsphp72/etc/php/7.2/mods-available/ioncube.ini \
    && rm /root/install_*.sh \
    && rm /usr/local/lsws/conf/httpd_config.conf

COPY root/httpd_config.conf /usr/local/lsws/conf/httpd_config.conf

RUN mv /usr/local/lsws /usr/src \
    && chown -R lsadm:lsadm /usr/src/lsws/conf \
    && echo "max_input_vars = 3000" >> /usr/src/lsws/lsphp72/etc/php/7.2/litespeed/php.ini \
    && sed -i 's/memory_limit = .*/memory_limit = 192M/g' /usr/src/lsws/lsphp72/etc/php/7.2/litespeed/php.ini \
    && sed -i 's/upload_max_filesize = .*/upload_max_filesize = 250M/g' /usr/src/lsws/lsphp72/etc/php/7.2/litespeed/php.ini \
    && sed -i 's/max_input_time = .*/max_input_time = 300/g' /usr/src/lsws/lsphp72/etc/php/7.2/litespeed/php.ini \
    && sed -i 's/max_execution_time = .*/max_execution_time = 300/g' /usr/src/lsws/lsphp72/etc/php/7.2/litespeed/php.ini \
    && echo "date.timezone = 'UTC'" >> /usr/src/lsws/lsphp72/etc/php/7.2/litespeed/php.ini \
    && echo "post_max_size = 250M" >> /usr/src/lsws/lsphp72/etc/php/7.2/litespeed/php.ini

RUN usermod -u 1001 www-data \
    && groupmod -g 1001 www-data

COPY root/lswsctrl.sh /usr/local/bin/lswsctrl

VOLUME ["/var/www", "/usr/local/lsws"]

EXPOSE 80 7080
