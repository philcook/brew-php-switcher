#!/bin/bash

error=0
for version in 53 54 55 56 70 71 72
do
    . `echo $(dirname $0)"/../phpswitch.sh"` $version -s > /dev/null
    switched=$(php -v | grep -e '^PHP' | cut -d' ' -f2 | cut -d. -f1,2 | sed 's/\.//')
    if [ $version -ne $switched ];
    then
        error=1
        echo -n 'E'
    fi
    echo -n '.'
done
echo ''

exit $error
