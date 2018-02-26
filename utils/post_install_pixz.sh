#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

gcc --version
pkg-config --help

# ***** postgresql *****

postgres_user=$(echo ${DATABASE_URL} | awk -F':' '{print $2}' | sed -e 's/\///g')
postgres_password=$(echo ${DATABASE_URL} | grep -o '/.\+@' | grep -o ':.\+' | sed -e 's/://' | sed -e 's/@//')
postgres_server=$(echo ${DATABASE_URL} | awk -F'@' '{print $2}' | awk -F':' '{print $1}')
postgres_dbname=$(echo ${DATABASE_URL} | awk -F'/' '{print $NF}')

echo ${postgres_user}
echo ${postgres_password}
echo ${postgres_server}
echo ${postgres_dbname}

export PGPASSWORD=${postgres_password}

psql -U ${postgres_user} -d ${postgres_dbname} -h ${postgres_server} > /tmp/sql_result.txt << __HEREDOC__
SELECT file_name
      ,length(file_base64_text)
  FROM t_files
 ORDER BY file_name
__HEREDOC__
cat /tmp/sql_result.txt

# ***** env *****

export PATH="/tmp/usr/bin:${PATH}"
export LD_LIBRARY_PATH=/tmp/usr/lib

export CFLAGS="-march=native -O2"
export CXXFLAGS="$CFLAGS"

psql -U ${postgres_user} -d ${postgres_dbname} -h ${postgres_server} > /tmp/sql_result.txt << __HEREDOC__
SELECT file_base64_text
  FROM t_files
 WHERE file_name = 'usr.tar.bz2'
__HEREDOC__

# ***** /tmp/usr *****

cd /tmp

mkdir -m 777 usr

set +x
echo $(cat /tmp/sql_result.txt | head -n 3 | tail -n 1) > /tmp/usr.tar.bz2.base64.txt
set -x
base64 -d /tmp/usr.tar.bz2.base64.txt > /tmp/usr.tar.bz2
tar xf /tmp/usr.tar.bz2 -C /tmp/usr --strip=1

cd usr

ls -Rlang

# ***** libarchive *****

cd /tmp

wget https://www.libarchive.org/downloads/libarchive-3.3.2.tar.gz

tar xf libarchive-3.3.2.tar.gz

cd libarchive-3.3.2

./configure --help
./configure --prefix=/tmp/usr --mandir=/tmp/man --docdir=/tmp/doc
time make -j2
make install

export PKG_CONFIG_PATH=/tmp/usr/lib/pkgconfig
pkg-config --exists --print-errors "libarchive"

ls -Rlang /tmp/usr

# ***** pixz *****

cd /tmp

git clone --depth 1 https://github.com/vasi/pixz.git

cd pixz
./autogen.sh

./configure --help
# LIBARCHIVE_LIBS=$HOME/pixz_build/lib/libarchive.a LZMA_LIBS=$HOME/pixz_build/lib/liblzma.a ./configure --prefix="$HOME/pixz_build"
ls -lang /tmp/usr/lib/libarchive.a
LIBARCHIVE_LIBS=/tmp/usr/lib/libarchive.a ./configure --prefix=/tmp/usr --without-manpage
time make -j2
make install

ls -Rlang /tmp/usr

ldd /tmp/usr/bin/pixz

cd /tmp

time tar cf libarchive1.tar.xz --use-compress-prog=pixz libarchive-3.3.2
time tar cf libarchive2.tar.xz --use-compress-prog=xz libarchive-3.3.2

ls -lang

echo ${start_date}
date
