#!/bin/bash

source scripts/config

DIR="$(basename "$(pwd)")"

sudo mount --bind /tmp "${ENVPATH}/tmp"
sudo mount --bind /proc "${ENVPATH}/proc"
sudo mount --bind "../${DIR}" "${ENVPATH}/${DIR}"

sudo chroot "$ENVPATH" bash -c "cd $DIR; ./scripts/start.sh; exit"

sudo umount "${ENVPATH}/tmp"
sudo umount "${ENVPATH}/proc"
sudo umount "${ENVPATH}/${DIR}"
