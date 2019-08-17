FROM cmptstks/php:7.3-litespeed

LABEL maintainer="ComputeStacks <hello@computestacks.com>"

# https://wordpress.org/download/releases/
ENV WORDPRESS_VERSION 5.2.2
ENV WORDPRESS_CLI_VERSION 2.3.0
ENV WORDPRESS_CLI_MD5 71d72726f0341f85d838b98b9c375080

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
}' >> /usr/src/lsws/conf/httpd_config.conf;

RUN wget -O /usr/local/bin/wp https://github.com/wp-cli/wp-cli/releases/download/v${WORDPRESS_CLI_VERSION}/wp-cli-${WORDPRESS_CLI_VERSION}.phar \
    && echo "$WORDPRESS_CLI_MD5 /usr/local/bin/wp" | md5sum -c -; \
    chmod +x /usr/local/bin/wp;

RUN mkdir -p /usr/src/wordpress \
    && cd /usr/src/wordpress \
    && wp core download --allow-root --version=${WORDPRESS_VERSION}
    