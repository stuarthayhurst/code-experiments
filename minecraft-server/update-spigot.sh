#!/bin/bash

source scripts/config

rm -rf "$BUILDPATH"
mkdir -p "$BUILDPATH"
mkdir -p "$JARPATH"
cd "$BUILDPATH" || exit 1

wget -O BuildTools.jar https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
java -jar BuildTools.jar --rev "$VERSION"
mv "spigot-$VERSION.jar" "../$JARPATH/"
