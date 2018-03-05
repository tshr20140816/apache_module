#!/bin/bash

set -x

export TZ=JST-9

httpd -V
httpd -M
php --version
python --version
whereis python
cat /proc/version
curl --version
gcc --version
printenv

ls -lang

export LD_LIBRARY_PATH=/tmp/usr/lib

mkdir -p /tmp/usr/lib
cp ./libpython2.7.so.1.0 /tmp/usr/lib/
cp ./mod_wsgi.so /tmp/usr/lib

ldd /tmp/usr/lib/mod_wsgi.so

# chmod +x libbrotlicommon.so.1
# chmod +x libbrotlienc.so.1

# mkdir -p /tmp/usr/lib
# cp libnghttp2.so.14 /tmp/usr/lib/
# cp libbrotlicommon.so.1 /tmp/usr/lib/
# cp libbrotlienc.so.1 /tmp/usr/lib/

# ls -lang /tmp/usr/lib/

# ldd /tmp/usr/lib/libbrotlicommon.so.1
# ldd /tmp/usr/lib/libbrotlienc.so.1

# ldd ./mod_http2.so
# ldd ./mod_proxy_http2.so
# ldd ./mod_brotli.so
# ldd ./mod_cache_disk.so

# pushd www
# wget https://git.tt-rss.org/fox/tt-rss/raw/master/css/tt-rss.less
# mv tt-rss.less tt-rss.css
# gzip tt-rss.css
# rm tt-rss.css
# popd

vendor/bin/heroku-php-apache2 -C apache.conf www
