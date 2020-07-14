FROM cmptstks/nginx-lb:beta

COPY docker-entrypoint.sh /
COPY nginx-lb /usr/local/bin/

RUN chmod +x /docker-entrypoint.sh \
    && chmod +x /usr/local/bin/nginx-lb
