FROM node:8

MAINTAINER ComputeStacks <support@computestacks.com>

COPY sample /usr/src/sample
COPY docker-entrypoint.sh /entrypoint.sh

COPY sample/ /usr/src/sample
RUN cd /usr/src/sample \
    && npm install

COPY docker-entrypoint.sh /entrypoint.sh

RUN usermod -u 1001 node \
    && groupmod -g 1001 node

VOLUME /usr/src/app

ENTRYPOINT ["/entrypoint.sh"]
WORKDIR /usr/src/app
EXPOSE 3000
CMD ["npm", "start"]