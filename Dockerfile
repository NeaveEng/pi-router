FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get clean && apt-get update && \
    apt-get install -y \
    build-essential gawk luajit flex git gettext \
    python3-distutils rsync unzip wget nano file \
    libssl-dev zlib1g-dev curl \
    gcc-multilib libncurses-dev libncursesw-dev \
    xsltproc python3
    

RUN mkdir -p /root/.ssh
RUN chmod 644 /root/.ssh

# Add build user.
RUN useradd -ms /bin/bash build

# Create build directory.
RUN mkdir /build && chown build:build /build
WORKDIR /build

# Clone OpenWRT.
USER build
RUN git clone --branch openwrt-22.03 https://git.openwrt.org/openwrt/openwrt.git
WORKDIR /build/openwrt

# Download and apply the patch for the fan controller
RUN curl -0 /build/openwrt/emc2301-openwrt.patch https://gist.githubusercontent.com/shayne/bc9f3778b53134d3274f9794eba4f874/raw/9b455e2ef262b729800ea8009e8a774966110c6c/emc2301-openwrt.patch
# RUN cd /build/openwrt/ && git apply ./emc2301-openwrt.patch 

# Update the feeds.
RUN ./scripts/feeds update -a
RUN ./scripts/feeds install -a

CMD ["bash"]
