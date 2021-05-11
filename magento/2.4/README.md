# Magento CE 2.4 Open Litespeed Image

[Dockerfile](https://github.com/ComputeStacks/docker/tree/master/magento/2.4/Dockerfile)

Includes:

  * Postfix with sendmail support, configured to relay to an SMTP service.
  * Cron with support for file locks to prevent multiple cron jobs from running when in a horizontally scaled environment.
  * Periodic job to remove old and state cron jobs from Magento's MySQL database:
    + See: https://www.optiweb.com/magento-2-cron-issues/
  * SSH access _(username is `user`)_
  * Logrotate for magento logs


While the Magento installation files are stored within the container image, the actual installation of magento happens on the first boot. Because of this, the intial start may take longer than normal. 

## How to build this image

```bash
docker build -t cmtpstks/magento:2-litespeed \
             --build-arg M_PUB_KEY=${MAGENTO_PUBLIC_KEY} \
             --build-arg M_PRIV_KEY=${MAGENTO_PRIVATE_KEY} \
             .
```

## Running locally
```bash
docker run --rm -d --name mysql -e MYSQL_ROOT_PASSWORD=changeme! mariadb:10.4
docker run --rm -d --name elasticsearch -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:7.12.1

docker run --rm -d -p 2222:22 -p 8000:80 -p 7080:7080 --name magento \
                -e SSH_PASS=changeme \
                -e MYSQL_HOST=$(docker inspect mysql --format {{.NetworkSettings.IPAddress}}) \
                -e ES_HOST=$(docker inspect elasticsearch --format {{.NetworkSettings.IPAddress}}) \
                -e MYSQL_USER=root \
                -e MYSQL_PW=changeme! \
                -e MYSQL_DB_NAME=mage \
                -e DEFAULT_DOMAIN="my.magento-url.com" \
                -e PROTO="http" \
                -e MAGE_USERNAME=admin \
                -e MAGE_PW="CHANGEME" \
                -e LS_ADMIN_PW=changeme \
                -e TIMEZONE="America/Los_Angeles" \
                -e MAGE_EMAIL=user@example.com \
                -e CURRENCY=USD \
                -e SMTP_SERVER=my.smtpserver.net \
                -e SMTP_USERNAME=changeme \
                -e SMTP_PASSWORD=changeme \
                -e SMTP_PORT=2525 \
                cmptstks/magento-ce:2.4
```