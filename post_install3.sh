#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

gcc --version

cd /tmp

wget http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-7.3.0/gcc-7.3.0.tar.gz

tar xf gcc-7.3.0.tar.gz

cd gcc-7.3.0

./configure --help
./configure --prefix=/tmp/usr

echo ${start_date}
date
