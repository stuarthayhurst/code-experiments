#!/usr/bin/bash

if [[ "$(id -u)" != "0" ]]; then
  echo "Script must be run as root, exiting" >&2
  exit 1
fi

if [[ -d "build-mainline" ]]; then
  echo "build-mainline/ already exists, exiting" >&2
  exit 1
fi

debootstrap unstable build-mainline
if [[ "$?" != "0" ]]; then
  echo "Failed to install the base system, exiting" >&2
  exit 1
fi

cp internal-mainline.sh build-mainline/

mount --bind /proc build-mainline/proc
chroot build-mainline ./internal-mainline.sh "$1"

echo -e "\nSetup complete, swap into chroot, then setup '.config' and build with 'make bindeb-pkg -j$(nproc)'"

echo -e "\n/proc has been bind mounted to 'build-mainline/proc'"
echo " - When done, unmount with 'sudo umount build-mainline/proc'"
echo " - If required, remount with 'sudo mount --bind /proc build-mainline/proc'"
