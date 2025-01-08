#!/usr/bin/env bash
lib=$1

echo "==> building docs with alzlibtool $lib..."
libraries=$(ls ./platform)
for library in $libraries; do
    if [ ! -z "$lib" ] && [ "$lib" != "$library" ]; then
        continue
    fi

    echo "==> building docs for $library..."
    cd ./platform/$library
    ../../alzlibtool document library . > README.md
    cd ../..
done
