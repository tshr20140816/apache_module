#!/bin/bash

set -x

printenv

postgres_user=$(echo ${DATABASE_URL} | awk -F':' '{print $2}' | sed -e 's/\///g')
postgres_password=$(echo ${DATABASE_URL} | grep -o '/.\+@' | grep -o ':.\+' | sed -e 's/://' | sed -e 's/@//')
postgres_server=$(echo ${DATABASE_URL} | awk -F'@' '{print $2}' | awk -F':' '{print $1}')
postgres_dbname=$(echo ${DATABASE_URL} | awk -F'/' '{print $NF}')

echo ${postgres_user}
echo ${postgres_password}
echo ${postgres_server}
echo ${postgres_dbname}

export PGPASSWORD=${postgres_password}

psql --help

psql -U ${postgres_user} -d ${postgres_dbname} -h ${postgres_server} > /tmp/sql_result.txt << _EOF
CREATE TABLE t_files (
  file_name character varying(255) NOT NULL
 ,file_base64_text text NOT NULL
);
ALTER TABLE t_files ADD CONSTRAINT table_key PRIMARY KEY(file_name);
_EOF
cat /tmp/sql_result.txt

psql -U ${postgres_user} -d ${postgres_dbname} -h ${postgres_server} > /tmp/sql_result.txt << _EOF
SELECT file_base64_text
  FROM t_files
 WHERE file_name = 'dummy'
_EOF
cat /tmp/sql_result.txt

psql -U ${postgres_user} -d ${postgres_dbname} -h ${postgres_server} > /tmp/sql_result.txt << _EOF
INSERT INTO t_files (file_name, file_base64_text) VALUES ('dummy1', '1234567890');
_EOF
cat /tmp/sql_result.txt

psql -U ${postgres_user} -d ${postgres_dbname} -h ${postgres_server} > /tmp/sql_result.txt << _EOF
SELECT file_base64_text
  FROM t_files
 WHERE file_name = 'dummy'
_EOF
cat /tmp/sql_result.txt

cat /tmp/sql_result.txt | tail -n 1

exit

date
start_date=$(date)

chmod 777 start_web.sh

export HOME2=${PWD}
export PATH="/tmp/usr/bin:${PATH}"

export CFLAGS="-march=native -O2"
export CXXFLAGS="$CFLAGS"

cd /tmp

openssl version

wget https://c-ares.haxx.se/download/c-ares-1.13.0.tar.gz &
wget http://www.digip.org/jansson/releases/jansson-2.11.tar.bz2 &
wget https://github.com/nghttp2/nghttp2/releases/download/v1.30.0/nghttp2-1.30.0.tar.xz &
wget https://cmake.org/files/v3.10/cmake-3.10.2-Linux-x86_64.tar.gz &
git clone --depth 1 https://github.com/google/brotli &
wget http://ftp.tsukuba.wide.ad.jp/software/apache//apr/apr-1.6.3.tar.bz2 &
wget http://ftp.tsukuba.wide.ad.jp/software/apache//apr/apr-util-1.6.1.tar.bz2 &
wget http://ftp.jaist.ac.jp/pub/apache//httpd/httpd-2.4.29.tar.gz &


wget https://www.samba.org/ftp/ccache/ccache-3.3.4.tar.gz
tar xf ccache-3.3.4.tar.gz
cd ccache-3.3.4
./configure --prefix=/tmp/usr
time make -j$(grep -c -e processor /proc/cpuinfo)
make install

cd /tmp/usr/bin
ln -s ccache gcc
ln -s ccache g++
ln -s ccache cc
ln -s ccache c++

mkdir -m 777 /tmp/ccache
export CCACHE_DIR=/tmp/ccache

ccache -s
ccache -z

wait

cd /tmp

# wget https://c-ares.haxx.se/download/c-ares-1.13.0.tar.gz
tar xf c-ares-1.13.0.tar.gz
cd c-ares-1.13.0
./configure --prefix=/tmp/usr
time make -j$(grep -c -e processor /proc/cpuinfo)
make install

cd /tmp

# wget http://www.digip.org/jansson/releases/jansson-2.11.tar.bz2
tar xf jansson-2.11.tar.bz2
cd jansson-2.11
./configure --prefix=/tmp/usr
time make -j$(grep -c -e processor /proc/cpuinfo)
make install

cd /tmp

# wget https://github.com/nghttp2/nghttp2/releases/download/v1.30.0/nghttp2-1.30.0.tar.xz
tar xf nghttp2-1.30.0.tar.xz
cd nghttp2-1.30.0

LIBCARES_CFLAGS="-I/tmp/usr/include" LIBCARES_LIBS="-L/tmp/usr/lib -lcares" \
 JANSSON_CFLAGS="-I/tmp/usr/include" JANSSON_LIBS="-L/tmp/usr/lib -ljansson" \
 ./configure --prefix=/tmp/usr --disable-examples --disable-dependency-tracking \
 --enable-lib-only
time make -j$(grep -c -e processor /proc/cpuinfo)
make install

cd /tmp

# wget https://cmake.org/files/v3.10/cmake-3.10.2-Linux-x86_64.tar.gz
tar xf cmake-3.10.2-Linux-x86_64.tar.gz -C ./usr --strip=1 

cd /tmp

# git clone --depth 1 https://github.com/google/brotli
cd brotli
mkdir out
cd out
../configure-cmake --prefix=/tmp/usr --disable-debug
make -j$(grep -c -e processor /proc/cpuinfo)
make install

cd /tmp

# wget http://ftp.tsukuba.wide.ad.jp/software/apache//apr/apr-1.6.3.tar.bz2
tar xf apr-1.6.3.tar.bz2
cd apr-1.6.3
./configure --prefix=/tmp/usr
time make -j$(grep -c -e processor /proc/cpuinfo)
make install

cd /tmp

# wget http://ftp.tsukuba.wide.ad.jp/software/apache//apr/apr-util-1.6.1.tar.bz2
tar xf apr-util-1.6.1.tar.bz2
cd apr-util-1.6.1
./configure --prefix=/tmp/usr --with-apr=/tmp/usr
time make -j$(grep -c -e processor /proc/cpuinfo)
make install

cd /tmp

# wget http://ftp.jaist.ac.jp/pub/apache//httpd/httpd-2.4.29.tar.gz
tar xf httpd-2.4.29.tar.gz
cd httpd-2.4.29
./configure --help
# ./configure --prefix=/tmp/usr2 \
#  --with-apr=/tmp/usr --enable-ssl --enable-http2 --enable-proxy --enable-proxy-http2 --with-nghttp2=/tmp/usr
./configure --prefix=/tmp/usr2 \
 --with-apr=/tmp/usr --enable-ssl --enable-http2 --enable-proxy --enable-proxy-http2 --with-nghttp2=/tmp/usr \
 --enable-brotli --with-brotli=/tmp/usr --enable-mods-shared=few
time make -j$(grep -c -e processor /proc/cpuinfo)
make install

cd /tmp
tar -jcf ccache_cache.tar.bz2 ccache
base64 -w 0 ccache_cache.tar.bz2 > ccache_cache.tar.bz2.base64.txt
zip -9r ccache_cache.zip ./ccache
base64 -w 0 ccache_cache.zip > ccache_cache.zip.base64.txt

# ls -Rlang /tmp/usr
# ls -Rlang /tmp/usr2

cp /tmp/usr/lib/libnghttp2.so.14 ${HOME2}/
cp /tmp/usr2/modules/mod_proxy_http2.so ${HOME2}/
cp /tmp/usr2/modules/mod_http2.so ${HOME2}/
cp /tmp/usr/lib/libbrotlicommon.so.1 ${HOME2}/
cp /tmp/usr/lib/libbrotlienc.so.1 ${HOME2}/
cp /tmp/usr2/modules/mod_brotli.so ${HOME2}/

cp /tmp/usr/lib/libnghttp2.so.14 ${HOME2}/www/
cp /tmp/usr2/modules/mod_proxy_http2.so ${HOME2}/www/
cp /tmp/usr2/modules/mod_http2.so ${HOME2}/www/
cp /tmp/usr/lib/libbrotlicommon.so.1 ${HOME2}/www/
cp /tmp/usr/lib/libbrotlienc.so.1 ${HOME2}/www/
cp /tmp/usr2/modules/mod_brotli.so ${HOME2}/www/

ccache -s

ls -lang

echo ${start_date}
date
