#!/usr/bin/bash

URL="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git"
if [[ "$1" == "stable" ]]; then
  URL="https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git"
fi

echo "deb http://deb.debian.org/debian/ sid main contrib non-free non-free-firmware" > /etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian/ sid main contrib non-free non-free-firmware" >> /etc/apt/sources.list

echo "y" | apt update
echo "y" | apt install git bash-completion wget
echo "y" | apt build-dep linux

git clone "$URL"
echo -e "\nSetup complete, swap into chroot, then setup '.config' and build with 'make bindeb-pkg -j$(nproc)'"
