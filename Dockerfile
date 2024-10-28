# Use the NVIDIA Vulkan base image
FROM nvidia/vulkan:1.3-470

# Make sure no user interaction is required during this script
ARG DEBIAN_FRONTEND=noninteractive

# Update repository key for NVIDIA
RUN apt-key del 7fa2af80
RUN rm /etc/apt/sources.list.d/cuda.list
ADD https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb .
RUN dpkg -i cuda-keyring_1.0-1_all.deb

# Install all the required packages not included in base image
RUN apt update
RUN apt install -y software-properties-common
RUN add-apt-repository -y ppa:flexiondotorg/mangohud
RUN dpkg --add-architecture i386
RUN mkdir -pm755 /etc/apt/keyrings
RUN wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
RUN wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/focal/winehq-focal.sources
RUN apt update
RUN apt-get install -y --install-recommends wget xvfb git python3-websockify x11vnc gstreamer1.0-plugins-ugly gstreamer1.0-plugins-good gstreamer1.0-libav gstreamer1.0-plugins-base winehq-stable mangohud

# Add noVNC support for preview
RUN git clone https://github.com/novnc/noVNC.git /opt/noVNC
RUN ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html

# Cleanup
RUN apt autoremove -y

# Copy wine prefix and mangohud settings
COPY wineprefix/ /wineprefix/
COPY mangohud/MangoHud.conf /root/.config/MangoHud/MangoHud.conf

# Add entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

