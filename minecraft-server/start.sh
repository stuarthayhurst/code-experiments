#!/bin/bash

source scripts/config

if [[ "$1" == "" ]]; then
  echo "Select a .jar to run:"
  ls "./$JARPATH/"*".jar"
  read -r JAR
else
  JAR="$1"
fi

java "-Xms$MINRAM" "-Xmx$MAXRAM" -jar "$JAR" nogui
