#!/usr/bin/expect
spawn /usr/local/lsws/lsphp74/bin/php /tmp/go-pear.phar

expect "1-12, 'all' or Enter to continue:"
send "\r"
expect {Would you like to alter php.ini </usr/local/lsws/lsphp74/etc/php/7.4/litespeed/php.ini>?}
send "y"
send "\r"
expect "Press Enter to continue:"
send "\r"
expect eof

spawn rm /tmp/go-pear.phar