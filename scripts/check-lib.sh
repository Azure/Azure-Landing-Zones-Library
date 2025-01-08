#!/usr/bin/env bash
lib=$1

echo "==> checking docs with alzlibtool $lib..."
libraries=$(ls ./platform)
for library in $libraries; do
    if [ ! -z "$lib" ] && [ "$lib" != "$library" ]; then
        continue
    fi

    echo "==> checking $library..."
    dir="./platform/$library"
    cd $dir
    ../../alzlibtool check library .
    cd ../..
done
