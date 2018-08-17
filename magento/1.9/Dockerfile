FROM cmptstks/php:5.6-apache

COPY magento-1.9.3.9.tar.gz /usr/src/

COPY htaccess /usr/src/

RUN cd /usr/src \
    && tar -xzf magento-1.9.3.9.tar.gz -C /usr/src/ \
    && rm /usr/src/magento-1.9.3.9.tar.gz \
    && chown -R www-data:www-data /usr/src/magento \
    && cd /usr/src/magento \
    && rm -rf index.php.sample .htaccess .htaccess.sample php.ini.sample \
    && mv /usr/src/htaccess /usr/src/magento/.htaccess \
    && find . -type d -exec chmod 750 {} \; && find . -type f -exec chmod 640 {} \; \
    && chmod o+w var var/.htaccess app/etc \
    && chmod -R o+w media
    
COPY docker-entrypoint.sh /entrypoint.sh
COPY 000-default.conf /etc/apache2/sites-enabled
COPY mage.ini /usr/local/etc/php/conf.d

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
