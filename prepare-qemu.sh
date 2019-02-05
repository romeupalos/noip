#!/bin/bash
set -euxo pipefail

VERSION=${QEMU_VERSION:=3.1.0}
TARGETS=${ARCH}-linux-user

echo "VERSION: $VERSION"
echo "TARGETS: $TARGETS"

wget -c "http://wiki.qemu-project.org/download/qemu-$VERSION.tar.bz2"
tar -xf "qemu-$VERSION.tar.bz2"
rm "qemu-$VERSION.tar.bz2"
cd "qemu-$VERSION"

./configure \
  --target-list="$TARGETS" \
  --disable-docs \
  --disable-sdl \
  --disable-gtk \
  --disable-gnutls \
  --disable-gcrypt \
  --disable-nettle \
  --disable-curses \
  --static

make -j $(nproc)
cp ./${ARCH}-linux-user/qemu-${ARCH} ../qemu-${ARCH}-static

cd ../
rm -rf "qemu-$VERSION"
