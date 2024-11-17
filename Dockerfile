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
RUN apt install -y software-properties-common wget
RUN add-apt-repository -y ppa:flexiondotorg/mangohud
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN dpkg --add-architecture i386
RUN mkdir -pm755 /etc/apt/keyrings
RUN wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
RUN wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/focal/winehq-focal.sources
RUN apt update
RUN apt-get install -y --no-install-recommends xvfb git python3-websockify gstreamer1.0-plugins-ugly gstreamer1.0-plugins-good gstreamer1.0-libav gstreamer1.0-plugins-base winehq-stable mangohud

# Install Xpra
RUN wget -qO "/usr/share/keyrings/xpra.asc" https://xpra.org/xpra.asc
RUN wget -qO "/etc/apt/sources.list.d/xpra.sources" https://raw.githubusercontent.com/Xpra-org/xpra/master/packaging/repos/focal/xpra.sources
RUN apt update
RUN apt-get install -y --no-install-recommends xpra xpra-html5 xpra-codecs xpra-codecs-nvidia xpra-codecs-extras xpra-x11 xpra-audio xpra-server dbus dbus-x11
RUN apt install -y --no-install-recommends libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio
RUN apt install -y mesa-utils python3-uinput

# Cleanup
RUN apt autoremove -y

# Copy wine prefix and mangohud settings
COPY wineprefix/ /wineprefix/
COPY mangohud/MangoHud.conf /root/.config/MangoHud/MangoHud.conf

# Add entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

