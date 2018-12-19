FROM python:3

RUN usermod -u 1001 www-data \
    && groupmod -g 1001 www-data

RUN set -ex; \
    \
    apt-get update; \
    apt-get -y upgrade; \
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
            sqlite3 \
    ; \
    rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/src/app \
    && mkdir -p /usr/src/sample

WORKDIR /usr/src/app

COPY sample/ /usr/src/sample/
COPY entrypoint.sh /usr/local/bin/entrypoint

RUN cd /usr/src/sample \
    && pip install -r requirements.txt \
    && chown -R www-data:www-data /usr/src/sample \
    && chown -R www-data:www-data /usr/src/app \
    && chmod +x /usr/local/bin/entrypoint \
    && mkdir -p /var/www/.cache \
    && chown -R www-data:www-data /var/www


USER www-data
EXPOSE 8000
ENTRYPOINT ["entrypoint"]
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]






