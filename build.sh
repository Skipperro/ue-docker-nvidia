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
    rm -rf $script_dir/vkd3d
    sleep 2
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
    echo "Installing Visual C++ Redistributables and DirectX 11 (DXVK)..."
    sleep 5    
    winetricks -q vcrun2022 dxvk1103 win10
    if [ ! -d $script_dir/vkd3d ]; then
        apt install -y tar zstd
        mkdir -p $script_dir/vkd3d
        sleep 1
        wget -qO- https://github.com/HansKristian-Work/vkd3d-proton/releases/download/v2.8/vkd3d-proton-2.8.tar.zst | tar -I zstd -x -C $script_dir/vkd3d
        sleep 1
    fi
    chmod +x $script_dir/vkd3d/vkd3d-proton-2.8/setup_vkd3d_proton.sh
    echo "Installing DirectX 12 (VKD3D)..."
    sleep 5    
    $script_dir/vkd3d/vkd3d-proton-2.8/setup_vkd3d_proton.sh install
    chmod -R 777 "$WINEPREFIX"
    chmod -R 777 "$script_dir/vkd3d"

    echo Installing Wine-Mono...
    sleep 5
    # Set variables
    WINE_MONO_VERSION="9.3.0"
    WINE_MONO_URL="https://dl.winehq.org/wine/wine-mono/${WINE_MONO_VERSION}/wine-mono-${WINE_MONO_VERSION}-x86.msi"
    
    # Download wine-mono
    wget "${WINE_MONO_URL}" -O "wine-mono-${WINE_MONO_VERSION}-x86.msi"
    
    # Install wine-mono
    wine msiexec /i "wine-mono-${WINE_MONO_VERSION}-x86.msi"
    rm wine-mono-${WINE_MONO_VERSION}-x86.msi
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
