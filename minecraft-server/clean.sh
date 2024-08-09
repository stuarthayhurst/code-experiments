#!/bin/bash

source scripts/config

sudo umount "${ENVPATH}/tmp"
sudo umount "${ENVPATH}/proc"
sudo umount "../${DIR}" "${ENVPATH}/${DIR}"

rm -rvf "$BUILDPATH"
sudo rm -rvf "$ENVPATH"
