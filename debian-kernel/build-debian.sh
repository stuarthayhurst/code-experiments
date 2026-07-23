#!/usr/bin/bash

if [[ -d "build-debian" ]]; then
  echo "build-debian/ already exists, exiting" >&2
  exit 1
fi

if [[ "$1" == "experimental" ]]; then
  echo "Starting experimental build, press enter to confirm"
  read -r
fi

sudo debootstrap unstable build-debian
if [[ "$?" != "0" ]]; then
  echo "Failed to install the base system, exiting" >&2
  exit 1
fi

sudo mkdir build-debian/patches
sudo cp patches/* build-debian/patches/
sudo cp internal-debian.sh build-debian/

sudo mount --bind /proc build-debian/proc
sudo chroot build-debian ./internal-debian.sh "$1"
sudo umount build-debian/proc
