#!/bin/bash

if [[ $TRAVIS_OS_NAME == 'osx' ]]; then
    brew tap homebrew/dupes
    brew update
    brew install php@5.6
    brew unlink php@5.6
    brew install php@7.0
    brew unlink php@7.0
    brew install php@7.1
    brew unlink php@7.1
    brew install php@7.2
    brew unlink php@7.2
    brew install php@7.3
    brew link --overwrite php@7.3
    brew unlink php@7.3

    echo 'Installed all PHP versions.'
fi
