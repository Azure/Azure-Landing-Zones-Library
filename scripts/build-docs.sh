#!/usr/bin/env bash

echo "==> building docs with alzlibtool..."
libraries=$(ls ./platform)
for library in $libraries; do
    echo "==> building docs for $library..."
    cd ./platform/$library
    ../../alzlibtool document library . > README.md
    cd ../..
done
