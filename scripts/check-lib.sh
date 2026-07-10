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

# Check if Azure CLI is authenticated; if not, fall back to offline mode
ARGS=()
if ! az account show &>/dev/null; then
    echo "==> Azure CLI not authenticated. Running in offline mode..."
    ARGS+=("--offline")
fi

# check library
alzlibtool check library "${ARGS[@]}" "$LIB" 2>&1
