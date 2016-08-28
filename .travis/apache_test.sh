#!/bin/bash

error=0

test_php5_module="/usr/local/opt/php56/libexec/apache2/libphp5.so"
test_php7_module="/usr/local/opt/php70/libexec/apache2/libphp7.so"

#mod_php tests with default MacOS apache
SERVER_CONFIG_FILE=$(apachectl -V 2>/dev/null | grep SERVER_CONFIG_FILE | cut -d '"' -f 2)
. `echo $(dirname $0)"/../phpswitch.sh"` 56 > /dev/null
if [ "$(grep -e "^LoadModule php" $SERVER_CONFIG_FILE | cut -d' ' -f3)" = $test_php5_module ]; then
    echo -n '.'
else
    error=1
    echo -n 'E'
fi
. `echo $(dirname $0)"/../phpswitch.sh"` 70 > /dev/null
if [ "$(grep -e "^LoadModule php" $SERVER_CONFIG_FILE | cut -d' ' -f3)" = $test_php7_module ]; then
    echo -n '.'
else
    error=1
    echo -n 'E'
fi

#mod_php tests with homebrewed apache
for apache_version in 22 24
do
    brew link httpd$apache_version
    SERVER_CONFIG_FILE=$(apachectl -V 2>/dev/null | grep SERVER_CONFIG_FILE | cut -d '"' -f 2)
    . `echo $(dirname $0)"/../phpswitch.sh"` 56 > /dev/null
    if [ "$(grep -e "^LoadModule php" $SERVER_CONFIG_FILE | cut -d' ' -f3)" = $test_php5_module ]; then
        echo -n '.'
    else
        error=1
        echo -n 'E'
    fi
    . `echo $(dirname $0)"/../phpswitch.sh"` 70 > /dev/null
    if [ "$(grep -e "^LoadModule php" $SERVER_CONFIG_FILE | cut -d' ' -f3)" = $test_php7_module ]; then
        echo -n '.'
    else
        error=1
        echo -n 'E'
    fi
    brew unlink httpd$apache_version
done

echo ''

exit $error
