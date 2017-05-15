# WHMCS PHP 7.0 Apache Container

This image does not contain the actual WHMCS application. This is a protected download.

Download your WHMCS copy here: [download.whmcs.com](https://download.whmcs.com/)

Rename `configuration.php.new` to `configuration.php`.

Example:

```
docker run -d --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=myMySQLRootPW mysql:5.7
docker run -d --name whmcs -p 8080:80 -v /path/to/my/whmcs:/var/www/html/whmcs whmcs:latest
```