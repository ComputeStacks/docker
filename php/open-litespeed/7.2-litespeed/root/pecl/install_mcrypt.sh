#!/usr/bin/expect
spawn /usr/local/lsws/lsphp72/bin/pecl install channel://pecl.php.net/mcrypt-1.0.2

expect {libmcrypt prefix? [autodetect]}
send "\r"
expect eof