FROM debian:stable

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && \
    apt-get -y install \
        wget busybox unzip patch parted \
        qemu-user-static debootstrap \
        dosfstools btrfs-progs f2fs-utils \
        make build-essential bc xxd kmod vim \
        gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/*

COPY . /RPi-arm64/

# Never required
#VOLUME [ "/RPi-arm64/build", "/RPi-arm64/dist" ]

WORKDIR /RPi-arm64
