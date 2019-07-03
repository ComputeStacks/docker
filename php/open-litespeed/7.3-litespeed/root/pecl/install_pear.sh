#!/usr/bin/expect
spawn /usr/local/lsws/lsphp73/bin/php /tmp/go-pear.phar

expect "1-12, 'all' or Enter to continue:"
send "\r"
expect {Would you like to alter php.ini </usr/local/lsws/lsphp73/etc/php/7.3/litespeed/php.ini>?}
send "y"
send "\r"
expect "Press Enter to continue:"
send "\r"
expect eof

spawn rm /tmp/go-pear.phar