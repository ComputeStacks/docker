# WHMCS PHP 7.0 Apache Container

This image does not contain the actual WHMCS application. This is a protected download.

Download your WHMCS copy here: [download.whmcs.com](https://download.whmcs.com/)

WHMCS requires MySQL 5.7 with Strict Mode disabled. Create a file named `whmcs_mysql.cnf` with the contents:

**whmcs_mysql.cnf**:
```
[mysqld]
sql_mode=IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
```

Mount that file to `/etc/mysql/conf.d/whmcs_mysql.cnf` in your MySQL 5.7 container. 

Rename `configuration.php.new` to `configuration.php`.

Example:

```
docker run -d --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=myMySQLRootPW -e MYSQL_DATABASE=whmcs -v ~/whmcs_mysql.cnf:/etc/mysql/conf.d/whmcs_mysql.cnf:ro mysql:5.7
docker run -d --name whmcs -p 8080:80 -v /path/to/my/whmcs:/var/www/html/whmcs whmcs:latest
```