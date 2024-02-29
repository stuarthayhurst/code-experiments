#!/usr/bin/bash

if [[ -d "build-mainline" ]]; then
  echo "build-mainline/ already exists, exiting"
  exit 1
fi

sudo debootstrap unstable build-mainline
sudo cp internal-mainline.sh build-mainline/
sudo chroot build-mainline ./internal-mainline.sh "$1"
