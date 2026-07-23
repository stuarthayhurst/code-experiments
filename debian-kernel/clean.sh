#!/usr/bin/bash

if [[ -d "build/proc" ]]; then
  sudo umount -q build/proc
fi

if [[ -d "build-mainline/proc" ]]; then
  sudo umount -q build-mainline/proc
fi

sudo rm -rvf build/ build-mainline/
