FROM nginx:stable

RUN set -ex; \
    \
    apt-get update; \
    apt-get upgrade -y; \
    apt-get install -y \
            openssl \
            ca-certificates \
    ; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;

COPY docker-entrypoint.sh /
COPY nginx.conf /etc/nginx/nginx.conf

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD ["nginx", "-g", "daemon off;"]
