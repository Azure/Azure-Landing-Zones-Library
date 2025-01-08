#!/usr/bin/env bash
lib=$1

echo "==> checking docs with alzlibtool $lib..."
libraries=$(ls ./platform)
for library in $libraries; do
    if [ ! -z "$lib" ] && [ "$lib" != "$library" ]; then
        continue
    fi

    echo "==> checking docs for $library..."
    dir="./platform/$library"
    cd $dir
    ../../alzlibtool document library . > README-CHECK.md
    if [ ! -z "$(diff -q "README.md" "README-CHECK.md")" ]; then
		echo "==> $dir/README.md is out of date. Run 'make docs' to update the generated document and commit."
		rm "README-CHECK.md"
        cd ../..
		exit 1
	fi

    cd ../..
done
