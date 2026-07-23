#!/usr/bin/bash

#Set up a build environment and source code for a mainline kernel
#Pass "stable" to use the stable kernel source tree instead of Torvalds'
#Requires debootstrap and an internet connection

#Check for root
if [[ "$(id -u)" != "0" ]]; then
  echo "Script must be run as root, exiting" >&2
  exit 1
fi

#Bail if an existing instance is present
if [[ -d "build-mainline" ]]; then
  echo "build-mainline/ already exists, exiting" >&2
  exit 1
fi

#Install the base system
debootstrap unstable build-mainline
if [[ "$?" != "0" ]]; then
  echo "Failed to install the base system, exiting" >&2
  exit 1
fi

#Copy the set up script
cp internal-mainline.sh build-mainline/

#Bind mount /proc and run the set up script
mount --bind /proc build-mainline/proc
chroot build-mainline ./internal-mainline.sh "$1"
if [[ "$?" != "0" ]]; then
  echo "Failed to set up the kernel build, exiting" >&2
  exit 1
fi

#Provide build instructions
echo -e "\nSetup complete, swap into chroot, then setup '.config' and build with 'make bindeb-pkg -j$(nproc)'"

echo -e "\n/proc has been bind mounted to 'build-mainline/proc'"
echo " - When done, unmount with 'sudo umount build-mainline/proc'"
echo " - If required, remount with 'sudo mount --bind /proc build-mainline/proc'"
