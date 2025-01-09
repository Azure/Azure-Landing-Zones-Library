#!/usr/bin/env bash

set -eo pipefail

# The first argument passed to the script, representing the library directory
LIB="$1"

echo "==> checking docs with alzlibtool \"$LIB\"..."
# Check if alzlibtool is installed
if ! command -v alzlibtool &> /dev/null; then
    echo "alzlibtool could not be found. Please install it and ensure it is in your PATH."
    exit 1
fi

# does the $lib directory exist?
if [ ! -d "$LIB" ]; then
    echo "==> \"$LIB\" does not exist. Exiting..."
    exit 1
fi

TMPREADME="_README.md"

# build docs for the specified library
alzlibtool document library "$LIB" > "$LIB/$TMPREADME"
if [ ! -z "$(diff -q "$LIB/README.md" "$LIB/$TMPREADME")" ]; then
  echo "==> $LIB/README.md is out of date. Run 'make docs LIB=\"$LIB\"' to update the generated document and commit."
  rm "$LIB/$TMPREADME"
  exit 1
fi
