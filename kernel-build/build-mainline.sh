#!/usr/bin/bash
#shellcheck disable=SC2181

#Set up a build environment and source code for a mainline kernel
#Optionally pass "stable" to use the stable kernel source tree instead of Torvalds'
#Optionally pass a name for a new directory to use as the build environment
#Requires debootstrap and an internet connection

#Process passed arguments
internalArgs=""
buildDir="build-mainline"
for arg in "${@}"; do
  #Pass "stable" to chroot script if passed
  if [[ "$arg" == "stable" ]]; then
    internalArgs="stable"
  fi

  #Use the first non-empty, non-"stable" argument as the build environment name
  if [[ "$buildDir" == "build-mainline" ]]; then
    if [[ "$arg" != "" ]] && [[ "$arg" != "stable" ]]; then
      buildDir="$arg"
    fi
  fi
done

#Check for root
if [[ "$(id -u)" != "0" ]]; then
  echo "Script must be run as root, exiting" >&2
  exit 1
fi

#Bail if an existing instance is present with the same name
if [[ -d "$buildDir" ]]; then
  echo "'$buildDir' already exists, exiting" >&2
  exit 1
fi

#Install the base system
debootstrap --include=ca-certificates unstable "$buildDir"
if [[ "$?" != "0" ]]; then
  echo "Failed to install the base system, exiting" >&2
  exit 1
fi

#Copy the set up script
cp internal-mainline.sh "$buildDir"

#Bind mount /proc and run the set up script
mount --bind /proc "$buildDir/proc"
chroot "$buildDir" ./internal-mainline.sh "$internalArgs"
if [[ "$?" != "0" ]]; then
  echo "Failed to set up the kernel build, exiting" >&2
  exit 1
fi

#Provide build instructions
echo -e "\nSetup complete, swap into chroot, then setup '.config' and build with 'make bindeb-pkg -j$(nproc)'"

echo -e "\n/proc has been bind mounted to '$buildDir/proc'"
echo " - When done, unmount with 'sudo umount $buildDir/proc'"
echo " - If required, remount with 'sudo mount --bind /proc $buildDir/proc'"
