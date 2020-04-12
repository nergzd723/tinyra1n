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
mkdir cpioroot && cd cpioroot
# almost fucked my system up due to that PHUCKING cpio archive
zcat ../boot/core.gz | cpio -d -i -H newc
# place checkra1n to /usr/bin
wget https://assets.checkra.in/downloads/linux/cli/i486/9b7a5c7821c8e06a334b854c5ffad7b28c56a5ac261afe3c6b647c9ba7185aee/checkra1n-i486 -O usr/bin/checkra1n
chmod +x usr/bin/checkra1n
cp ~/tinyra1n/resources/boot.msg ../boot/isolinux/boot.msg
# repack and create new cpio archive
find | cpio -H newc -o | gzip -9 > ../boot/core.gz
# repack with gz
# rm cpioroot
rm -rf ../cpioroot
cd ~/tinyra1n
chmod -R 0755 build/
xorrisofs -o output.iso \
   -b boot/isolinux/isolinux.bin -c boot/isolinux/boot.cat \
   -no-emul-boot -boot-load-size 4 -boot-info-table \
   build/tinycore

