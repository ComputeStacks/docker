# Magento 2 Image

Includes:

  - Postfix with sendmail support, configured to relay to an SMTP service.
  - Cron with support for file locks to prevent multiple cron jobs from running when in a horizontally scaled environment.
  - Periodic job to remove old and state cron jobs from Magento's MySQL database:
    - See: https://www.optiweb.com/magento-2-cron-issues/
  - SSH access
    - SSH username is: `user`

## How to run this image

 - The `DEFAULT_DOMAIN` is just the FQDN. `https://` will automatically be assumed.
 - Startup can take a few minutes. Magento is installed during initial boot, and services such as sshd and Apache won't be available until that finishes.
 - Your user account is in the same group as Apache, so be sure to make any files you create readable by group.
 - Root permissions are available using sudo.
 - Make any cron changes here: `/var/www/html/crontab_master`. Restart the container to load these changes.
 - Postfix config is available here: `/var/www/html/postfix.cf`

_Example from your local computer:_

```
docker run -d -e MYSQL_ROOT_PASSWORD=changeme -p 3306:3306 mariadb:10
docker run -d --name mage \
           -e SSH_PASS=changeme \
           -e EMAIL=user@example.com \
           -e DEFAULT_DOMAIN=test.local:8000 \
           -e MYSQL_HOST=host.docker.internal \
           -e MYSQL_PORT=3306 \
           -e MYSQL_DB_NAME=magento \
           -e MYSQL_USER=root \
           -e MYSQL_PW=changeme \
           -e MAGE_EMAIL=user@example.com \
           -e MAGE_PW=A1s79vko \
           -e MAGE_USERNAME=admin \
           -e CURRENCY=USD \
           -e TIMEZONE=UTC \
           -e SMTP_SERVER= \
           -e SMTP_PORT= \
           -e SMTP_USERNAME= \
           -e SMTP_PASSWORD= \
           mage2
```

## How to build this image

You will need to generate access keys from [Magento's Marketplace](https://marketplace.magento.com)

```
docker build -t mage2 --build-arg M_PUB_KEY=${MAGENTO_MARKET_PUBLIC_KEY} --build-arg M_PRIV_KEY=${MAGENTO_MARKET_PRIVATE_KEY} .
```