#!/bin/bash

for version in 53 54 55 56 70 71;
do
    brew unlink php$version;
done

for version in 22 24;
do
    brew unlink httpd$version;
done
