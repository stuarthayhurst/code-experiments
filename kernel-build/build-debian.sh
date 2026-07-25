#!/usr/bin/bash
#shellcheck disable=SC2181

#Set up a build environment and source code for a Debian kernel
#Optionally pass "experimental" to use the kernel version from experimental
#Optionally pass a name for a new directory to use as the build environment
#Any patches in "patches/" will be applied before the build starts
#Requires debootstrap and an internet connection

#Process passed arguments
internalArgs=""
buildDir="build-debian"
for arg in "${@}"; do
  #Pass "experimental" to chroot script if passed
  if [[ "$arg" == "experimental" ]]; then
    internalArgs="experimental"
  fi

  #Use the first non-empty, non-"experimental" argument as the build environment name
  if [[ "$buildDir" == "build-debian" ]]; then
    if [[ "$arg" != "" ]] && [[ "$arg" != "experimental" ]]; then
      buildDir="$arg"
    fi
  fi
done

#Check for root
if [[ "$(id -u)" != "0" ]]; then
  echo "Script must be run as root, exiting" >&2
  exit 1
fi

#Bail if an existing instance is present
if [[ -d "$buildDir" ]]; then
  echo "'$buildDir' already exists, exiting" >&2
  exit 1
fi

if [[ "$1" == "experimental" ]]; then
  echo "Starting experimental build, press enter to confirm"
  read -r
fi

#Install the base system
debootstrap --include=ca-certificates unstable "$buildDir"
if [[ "$?" != "0" ]]; then
  echo "Failed to install the base system, exiting" >&2
  exit 1
fi

#Copy the patches and set up script
mkdir "$buildDir/patches"
cp patches/* "$buildDir/patches/"
cp internal-debian.sh "$buildDir"

#Bind mount /proc and run the internal build script
mount --bind /proc "$buildDir/proc"
chroot "$buildDir" ./internal-debian.sh "$internalArgs"
if [[ "$?" != "0" ]]; then
  echo "Failed to build the kernel, exiting" >&2
  exit 1
fi
umount "$buildDir/proc"
