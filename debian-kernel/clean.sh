#!/usr/bin/bash

clean_directory() {
  echo "Cleaning '$1'..."

  if [[ -d "$1/proc" ]]; then
    sudo umount -q "$1/proc"
  fi

  sudo rm -rvf "$1"
}

if [[ "$1" != "" ]]; then
  clean_directory "$1"
else
  clean_directory "build-debian"
  clean_directory "build-mainline"
fi
