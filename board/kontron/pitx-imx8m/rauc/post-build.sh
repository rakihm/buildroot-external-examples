#!/bin/sh

set -e

BOARD_DIR="$(dirname $0)"
PARTUUID="$($HOST_DIR/bin/uuidgen)"

mkdir -p $TARGET_DIR/boot/
cp ${BINARIES_DIR}/boot.scr ${TARGET_DIR}/boot/boot.scr

# Copy RAUC certificate
install -D -m 0644 ${BOARD_DIR}/cert/cert.pem ${TARGET_DIR}/etc/rauc/keyring.pem

