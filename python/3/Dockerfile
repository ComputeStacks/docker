FROM python:3-stretch

RUN usermod -u 1001 www-data \
    && groupmod -g 1001 www-data

RUN set -ex; \
    \
    apt-get update; \
    apt-get -y upgrade; \
    apt-get install -y \
            gnupg1 \
            apt-transport-https \
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
            cron \
            supervisor \
    ;

# NGINX : https://github.com/nginxinc/docker-nginx/blob/b71469ab815f580ba0ad658a32e91c86f8565ed4/stable/stretch/Dockerfile 
# b71469a (12/5/2018)
ENV NGINX_VERSION 1.14.2-1~stretch
ENV NJS_VERSION   1.14.2.0.2.6-1~stretch

RUN set -x \
	## Removed pulling key from public servers due to consistent failures to find the key.
	&& wget -qO - https://nginx.org/keys/nginx_signing.key | apt-key add - \
	&& apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/* \
	## END
	&& dpkgArch="$(dpkg --print-architecture)" \
	&& nginxPackages=" \
		nginx=${NGINX_VERSION} \
		nginx-module-xslt=${NGINX_VERSION} \
		nginx-module-geoip=${NGINX_VERSION} \
		nginx-module-image-filter=${NGINX_VERSION} \
		nginx-module-njs=${NJS_VERSION} \
	" \
	&& case "$dpkgArch" in \
		amd64|i386) \
			echo "deb https://nginx.org/packages/debian/ stretch nginx" >> /etc/apt/sources.list.d/nginx.list \
			&& apt-get update \
			;; \
		*) \
			echo "deb-src https://nginx.org/packages/debian/ stretch nginx" >> /etc/apt/sources.list.d/nginx.list \
			\
			&& tempDir="$(mktemp -d)" \
			&& chmod 777 "$tempDir" \
			\
			&& savedAptMark="$(apt-mark showmanual)" \
			\
			&& apt-get update \
			&& apt-get build-dep -y $nginxPackages \
			&& ( \
				cd "$tempDir" \
				&& DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)" \
					apt-get source --compile $nginxPackages \
			) \
			\
			&& apt-mark showmanual | xargs apt-mark auto > /dev/null \
			&& { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; } \
			\
			&& ls -lAFh "$tempDir" \
			&& ( cd "$tempDir" && dpkg-scanpackages . > Packages ) \
			&& grep '^Package: ' "$tempDir/Packages" \
			&& echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list \
			&& apt-get -o Acquire::GzipIndexes=false update \
			;; \
	esac \
	\
	&& apt-get install --no-install-recommends --no-install-suggests -y \
						$nginxPackages \
						gettext-base \
	&& apt-get remove --purge --auto-remove -y apt-transport-https ca-certificates && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list \
	\
	&& if [ -n "$tempDir" ]; then \
		apt-get purge -y --auto-remove \
		&& rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list; \
	fi

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log
# END nginx ##

RUN mkdir -p /usr/src/app \
    && mkdir -p /usr/src/sample

WORKDIR /usr/src/app

COPY sample/ /usr/src/sample/
COPY entrypoint.sh /usr/local/bin/entrypoint
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN cd /usr/src/sample \
    && pip install -r requirements.txt \
    && chown -R www-data:www-data /usr/src/sample \
    && chown -R www-data:www-data /usr/src/app \
    && chmod +x /usr/local/bin/entrypoint \
	&& mkdir -p /var/www \
    && chown -R www-data:www-data /var/www \
	&& rm /etc/nginx/conf.d/default.conf

EXPOSE 80
ENTRYPOINT ["entrypoint"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
