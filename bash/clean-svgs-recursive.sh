#!/bin/bash

#Get a list of directories and the root directory
readarray -t dirList <<< "$(find ./ -type d)"
startDir="$(pwd)"

#Loop through directories, generate the full path, and compress and svgs
for i in "${dirList[@]}"; do
  svgs=()
  targetDir="$startDir/${i/"./"}"

  for svg in "$targetDir/"*.svg; do
    if [[ -f "$svg" ]]; then
      svgs+=("$svg")
    fi
  done

  for svg in "${svgs[@]}"; do
    if [[ ! -L "$svg" ]]; then
      echo "$svg"
      SELF_CALL=1 inkscape "--vacuum-defs" "--export-filename=$svg" "$svg"
    fi
  done
done
