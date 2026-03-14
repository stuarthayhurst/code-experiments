#!/bin/bash

#Pass the version to download as the first argument
#Pass "firmware" as the second argumen to download images with non-free firmware
#Use SIGNATUREKEYFILE="" to set a file to use for verifying checksum signatures
#  - Only required if not downloading from a Debian machine with 'debian-keyring' installed, as the local copy will be used by default

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

if [[ -x "$(command -v wget)" ]]; then
  downloadCommand="wget"
elif [[ -x "$(command -v curl)" ]]; then
  downloadCommand="curl"
else
  echo "Couldn't find a program to download with"
  exit 1
fi

if [[ -x "$(command -v sha512sum)" ]]; then
  checkImageChecksum="true"

  if [[ -x "$(command -v gpg)" ]]; then
    checkChecksumSignature="true"

    keyFileName="$SIGNATUREKEYFILE"
    if [[ "$SIGNATUREKEYFILE" == "" ]]; then
      keyFileName="/usr/share/keyrings/debian-role-keys.gpg"
    fi

  fi
fi

#Download a file from a URL and optionally supply a file name
downloadFile() {
  url="$1"
  fileName="$2"
  if [[ "$2" == "" ]]; then
    fileName="${url##*/}"
  fi

  if [[ "$downloadCommand" == "curl" ]]; then
    $downloadCommand -L -o "$fileName" "$url"
  elif [[ "$downloadCommand" == "wget" ]]; then
    $downloadCommand -O "$fileName" "$url"
  fi
}

echo "Using '$downloadCommand' to download images"
if [[ "$checkImageChecksum" == "true" ]]; then
  echo "Downloaded images will have their checksums verified"
  if [[ "$checkChecksumSignature" == "true" ]]; then
    echo "Checksums will have their signatures verified with '$keyFileName'"
  fi
fi
echo -e "\n"

for url in "${imageUrls[@]}"; do
  downloadFile "$url"

  #Verify image checksum
  if [[ "$checkImageChecksum" == "true" ]]; then
    tempPath="$(mktemp -d)"

    checksumUrl="${url%/*}/SHA512SUMS"
    checksumFileName="$tempPath/debian-image-downloader-checksum"
    downloadFile "$checksumUrl" "$checksumFileName"

    if ! sha512sum --ignore-missing -c "$checksumFileName"; then
      echo "Checksum verification failed"
      rm -rf "$tempPath"
      exit 1
    fi

    #Verify checksum signature
    if [[ "$checkChecksumSignature" == "true" ]]; then
      signatureUrl="${url%/*}/SHA512SUMS.sign"
      signatureFileName="$tempPath/debian-image-downloader-signature"
      downloadFile "$signatureUrl" "$signatureFileName"

      if ! gpg --keyring "$keyFileName" --verify "$signatureFileName" "$checksumFileName"; then
        echo "Checksum signature verification failed"
        rm -rf "$tempPath"
        exit 1
      fi
    fi

    rm -rf "$tempPath"
  fi
done
