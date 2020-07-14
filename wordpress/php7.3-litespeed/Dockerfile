FROM cmptstks/php:7.3-litespeed

LABEL maintainer="ComputeStacks <hello@computestacks.com>"

COPY 10-wordpress.sh /etc/my_init.d/
COPY root/vhosts /usr/src/lsws/conf/vhosts/

RUN set -ex; \
    chmod +x /etc/my_init.d/10-wordpress.sh; \
    cd /usr/src; \
    sed -i 's/  map                     Default/  map                     Wordpress/g' /usr/src/lsws/conf/httpd_config.conf; \
    echo '\n\
virtualhost Wordpress { \n\
  vhRoot                  /var/www/html/wordpress \n\
  configFile              conf/vhosts/Wordpress/vhconf.conf \n\
  allowSymbolLink         1 \n\
  enableScript            1 \n\
  restrained              1 \n\
  smartKeepAlive          1 \n\
  user                    1001 \n\
  group                   1001 \n\
}' >> /usr/src/lsws/conf/httpd_config.conf \
    ; \
    chown lsadm: -R /usr/src/lsws/conf/vhosts/ \
    ; \
    wget -O /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp \
    ; \
    mkdir -p /usr/src/wordpress \
    && cd /usr/src/wordpress \
    && wp core download --allow-root
