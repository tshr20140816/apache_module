#!/bin/bash

set -x

export TZ=JST-9

ls -lang
mkdir -p /tmp/usr/lib
cp libnghttp2.so.14 /tmp/usr/lib/
cp libbrotlienc.so.1 /tmp/usr/lib/

ls -lang /tmp/usr/lib/

ldd /tmp/usr/lib/libbrotlienc.so.1

ldd ./mod_http2.so
ldd ./mod_proxy_http2.so
ldd ./mod_brotli.so

vendor/bin/heroku-php-apache2 -C apache.conf www
