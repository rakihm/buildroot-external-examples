# Mainline Linux on Kontron SMARC sAL28

This document describes how to build and install a mainline linux kernel
on the device. It is not officially supported by Kontron.

## Building

An executable image is created with the help of buildroot. The following is a
list of all the required commands:

```
cd <BUILD_DIR>
git clone https://github.com/kontron/buildroot-external-examples
git clone git://git.buildroot.net/buildroot
cd buildroot
make BR2_EXTERNAL=../buildroot-external-examples kontron_smarc_sal28_defconfig
make
```

## Output

After the build has finished the following files are availabe in the
output folder:

```
.
├── freescale
│   ├── fsl-ls1028a-kontron-kbox-a-230-ls.dtb
│   ├── fsl-ls1028a-kontron-sl28.dtb
│   ├── fsl-ls1028a-kontron-sl28-var2.dtb
│   ├── fsl-ls1028a-kontron-sl28-var3-ads2.dtb
│   └── fsl-ls1028a-kontron-sl28-var4.dtb
├── genimage.cfg
├── Image
├── rcw
│   ├── sl28-1-11gq.bin
│   ├── sl28-1-11xx.bin
│   ├── sl28-1-1sgq.bin
│   ├── sl28-1-1sxx.bin
│   ├── sl28-1-221q.bin
│   ├── sl28-1-2222.bin
│   ├── sl28-1-22gq.bin
│   ├── sl28-1-22xx.bin
│   ├── sl28-1-4444.bin
│   ├── sl28-1-xxxx.bin
│   ├── sl28-2-11__.bin
│   ├── sl28-2-1s__.bin
│   ├── sl28-2-22__.bin
│   ├── sl28-3-11_q.bin
│   ├── sl28-3-1s_q.bin
│   ├── sl28-3-22_q.bin
│   ├── sl28-4-11_q.bin
│   ├── sl28-4-1s_q.bin
│   └── sl28-4-22_q.bin
├── rcw.bin -> rcw/sl28-3-11_q.bin
├── rootfs.ext2
├── rootfs.ext4 -> rootfs.ext2
├── rootfs.tar
├── sdcard-emmc.img
└── u-boot.rom
```

## Copying the image to eMMC storage device

### Booted from SD card

To write the image (sdcard-emmc.img) to the onboard eMMC storage device boot
from SD card. Now you're able to write the image to the eMMC.

To get the image to the board you can e.g. use the wget command:

```
cd /root
wget http://<location>/sdcard-emmc.img
```


```
dd if=sdcard-emmc.img of=/dev/mmcblk0 bs=1M
```

### Flashing from U-Boot

```
=> setenv autoload no
=> dhcp
=> tftp $loadaddr <TFTPSERVERIP>:<LOCATION>/sdcard-emmc.img
Using enetc-0 device
TFTP from server 10.0.1.36; our IP address is 10.0.1.118
Filename 'user/ht/sdcard-emmc.img'.
Load address: 0x82000000
Loading: #################################################################
         #################################################################
         :
         #################################################################
         ######
         8 MiB/s
done
Bytes transferred = 138432512 (8405000 hex)
=>
```

The mmc write command need the target size as block count in hex. So we have
to calculate it:

filesize/blockcount = 138432512 / 512 = 270376 = 0x42028

```
=> mmc write $loadaddr 0 0x42028

MMC write: dev # 0, block # 0, count 270376 ... 270376 blocks written: OK
```

## Ethernet Connectivity


There are 6 ethernet interfaces available on the front of the device. 2 are
connected to the CPU and the other 4 are connected to the integrated
ethernet switch.

```
 ----------------------------------------------------------
|   PCB                                                    |
 ----------------------------------------------------------
                           | GBE1 |  | swp1 |  | swp3 |
						   :------:  :------:  :------:
                           | GBE0 |  | swp0 |  | swp2 |
						   `------´  `------´  `------´
```
