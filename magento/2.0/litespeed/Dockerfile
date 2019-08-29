FROM cmptstks/php:7.2-litespeed

LABEL maintainer="ComputeStacks <hello@computestacks.com>"

# Magento Composer Repository Authentication
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
      openssh-server \
      sudo \
      mailutils \
      apt-utils \
  ; \
  bash -c 'debconf-set-selections <<< "postfix postfix/mailname string docker.local"'; \
  bash -c 'debconf-set-selections <<< "postfix postfix/main_mailer_type string ${POSTFIX_TYPE}"'; \
  apt-get -y install postfix libsasl2-modules; \
  wget https://getcomposer.org/composer.phar -O composer \
  && mv composer /usr/local/bin/composer \
  && chmod +x /usr/local/bin/composer \
  && mkdir -p /usr/src/magento \
  && mv /usr/src/lsws/* /usr/local/lsws/ \
  && rm /usr/bin/php \
  && ln -s /usr/local/lsws/lsphp72/bin/php /usr/bin/php \
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
  && echo "127.0.0.1 docker.local" >> /etc/hosts \
  && mv /usr/local/lsws/* /usr/src/lsws \
  && rm -f /etc/service/sshd/down \
  && /etc/my_init.d/00_regen_ssh_host_keys.sh \
  ; \
  cd /usr/src; \
  mkdir /usr/src/lsws/conf/vhosts/Magento; \
  sed -i 's/  map                     Default/  map                     Magento/g' /usr/src/lsws/conf/httpd_config.conf; \
  echo '\n\
virtualhost Magento { \n\
  vhRoot                  /var/www/html/magento \n\
  configFile              conf/vhosts/Magento/vhconf.conf \n\
  allowSymbolLink         1 \n\
  enableScript            1 \n\
  restrained              1 \n\
  smartKeepAlive          1 \n\
  user                    1001 \n\
  group                   1001 \n\
}' >> /usr/src/lsws/conf/httpd_config.conf;

COPY 05-magento.sh /etc/my_init.d/
COPY 06-postfix.sh /etc/my_init.d/
COPY 07-ssh.sh /etc/my_init.d/
COPY mage.ini /usr/local/etc/php/conf.d
COPY vhconf.conf /usr/src/lsws/conf/vhosts/Magento/
COPY magento.syslog /etc/logrotate.d/magento

EXPOSE 22 80 7080