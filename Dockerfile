FROM debian:stable

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && \
    apt-get -y install \
        git vim parted wget busybox \
        qemu-user-static debootstrap \
        dosfstools btrfs-progs make \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/*

COPY . /RPi-arm64/

VOLUME [ "/RPi-arm64/build", "/RPi-arm64/dist" ]

WORKDIR /RPi-arm64
