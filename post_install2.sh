#!/bin/bash

set -x

date
start_date=$(date)

export HOME2=${PWD}
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

ls -Rlang /tmp/usr

cd /tmp

git clone --depth 1 https://github.com/xz-mirror/xz

cd xz
./autogen.sh

./configure --help

./configure --prefix=/tmp/usr

date
