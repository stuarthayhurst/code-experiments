#!/bin/bash

debianVersion="$1"

if [[ "$2" == *"firmware" ]]; then
  outputPath="$(pwd)/Firmware"
  imageUrls=("https://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/current/amd64/iso-cd/firmware-$debianVersion-amd64-netinst.iso" #Netinst firmware
  "https://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/current/amd64/iso-dvd/firmware-$debianVersion-amd64-DVD-1.iso" #DVD firmware
  "https://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/current-live/amd64/iso-hybrid/debian-live-$debianVersion-amd64-gnome+nonfree.iso" #GNOME live firmware
  "https://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/current-live/amd64/iso-hybrid/debian-live-$debianVersion-amd64-standard+nonfree.iso") #Standard live firmware
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
