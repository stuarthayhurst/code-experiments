#!/usr/bin/bash

if [[ -d "build-mainline" ]]; then
  echo "build-mainline/ already exists, exiting"
  exit 1
fi

sudo debootstrap unstable build-mainline
sudo cp internal-mainline.sh build-mainline/

sudo mount --bind /proc build-mainline/proc
sudo chroot build-mainline ./internal-mainline.sh "$1"

echo -e "\nSetup complete, swap into chroot, then setup '.config' and build with 'make bindeb-pkg -j$(nproc)'"

echo -e "\n/proc has been bind mounted to 'build-mainline/proc'"
echo " - When done, unmount with 'sudo umount build-mainline/proc'"
echo " - If required, remount with 'sudo mount --bind /proc build-mainline/proc'"
