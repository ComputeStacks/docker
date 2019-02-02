FROM cmptstks/php:7.2-apache

ARG M_PUB_KEY
ARG M_PRIV_KEY

ARG POSTFIX_TYPE="Internet Site"

RUN set -ex; \
    \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get -y upgrade; \    
    apt-get -y install \
      re2c \
      xz-utils \
      supervisor \
      openssh-server \
      cron \
      sudo \
      mailutils \
      apt-utils \
      rsyslog \
  ; \
  bash -c 'debconf-set-selections <<< "postfix postfix/mailname string docker.local"'; \
  bash -c 'debconf-set-selections <<< "postfix postfix/main_mailer_type string ${POSTFIX_TYPE}"'; \
  apt-get -y install postfix libsasl2-modules; \
  wget https://getcomposer.org/composer.phar -O composer \
  && mv composer /usr/local/bin/composer \
  && chmod +x /usr/local/bin/composer \
  && mkdir -p /usr/src/magento \
  && composer self-update \
  && composer global config http-basic.repo.magento.com ${M_PUB_KEY} ${M_PRIV_KEY} \
  && composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition /usr/src/magento/ \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /run/sshd \
  && chmod 0755 /run/sshd \
  && useradd -s /bin/bash -g www-data -m user \
  && find /usr/src/magento/ -type d -exec chmod 770 {} \; && find /usr/src/magento/ -type f -exec chmod 660 {} \; \
  && rm /root/.composer/auth.json \
  && echo "user    ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers.d/containeruser \
  && sed -i 's/module(load="imklog")/#module(load="imklog")/' /etc/rsyslog.conf \
  && rm /etc/apache2/sites-enabled/000-default.conf \
  && echo "127.0.0.1 docker.local" >> /etc/hosts

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY sshd_config /etc/ssh/sshd_config

RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && a2ensite 000-default

EXPOSE 22 80

VOLUME /var/www/html

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]