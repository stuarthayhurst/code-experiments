#!/usr/bin/bash

if [[ -d "build" ]]; then
  echo "build/ already exists, exiting"
  exit 1
fi

if [[ "$1" == "experimental" ]]; then
  echo "Starting experimental build, press enter to confirm"
  read -r
fi

sudo debootstrap unstable build
sudo mkdir build/patches
sudo cp patches/* build/patches/
sudo cp internal.sh build/
sudo chroot build ./internal.sh "$1"
