# WHMCS PHP 7.1 Apache Container

Example:

```
docker run -d --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=myMySQLRootPW -e MYSQL_DATABASE=whmcs mariadb:10.2
docker run -d --name whmcs -p 8080:80 -v /path/to/my/whmcs:/var/www/html cmptstks/whmcs:latest
```