#!/bin/bash

for version in '5.6' '7.1' '7.2' '7.3' '7.4'; do
    brew unlink php@$version
done
