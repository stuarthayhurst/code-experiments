#!/usr/bin/bash

if [[ "$(id -u)" != "0" ]]; then
  echo "Script must be run as root, exiting" >&2
  exit 1
fi

if [[ -d "build-debian" ]]; then
  echo "build-debian/ already exists, exiting" >&2
  exit 1
fi

if [[ "$1" == "experimental" ]]; then
  echo "Starting experimental build, press enter to confirm"
  read -r
fi

debootstrap unstable build-debian
if [[ "$?" != "0" ]]; then
  echo "Failed to install the base system, exiting" >&2
  exit 1
fi

mkdir build-debian/patches
cp patches/* build-debian/patches/
cp internal-debian.sh build-debian/

mount --bind /proc build-debian/proc
chroot build-debian ./internal-debian.sh "$1"
umount build-debian/proc
