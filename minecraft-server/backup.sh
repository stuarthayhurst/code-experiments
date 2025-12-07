#!/bin/bash

source scripts/config

if [[ -d "$BACKUPPATH" ]]; then
  mkdir -p "$BACKUPPATH/$VERSION"
  FILE="$BACKUPPATH/$VERSION/$BACKUPNAME-$(date +%Y%m%d)"
else
  FILE="./$BACKUPNAME-$VERSION-$(date +%Y%m%d)"
fi

DIR="$(basename "$(pwd)")"
cd ../
tar cf "${FILE}.tar.bz2" --use-compress-prog=pbzip2 \
  --exclude "./$DIR/$BUILDPATH/*" \
  --exclude "./$DIR/$BUILDPATH" \
  "./$DIR/"
