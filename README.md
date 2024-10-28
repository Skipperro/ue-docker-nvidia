# ue-docker-nvidia
Run Windows Unreal Engine applications inside a Linux docker container using NVIDIA GPU.

> [!CAUTION]
> This is just a proof of concept and work in progress piece of code. It works on my machine and with my application.
>
> Your milage may vary. **Run at your own risk** ❗

## Features
- Supports **DirectX 11 and 12** applications with output to Vulkan.
- **noVNC** server included.
- **MangoHud** included.

## Specs
- **Wine** 9.0
- **DXVK** 1.10.3
- **VKD3D** 2.8

## Instructions
### System requirements
- NVIDIA GPU with drivers **535.xx** or newer.
- Linux Kernel **5.x** or newer.
- Internet connection.

### Install docker
Installation script is available at https://get.docker.com/
```
curl -fsSL https://get.docker.com -o install-docker.sh
sudo sh install-docker.sh
```
### Install nvidia-container-toolkit
Instructions are available at https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html
```
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
```
```
sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
```
### Clone this repository
```
git clone https://github.com/Skipperro/ue-docker-nvidia.git
cd ue-docker-nvidia
```
### Build image
> [!NOTE]
> Because building wineprefix to run Unreal Engine applications requires GUI, thus it's not running well on systems without desktop environment, as part of the image building the already **prepared wineprefix will be downloaded** from https://public.skipperro.net/ue-docker-nvidia-wineprefix.zip (625 MB)
> 
> If you would like to build wineprefix yourself, you will find instructions [on the bottom](#building-custom-wineprefix) on this page.
```
sudo sh build.sh
```

### Copy your application to app directory
Copy the whole UE application to the `app` directory. No zip files - It must be extracted.

The included script will find the proper executable automatically, as long as there is just one .exe file in `Project/Binaries/Win64` directory.

You can even have spaces in project name, but for now only one app can be present in the app directory.

### Run the application
```
sudo sh run.sh [optional parameters to pass to UE application]
```

### Check if it's running using VNC
Just visit http://localhost:5678/

Replace `localhost` with IP if you are testing from different device.

While running via VNC or pixelstreaming use **Shift+F12** to bring up MangoHud with performance statistics.

## Building custom wineprefix
If you want to build your own wineprefix instead of downloading mine, here is what is required:
- Mono installed (popup should show automatically on first run)
- Visual C++ Redsitributables 2022 (winetricks vcrun2022). This works only in desktop environment.
- DXVK 1.10.3 (winedricks dxvk1103). Newer version might work, but might also cause conflicts with VKD3D.
- VKD3D 2.8. Please download from GitHub. Since version 2.9 file structure is different and may cause issues with running UE apps.
