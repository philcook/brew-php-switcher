#!/bin/bash

for version in 53 54 55 56 70 71 72;
do
    brew unlink php$version;
done
