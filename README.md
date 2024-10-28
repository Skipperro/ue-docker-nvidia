# ue-docker-nvidia
Run Windows Unreal Engine applications inside a Linux docker container using NVIDIA GPU.

## Features
- Supports DirectX 11 and 12 applications with output to Vulkan.
- noVNC server included.
- MangoHud included.

## Specs
- Wine 9.0
- DXVK 1.10.3
- VKD3D 2.8

## Instructions
### System requirements
- NVIDIA GPU with drivers 535.xx or newer.
- Linux Kernel 5.x or newer.

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

