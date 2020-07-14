#!/usr/bin/expect
spawn /usr/local/lsws/lsphp73/bin/pecl install channel://pecl.php.net/mcrypt-1.0.3

expect {libmcrypt prefix? [autodetect]}
send "\r"
expect eof