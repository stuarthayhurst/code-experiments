#!/usr/bin/bash
#shellcheck disable=SC2181

#Set up a build environment and source code for a Debian kernel
#Pass "experimental" to use the kernel version from experimental
#Any patches in "patches/" will be applied before the build starts
#Requires debootstrap and an internet connection

#Check for root
if [[ "$(id -u)" != "0" ]]; then
  echo "Script must be run as root, exiting" >&2
  exit 1
fi

#Bail if an existing instance is present
if [[ -d "build-debian" ]]; then
  echo "build-debian/ already exists, exiting" >&2
  exit 1
fi

if [[ "$1" == "experimental" ]]; then
  echo "Starting experimental build, press enter to confirm"
  read -r
fi

#Install the base system
debootstrap --include=ca-certificates unstable build-debian
if [[ "$?" != "0" ]]; then
  echo "Failed to install the base system, exiting" >&2
  exit 1
fi

#Copy the patches and set up script
mkdir build-debian/patches
cp patches/* build-debian/patches/
cp internal-debian.sh build-debian/

#Bind mount /proc and run the internal build script
mount --bind /proc build-debian/proc
chroot build-debian ./internal-debian.sh "$1"
if [[ "$?" != "0" ]]; then
  echo "Failed to build the kernel, exiting" >&2
  exit 1
fi
umount build-debian/proc
