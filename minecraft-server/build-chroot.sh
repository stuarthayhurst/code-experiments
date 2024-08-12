#!/bin/bash

source scripts/config

DIR="$(basename "$(pwd)")"
sudo debootstrap unstable "$ENVPATH"
sudo mkdir -p "${ENVPATH}/${DIR}"

sudo mount --bind /proc "${ENVPATH}/proc"
sudo chroot "$ENVPATH" bash -c "apt update; echo 'y' | apt install default-jre-headless wget git; exit"
sudo umount "${ENVPATH}/proc"
