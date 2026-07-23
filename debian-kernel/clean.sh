#!/usr/bin/bash

clean_directory() {
  echo "Cleaning '$1'..."

  #Unmount /proc if present
  if [[ -d "$1/proc" ]]; then
    umount -q "$1/proc"
  fi

  #Delete the environment
  rm -rvf "$1"
}

#Check for root
if [[ "$(id -u)" != "0" ]]; then
  echo "Script must be run as root, exiting" >&2
  exit 1
fi

#Either delete the specific directories, or "build-debian" and "build-mainline"
if [[ "$1" != "" ]]; then
  clean_directory "$1"
else
  clean_directory "build-debian"
  clean_directory "build-mainline"
fi
