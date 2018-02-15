#!/bin/bash

set -x

date

# nikto
# wget https://cirt.net/nikto/nikto-2.1.5.tar.gz
# tar xvfz nikto-2.1.5.tar.gz
# pushd nikto-*
# perl ./nikto.pl -update
# popd

wget http://ftp.jaist.ac.jp/pub/GNU/libtool/libtool-2.4.6.tar.xz
tar xf libtool-2.4.6.tar.xz

cd libtool-2.4.6
ls -lang

./configure --prefix=/tmp/libtool/
make -j4
make install

ls -lang /tmp/libtool/bin

cd ~

git clone --depth 1 -b 2.4.x https://github.com/apache/httpd.git

cd httpd/srclib
ls -lang

git clone --depth 1 https://github.com/apache/apr.git
cd apr

# printenv

export PATH="/tmp/libtool/bin:$PATH"

./buildconf --help
./buildconf

exit

./configure  --enable-proxy-http2 --enable-http2 --enable-proxy-http

date
