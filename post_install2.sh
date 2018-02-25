#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

gcc --version

export PATH="/tmp/usr/bin:${PATH}"

export CFLAGS="-march=native -O2"
export CXXFLAGS="$CFLAGS"

cd /tmp

wget http://ftp.gnu.org/pub/gnu/gettext/gettext-latest.tar.gz

tar xf gettext-latest.tar.gz
cd gettext*
./configure --help
./configure --prefix=/tmp/usr --disable-java --disable-native-java --without-emacs
make -j2
make install

cd /tmp

git clone --depth 1 https://github.com/xz-mirror/xz

cd xz
./autogen.sh

./configure --help
./configure --prefix=/tmp/usr
time make -j2
make install

cd /tmp

wget https://www.libarchive.org/downloads/libarchive-3.3.2.tar.gz

tar xf libarchive-3.3.2.tar.gz

cd libarchive*

./configure --help
./configure --prefix=/tmp/usr

exit

cd /tmp

git clone --depth 1 https://github.com/vasi/pixz.git

cd pixz
./autogen.sh

./configure --help
./configure --prefix=/tmp/usr --without-manpage
time make -j2
make install

cd /tmp/usr/bin

ls -lang

ldd xz

echo ${start_date}
date
