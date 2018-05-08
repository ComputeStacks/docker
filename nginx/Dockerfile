FROM nginx:stable

RUN mkdir -p /var/www/html

COPY index.html /var/www/html/

RUN usermod -u 1001 nginx \
    && groupmod -g 1001 nginx \
    && chown -R nginx:nginx /var/www

COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf