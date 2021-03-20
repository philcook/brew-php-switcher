#!/bin/bash

error=0
brew_array=("5.6" "7.0" "7.1" "7.2" "7.3" "7.4" "8.0" "8.1")

for version in ${brew_array[*]}; do
  . $(echo $(dirname $0)"/../phpswitch.sh") $version -s >/dev/null
  switched=$(php -v | grep -e '^PHP' | cut -d' ' -f2 | cut -d. -f1,2)
  if [ "$version" != "$switched" ]; then
    error=1
    echo -n 'E'
  fi
  echo -n '.'
done
echo

exit $error
