#!/usr/bin/env bash

echo "==> checking docs with alzlibtool..."
libraries=$(ls ./platform)
for library in $libraries; do
    echo "==> checking $library..."
    dir="./platform/$library"
    cd $dir
    ../../alzlibtool check library .
    cd ../..
done
