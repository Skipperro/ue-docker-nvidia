#!/bin/sh

# Get the directory where the script is located
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

# Search for the first file matching 'Binaries/Win64/*.exe' starting from script_dir
found_file=$(find "$script_dir" -type f -path '*/Binaries/Win64/*.exe' -print -quit)

if [ -n "$found_file" ]; then
    echo "Found executable: $found_file"
    echo "Running wine on $found_file with arguments: $RUN_ARGS $@"
    sleep 1
    mangohud wine "$found_file" $RUN_ARGS "$@"
else
    echo "Error: No executable file matching 'Binaries/Win64/*.exe' found."
    exit 1
fi
