# Examples buildroot external

## Build

You have to clone buildroot and this layer. When building, use the
appropriate defconfig in the `buildroot-external-examples/configs`
directory.

```
git clone git://git.busybox.net/buildroot -b tbd
git clone <tbd>
mkdir out
cd out
make -C ../buildroot BR2_EXTERNAL=../buildroot-external-examples O=`pwd` <DEFCONFIG>
make
```

The resulting bootloader, kernel, root filesystem and SD card image will
be put in the `build/images` directory.
