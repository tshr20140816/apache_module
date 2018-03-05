#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

whereis python
python --version

find / -name libpython2.7.so.1.0 -print

ldd /usr/lib/x86_64-linux-gnu/libpython2.7.so.1.0

cp /usr/lib/x86_64-linux-gnu/libpython2.7.so.1.0 ./.heroku/php/libexec/

ls -lang ./.heroku/php/libexec/libpython2.7.so.1.0

export CFLAGS="-march=native -O2"
export CXXFLAGS="$CFLAGS"

cd /tmp

wget https://github.com/GrahamDumpleton/mod_wsgi/archive/4.6.2.tar.gz

tar xf 4.6.2.tar.gz

cd mod_wsgi-4.6.2

./configure --help
./configure --prefix=/tmp/usr --mandir=/tmp/man --docdir=/tmp/doc --enable-framework
time make -j2
make install

ls -Rlang /tmp/usr

find / -name mod_wsgi.so -print

cp /usr/lib/x86_64-linux-gnu/libpython2.7.so.1.0

cd /tmp

# wget https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v2.1/source/pgadmin4-2.1.tar.gz

# tar xf pgadmin4-2.1.tar.gz

# cd pgadmin4-2.1

# time make -j2

# ls -Rlang


echo ${start_date}
date

