#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

cd /tmp

wget https://jaist.dl.sourceforge.net/project/expect/Expect/5.45.4/expect5.45.4.tar.gz

tar xf expect5.45.4.tar.gz

cd expect5.45.4
./configure --prefix=/tmp/usr
time make
make install

echo ${start_date}
date
