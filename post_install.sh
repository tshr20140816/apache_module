#!/bin/bash

set -x

date

# nikto
# wget https://cirt.net/nikto/nikto-2.1.5.tar.gz
# tar xvfz nikto-2.1.5.tar.gz
# pushd nikto-*
# perl ./nikto.pl -update
# popd

wget https://github.com/nghttp2/nghttp2/releases/download/v1.30.0/nghttp2-1.30.0.tar.xz
tar xf nghttp2-1.30.0.tar.xz
cd nghttp2-1.30.0
./configure --help
./configure --prefix=/tmp/usr/

make -j4
make install

ls -Rlang /tmp/usr/

cd ~

wget http://ftp.jaist.ac.jp/pub/GNU/libtool/libtool-2.4.6.tar.xz
tar xf libtool-2.4.6.tar.xz

cd libtool-2.4.6

./configure --prefix=/tmp/usr/
make -j4
make install

cd ~

git clone --depth 1 -b 2.4.x https://github.com/apache/httpd.git

cd httpd/srclib
ls -lang

git clone --depth 1 https://github.com/apache/apr.git

cd ..
pwd

# printenv

export PATH="/tmp/usr/bin:$PATH"

./buildconf --help
./buildconf

ls -Rlang /tmp/usr/
ls -lang

./configure  --help
./configure  --enable-proxy-http2 --enable-http2 --enable-proxy-http --with-nghttp2=/tmp/usr

date
