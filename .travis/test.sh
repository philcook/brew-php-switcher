#!/bin/bash

function switch_cli_only {
    . `echo $(dirname $0)"/../phpswitch.sh"` $version -s > /dev/null
    switched=$(php -v | grep -e '^PHP' | cut -d' ' -f2 | cut -d. -f1,2 | sed 's/\.//')
    if [ $version -ne $switched ];
    then
        error=1
        printf "Error - $version didn't match $switched"
    else
        printf "Pass $version matched $switched"
    fi
    printf "\n"
}

function switch_cli_apache {
    . `echo $(dirname $0)"/../phpswitch.sh"` $version > /dev/null
}

error=0
printf "Testing\n"
for version in 53 54 55 56 70 71
do
    #switch_cli_only
    switch_cli_apache
done

if [ $error -ne 0 ];
then
    printf "Tests have failed\n"
fi

exit $error