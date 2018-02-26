#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

gcc --version

cd /tmp

wget mirrors.kernel.org/ubuntu/pool/main/g/gcc-5/gcc-5_5.4.0-6ubuntu1~16.04.9_amd64.deb

gdebi gcc-5_5.4.0-6ubuntu1~16.04.9_amd64.deb

echo ${start_date}
date
