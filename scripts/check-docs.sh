#!/usr/bin/env bash

echo "==> checking docs with alzlibtool..."
libraries=$(ls ./platform)
for library in $libraries; do
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
	rm -f "$dir/README-generated.md"
    cd ../..
done
