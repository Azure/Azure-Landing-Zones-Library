#!/usr/bin/env bash

set -eo pipefail

# The first argument passed to the script, representing the library directory
LIB="$1"

echo "==> checking library with alzlibtool \"$LIB\"..."
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

# check library (use --offline if Azure credentials are not available)
if az account show &>/dev/null; then
    alzlibtool check library "$LIB" 2>&1
else
    echo "==> Azure credentials not available, running offline check..."
    alzlibtool check library --offline "$LIB" 2>&1
fi
