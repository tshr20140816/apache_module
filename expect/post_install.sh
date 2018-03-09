#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

export PATH="/tmp/usr/bin:${PATH}"

cd /tmp

wget https://prdownloads.sourceforge.net/tcl/tcl8.6.8-src.tar.gz
tar xf tcl8.6.8-src.tar.gz
cd tcl*
pwd
ls -lang
./configure --help
./configure --prefix=/tmp/usr
time make
make install

cd /tmp

wget https://jaist.dl.sourceforge.net/project/expect/Expect/5.45.4/expect5.45.4.tar.gz

tar xf expect5.45.4.tar.gz

cd expect5.45.4
./configure --help
./configure --prefix=/tmp/usr
time make
make install

echo ${start_date}
date
