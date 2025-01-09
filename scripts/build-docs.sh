#!/usr/bin/env bash

set -eo pipefail

# The first argument passed to the script, representing the library directory
LIB="$1"

echo "==> building docs with alzlibtool \"$LIB\"..."
# Check if alzlibtool is installed
if ! command -v alzlibtool &> /dev/null; then
    echo "alzlibtool could not be found. Please install it and ensure it is in your PATH."
    exit 1
fi

# does the $LIB directory exist?
if [ ! -d "$LIB" ]; then
    echo "==> \"$LIB\" does not exist. Exiting..."
    exit 1
fi

# build docs for the specified library
alzlibtool document library "$LIB" > "$LIB/README.md"
