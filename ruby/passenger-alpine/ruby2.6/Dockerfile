FROM ruby:2.6-alpine

LABEL maintainer="ComputeStacks <hello@computestacks.com>"

ENV PASSENGER_VERSION 6.0.6

RUN set -eux; \
        \
        apk add --no-cache \
                build-base \
                ca-certificates \
                curl \
                curl-dev \
                openssh \
                pcre \
                pcre-dev \
        ; \
        gem install -N bundler \
        && gem install -N passenger -v ${PASSENGER_VERSION} \
        ; \
        passenger-config compile-agent --auto --optimize \
        ; \
        passenger-config install-standalone-runtime --auto --skip-cache \
        ; \
        passenger-config build-native-support

