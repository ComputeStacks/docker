# WHMCS PHP 7.0 Apache Container

This image does not contain the actual WHMCS application. This is a protected download.

Download your WHMCS copy here: [download.whmcs.com](https://download.whmcs.com/)

WHMCS currently requires MySQL 5.6; v5.7 is not supported.

Rename `configuration.php.new` to `configuration.php`.

Example:

```
docker run -d --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=myMySQLRootPW -e MYSQL_DATABASE=whmcs mysql:5.6
docker run -d --name whmcs -p 8080:80 -v /path/to/my/whmcs:/var/www/html/whmcs whmcs:latest
```