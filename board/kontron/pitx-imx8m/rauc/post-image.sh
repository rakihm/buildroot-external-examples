#!/bin/sh

set -e

BOARD_DIR="$(dirname $0)"

support/scripts/genimage.sh -c ${BOARD_DIR}/genimage.cfg


################################################################################
# RAUC update bundle for the bootpartition
################################################################################
[ -e ${BINARIES_DIR}/bootpartition.raucb ] && rm -rf ${BINARIES_DIR}/bootpartition.raucb
[ -e ${BINARIES_DIR}/temp-rootfs ] && rm -rf ${BINARIES_DIR}/temp-rootfs
mkdir -p ${BINARIES_DIR}/temp-rootfs

#############################################################
# /!\ RAUC requires ".img" file endings for boot-emmc format.
#############################################################

# - Fill first region (33k) with 0xff
dd if=/dev/zero ibs=1k count=33 | tr '\000' '\377' > ${BINARIES_DIR}/bootpartition.img
# - Append flash.bin
dd if=${BINARIES_DIR}/flash.bin of=${BINARIES_DIR}/bootpartition.img bs=1k seek=33

cat >> ${BINARIES_DIR}/temp-rootfs/manifest.raucm << EOF
[update]
compatible=pitx-imx8m-rauc
version=${VERSION}

[bundle]
format=verity

[image.bootloader]
filename=bootpartition.img
EOF

# link file(s) that should be included into the bundle into the temp folder
# RAUC will include ALL files located there.
ln -L ${BINARIES_DIR}/bootpartition.img ${BINARIES_DIR}/temp-rootfs/

${HOST_DIR}/bin/rauc bundle \
	--cert ${BOARD_DIR}/cert/cert.pem \
	--key ${BOARD_DIR}/cert/key.pem \
	${BINARIES_DIR}/temp-rootfs/ \
	${BINARIES_DIR}/bootpartition.raucb


################################################################################
# RAUC update bundle for the rootf
################################################################################
[ -e ${BINARIES_DIR}/rootfs.raucb ] && rm -rf ${BINARIES_DIR}/rootfs.raucb
[ -e ${BINARIES_DIR}/temp-rootfs ] && rm -rf ${BINARIES_DIR}/temp-rootfs
mkdir -p ${BINARIES_DIR}/temp-rootfs

cat >> ${BINARIES_DIR}/temp-rootfs/manifest.raucm << EOF
[update]
compatible=pitx-imx8m-rauc
version=${VERSION}

[bundle]
format=verity

[image.rootfs]
filename=rootfs.ext4
EOF

# link file(s) that should be included into the bundle into the temp folder
# RAUC will include ALL files located there.
ln -L ${BINARIES_DIR}/rootfs.ext4 ${BINARIES_DIR}/temp-rootfs/

${HOST_DIR}/bin/rauc bundle \
	--cert ${BOARD_DIR}/cert/cert.pem \
	--key ${BOARD_DIR}/cert/key.pem \
	${BINARIES_DIR}/temp-rootfs/ \
	${BINARIES_DIR}/rootfs.raucb
