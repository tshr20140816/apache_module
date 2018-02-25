#!/bin/bash

set -x

date
start_date=$(date)

export PATH="/tmp/usr/bin:${PATH}"

export CFLAGS="-march=native -O2"
export CXXFLAGS="$CFLAGS"

cd /tmp

wget http://ftp.gnu.org/pub/gnu/gettext/gettext-latest.tar.gz

tar xf gettext-latest.tar.gz
cd gettext*
./configure --help
./configure --prefix=/tmp/usr --disable-java --disable-native-java
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

git cline --depth 1 https://github.com/vasi/pixz.git

cd pixz
./autogen.sh

./configure --help
./configure --prefix=/tmp/usr
time make -j2
make install

cd /tmp/usr/bin

ls -lang

ldd xz

echo ${start_date}
date
