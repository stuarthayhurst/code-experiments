#!/usr/bin/bash

echo "deb https://deb.debian.org/debian/ sid main contrib non-free non-free-firmware" > /etc/apt/sources.list
echo "deb-src https://deb.debian.org/debian/ sid main contrib non-free non-free-firmware" >> /etc/apt/sources.list
echo "deb https://deb.debian.org/debian/ experimental main contrib non-free non-free-firmware" >> /etc/apt/sources.list
echo "deb-src https://deb.debian.org/debian/ experimental main contrib non-free non-free-firmware" >> /etc/apt/sources.list

apt update
echo "y" | apt install bash-completion build-essential devscripts wget -t unstable

echo "y" | apt-get build-dep linux -t unstable

if [[ "$1" == "experimental" ]]; then
  apt-get source linux -t experimental
  apt install python3-dacite
else
  apt-get source linux -t unstable
fi

cd "linux-*" || exit 1

find ../patches/* -maxdepth 1 -print0 |xargs -0 bash debian/bin/test-patches -f amd64
