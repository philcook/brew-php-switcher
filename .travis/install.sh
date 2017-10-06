#!/bin/bash

if [[ $TRAVIS_OS_NAME == 'osx' ]]; then
    for version in 53 54 55 56 70 71;
    do
        brew install php$version --with-httpd
        brew unlink php$version;
    done
    echo 'Installed all PHP versions.'
fi