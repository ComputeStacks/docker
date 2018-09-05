FROM ruby:2.5

RUN usermod -u 1001 www-data \
    && groupmod -g 1001 www-data

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y \
            build-essential \
            git-core \
            libssl-dev \
            libreadline-dev \
            zip \
            curl \
            libyaml-dev \
            libxslt1-dev \
            libcurl4-openssl-dev \
            software-properties-common \
            libffi-dev \
            libpq-dev \
            nodejs \
            dnsutils \
            unzip \
            libpng-dev \
            libjpeg62-turbo-dev \
            mysql-client \
            libxml2-dev \
            libbz2-dev \
            libmemcached-dev \
            libfreetype6-dev \
            libc-client-dev \
            libkrb5-dev \
            libxslt-dev \
            vim \
            nano \
            zlib1g-dev \
            libicu-dev \
            g++ \
            wget \
            imagemagick \
            libmagickwand-dev \
    ; \
    rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /var/www/app \
    && mkdir -p /usr/src/sample

RUN echo 'gem: --no-document' >> ~/.gemrc \
    && cp ~/.gemrc /etc/gemrc \
    && cp ~/.gemrc /var/www/.gemrc \
    && chmod uog+r /etc/gemrc \
    && gem install -N bundler

WORKDIR /var/www/app

COPY sample/ /usr/src/sample/
COPY entrypoint.sh /usr/local/bin/entrypoint

RUN cd /usr/src/sample \
    && bundle install \
    && chown -R www-data:www-data /var/www \
    && chown -R www-data:www-data /usr/src/sample \
    && chmod +x /usr/local/bin/entrypoint

USER www-data

EXPOSE 3000

ENTRYPOINT ["entrypoint"]
CMD ["bundle", "exec", "foreman", "start"]
