#!/bin/bash
# allow only root BTW
if [ "0$UID" -ne 0 ]; then
   echo "Only root can run this script"; exit 1
fi
# clean working directory
rm -rf build/
mkdir build && cd build
# fetch latest released tinycorelinux core
wget http://tinycorelinux.net/11.x/x86/release/Core-current.iso -O tinycore.iso
mkdir tinycore && cd tinycore
# unpack iso file
bsdtar xfp ../tinycore.iso
chmod -R 0755 .
# should now have boot/core cpio archive
gzip -d boot/core.gz
mkdir cpioroot && cd cpioroot
# almost fucked my system up due to that PHUCKING cpio archive
cpio -i --no-absolute-filenames < ../boot/core
# place checkra1n to /usr/bin
wget https://assets.checkra.in/downloads/linux/cli/x86_64/b0edbb87a5e084caf35795dcb3b088146ad5457235940f83e007f59ca57b319c/checkra1n-x86_64 -O usr/bin/checkra1n
# repack and create new cpio archive
find . -depth -print | cpio -o > ../boot/core
# repack with gz
gzip ../boot/core
# rm cpioroot
rm -rf ../cpioroot
cd ~/tinyra1n
chmod -R 0755 build/
xorrisofs -o output.iso \
   -b boot/isolinux/isolinux.bin -c boot/isolinux/boot.cat \
   -no-emul-boot -boot-load-size 4 -boot-info-table \
   build/tinycore