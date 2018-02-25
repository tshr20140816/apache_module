#!/bin/bash

set -x

export TZ=JST-9

httpd -V
httpd -M
php --version
whereis php
cat /proc/version
curl --version
gcc --version
printenv

ls -lang

export LD_LIBRARY_PATH=/tmp/usr/lib

# chmod +x libbrotlicommon.so.1
# chmod +x libbrotlienc.so.1

mkdir -p /tmp/usr/lib
cp libnghttp2.so.14 /tmp/usr/lib/
cp libbrotlicommon.so.1 /tmp/usr/lib/
cp libbrotlienc.so.1 /tmp/usr/lib/

ls -lang /tmp/usr/lib/

ldd /tmp/usr/lib/libbrotlicommon.so.1
ldd /tmp/usr/lib/libbrotlienc.so.1

ldd ./mod_http2.so
ldd ./mod_proxy_http2.so
ldd ./mod_brotli.so
ldd ./mod_cache_disk.so

vendor/bin/heroku-php-apache2 -C apache.conf www
