#!/bin/bash

if [[ $TRAVIS_OS_NAME == 'osx' ]]; then
    brew tap homebrew/dupes
    brew tap homebrew/versions
    brew tap homebrew/homebrew-php
    brew tap homebrew/services
    brew update
    brew install php53
    brew unlink php53
    brew install php54
    brew unlink php54
    brew install php55
    brew unlink php55
    brew install php56
    brew unlink php56
    brew install php70
    brew unlink php70
    brew install php71
    brew unlink php71

    echo 'Installed all PHP versions.'
fi
