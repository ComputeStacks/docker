#!/usr/bin/expect
spawn /usr/local/lsws/lsphp72/bin/php /tmp/go-pear.phar

expect "1-12, 'all' or Enter to continue:"
send "\r"
expect {Would you like to alter php.ini </usr/local/lsws/lsphp72/etc/php/7.2/litespeed/php.ini>?}
send "y"
send "\r"
expect "Press Enter to continue:"
send "\r"
expect eof

spawn rm /tmp/go-pear.phar