#!/bin/sh

# USAGE: 
# sudo sh build.sh [--clean]

# Set the script path to be independent of working directory
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

export WINEPREFIX="$script_dir/wineprefix"
export WINEDEBUG="-all"

if [ "$1" = "--clean" ]; then
    echo "--clean parameter detected. Deleting existing wineprefix..."
    sleep 2
    rm -rf "$WINEPREFIX"
    sleep 2
fi

if [ -d "$WINEPREFIX" ]; then
    echo "Wineprefix under $WINEPREFIX already exists. Skipping..."
else
    # Create wineprefix for running Unreal Engine apps in both DirectX 11 and DirectX 12
    echo "Downloading Wineprefix from skipperro.net..."
    mkdir "$WINEPREFIX"
    chmod -R 777 "$WINEPREFIX"
    wineboot -u
    # URL to download
    URL="https://public.skipperro.net/ue-docker-nvidia-wineprefix.zip"
    wget -O "$WINEPREFIX/ue-docker-nvidia-wineprefix.zip" "$URL"
    unzip -o "$WINEPREFIX/ue-docker-nvidia-wineprefix.zip" -d "$WINEPREFIX"
    chmod -R 777 "$WINEPREFIX"
fi

# Build image
echo "Building docker image..."
sleep 5
docker compose build
sleep 1

# Final notes
echo "====================================================================================="
echo "Image is ready!"
echo
echo "Place your Windows Unreal Engine application in ./app directory and run the command:"
echo "sudo sh run.sh"
echo "You can also add extra start parameters for Unreal Engin by passing them to docker:"
echo "sudo sh run.sh -dx11 -Unattended"
echo
echo "As long as there is only one .exe file in Project/Binaries/Win64 directory"
echo "the run_app.sh script will detect it and run automatically."
echo "====================================================================================="
