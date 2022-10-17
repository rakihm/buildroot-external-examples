# Kontron K-Switch D10 linux mainline configuration

## Prepare

```
git clone git://git.busybox.net/buildroot -b 2022.08
git clone https://github.com/hthiery/buildroot-external-examples.git
mkdir out
cd out
make -C ../buildroot BR2_EXTERNAL=../buildroot-external-examples O=`pwd` kontron_kswitch_d10_mainline_defconfig
```

## Configure

Change the configuration according to your needs and requirements.

```
make menuconfig
```

## Build

```
make
```

### Results

```
├── genimage.cfg
├── lan966x-kontron-kswitch-d10-mmt-6g-2gs.dtb
├── lan966x-kontron-kswitch-d10-mmt-8g.dtb
├── rootfs.cpio
├── rootfs.cpio.gz
├── rootfs.cpio.uboot
├── rootfs.ext2
├── rootfs.ext4 -> rootfs.ext2
├── rootfs.tar
├── sdcard.img
├── uImage
└── zImage
```

## Configuration

```
=> setenv ethrotate no
=> setenv ethact port3
=> savee
```

## Install the image to the eMMC

```
=> dhcp
=> tftp $loadaddr 10.0.1.36:user/ht/sdcard.img
```

Calculate blk count by getting file len/512

Example: transferred bytes: 113266688 => 113266688/512 = 221224 = 0x36028

```
=> mmc write $loadaddr 0 <BLK_COUNT>
```

## Start from eMMC
```
=> load mmc 0 0x64000000  boot/lan966x-kontron-kswitch-d10-mmt-6g-2gs.dtb
13573 bytes read in 9 ms (1.4 MiB/s)
=> load mmc 0 0x64010000  boot/zImage
10174976 bytes read in 276 ms (35.2 MiB/s)
=> bootz 0x64010000 - 0x64000000
```

## Load kernel and initrd via network

```
=> dhcp
=> tftp 0x64000000 10.0.1.36:user/ht/zImage
=> tftp 0x65000000 10.0.1.36:user/ht/lan966x-kontron-kswitch-d10-mmt-6g-2gs.dtb
=> tftp 0x65010000 10.0.1.36:user/ht/rootfs.cpio.uboot
=> bootz 0x64000000 0x65010000 0x65000000
```
