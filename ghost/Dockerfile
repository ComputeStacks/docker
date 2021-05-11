FROM ghost:4-alpine

RUN apk --no-cache add shadow \
    && usermod -u 1001 node \
    && groupmod -g 1001 node
