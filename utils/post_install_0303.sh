#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

# *****

cd /tmp

wget https://github.com/aria2/aria2/releases/download/release-1.33.1/aria2-1.33.1.tar.bz2

tar xvf aria2-1.33.1.tar.bz2

cd aria2-1.33.1

./configure --help
./configure --prefix=/tmp/usr
make -j2
make install
