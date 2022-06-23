#!/bin/bash
set -euxo pipefail

VERSION=${QEMU_VERSION:=7.0.0}
TARGETS=${ARCH}-${OS}-user

echo "VERSION: $VERSION"
echo "TARGETS: $TARGETS"

sudo apt update
sudo apt install -y wget lbzip2 python3 make ninja-build gcc pkg-config libglib2.0-dev

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
cp ./build/qemu-${ARCH} ../qemu-${ARCH}-static

cd ../
rm -rf "qemu-$VERSION"
