#!/bin/bash

set -x

export TZ=JST-9

ls -lang
mkdir -p /tmp/usr/lib
cp libnghttp2.so.14 /tmp/usr/lib/

ldd ./mod_proxy_http2.so

vendor/bin/heroku-php-apache2 -C apache.conf www
