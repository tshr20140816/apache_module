#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

gcc --version

# https://packages.ubuntu.com/xenial/gdebi
# https://packages.ubuntu.com/xenial-updates/devel/gcc-5

cd /tmp

wget http://mirrors.kernel.org/ubuntu/pool/main/g/gcc-5/gcc-5_5.4.0-6ubuntu1~16.04.9_amd64.deb

dpkg -i gcc-5_5.4.0-6ubuntu1~16.04.9_amd64.deb

echo ${start_date}
date
