#!/usr/bin/bash

clean_directory() {
  echo "Cleaning '$1'..."

  if [[ -d "$1/proc" ]]; then
    umount -q "$1/proc"
  fi

  rm -rvf "$1"
}

if [[ "$(id -u)" != "0" ]]; then
  echo "Script must be run as root, exiting" >&2
  exit 1
fi

if [[ "$1" != "" ]]; then
  clean_directory "$1"
else
  clean_directory "build-debian"
  clean_directory "build-mainline"
fi
