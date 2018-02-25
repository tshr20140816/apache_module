#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

gcc --version

export HOME2=${PWD}
export PATH="/tmp/usr/bin:${PATH}"
export LD_LIBRARY_PATH=/tmp/usr/lib

export CFLAGS="-march=native -O2"
export CXXFLAGS="$CFLAGS"

parallels=$(grep -c -e processor /proc/cpuinfo)

# ***** gmp ******

cd /tmp

wget https://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.bz2
tar xf gmp-6.1.2.tar.bz2
cd gmp-6.1.2

./configure --help
./configure --prefix=/tmp/usr --mandir=/tmp/man --docdir=/tmp/doc
time make -j${parallels}
make install

# ***** mpfr ******

cd /tmp

wget http://www.mpfr.org/mpfr-current/mpfr-4.0.1.tar.gz
tar xf mpfr-4.0.1.tar.gz
cd mpfr-4.0.1
./configure --help
./configure --prefix=/tmp/usr --mandir=/tmp/man --docdir=/tmp/doc
time make -j${parallels}
make install

# ***** mpc ******

cd /tmp

wget https://ftp.gnu.org/gnu/mpc/mpc-1.1.0.tar.gz
tar xf mpc-1.1.0.tar.gz
cd mpc-1.1.0
./configure --help
./configure --prefix=/tmp/usr --mandir=/tmp/man --docdir=/tmp/doc --with-gmp==/tmp/usr --with-mpfr=/tmp/usr
time make -j${parallels}
make install

# ***** gcc ******

cd /tmp

wget http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-7.3.0/gcc-7.3.0.tar.gz

tar xf gcc-7.3.0.tar.gz

cd gcc-7.3.0

./configure --help
./configure --prefix=/tmp/usr --mandir=/tmp/man --docdir=/tmp/doc \
  --with-gmp==/tmp/usr --with-mpfr=/tmp/usr --with-mpc=/tmp/usr

cd /tmp/usr

ls -Ralng

df ./ -mh

echo ${start_date}
date
