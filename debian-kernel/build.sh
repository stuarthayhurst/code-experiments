#!/bin/bash

#Rebuild the upstream Debian Sid / Experimental kernel, applying any patches in 'patches/'

if [[ "$1" == "experimental" ]]; then
  echo "Starting experimental build, press enter to confirm"
  read
fi

sudo debootstrap unstable build
sudo mkdir build/patches
sudo cp patches/* build/patches/
sudo cp internal.sh build/
sudo chroot build ./internal.sh "$1"
