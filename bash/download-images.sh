#!/bin/bash

debianVersion="$1"

if [[ "$1" == "" ]]; then
  echo "Expected a version, got nothing"
  exit 1
elif [[ "$1" == *"firmware" ]]; then
  echo "Expected firmware toggle as the second argument"
  exit 1
fi

if [[ "$2" == *"firmware" ]]; then
  outputPath="$(pwd)/Firmware"
  imageUrls=("https://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/archive/$debianVersion+nonfree/amd64/iso-cd/firmware-$debianVersion-amd64-netinst.iso" #Netinst firmware
  "https://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/archive/$debianVersion+nonfree/amd64/iso-dvd/firmware-$debianVersion-amd64-DVD-1.iso" #DVD firmware
  "https://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/archive/$debianVersion-live+nonfree/amd64/iso-hybrid/debian-live-$debianVersion-amd64-gnome+nonfree.iso" #GNOME live firmware
  "https://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/archive/$debianVersion-live+nonfree/amd64/iso-hybrid/debian-live-$debianVersion-amd64-standard+nonfree.iso") #Standard live firmwa>
elif [[ "$2" != "" ]]; then
  echo "Expected firmware toggle as the second argument, got '$2'"
  exit 1
else
  outputPath="$(pwd)"
  imageUrls=("https://cdimage.debian.org/cdimage/release/current/amd64/iso-cd/debian-$debianVersion-amd64-netinst.iso" #Netinst
  "https://cdimage.debian.org/cdimage/release/current/amd64/iso-dvd/debian-$debianVersion-amd64-DVD-1.iso" #DVD
  "https://cdimage.debian.org/cdimage/release/current-live/amd64/iso-hybrid/debian-live-$debianVersion-amd64-gnome.iso" #GNOME live
  "https://cdimage.debian.org/cdimage/release/current-live/amd64/iso-hybrid/debian-live-$debianVersion-amd64-standard.iso") #Standard live
fi

echo "Saving files in '$outputPath'"
mkdir -p "$outputPath"
cd "$outputPath" || exit 1
for url in "${imageUrls[@]}"; do
  wget "$url"
done
