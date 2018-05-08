FROM bitnami/magento:2.2.4

RUN usermod -u 1001 bitnami \
    && groupmod -g 1001 bitnami

COPY magento_cron /etc/cron.d/magento