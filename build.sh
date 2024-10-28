#!/bin/sh

# USAGE: 
# sudo sh build.sh [--clean]

# Set the script path to be independent of working directory
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

export WINEPREFIX="$script_dir/wineprefix"
export WINEDEBUG="-all"

if [ "$1" = "--clean" ]; then
    echo "--clean parameter detected. Deleting existing wineprefix..."
    rm -rf "$WINEPREFIX"
fi

if [ -d "$WINEPREFIX" ]; then
    echo "Wineprefix under $WINEPREFIX already exists. Skipping..."
else
    # Create wineprefix for running Unreal Engine apps in both DirectX 11 and DirectX 12
    echo "Installing required Windows libraries..."
    mkdir "$WINEPREFIX"
    chmod -R 777 "$WINEPREFIX"
    wineboot -u
    winetricks --self-update
    winetricks -q vcrun2022 dxvk1103 win10
    chmod +x vkd3d/setup_vkd3d_proton.sh
    vkd3d/setup_vkd3d_proton.sh install
    chmod -R 777 "$WINEPREFIX"
fi

# Build image
echo "Building docker image..."
docker compose build

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
