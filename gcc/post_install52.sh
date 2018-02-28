#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh
chmod 755 loggly.sh

gcc --version

whereis gcc

ldd /usr/bin/gcc

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

# ***** utils *****

cd /tmp

mkdir -m 777 usr

psql -U ${postgres_user} -d ${postgres_dbname} -h ${postgres_server} > /tmp/sql_result.txt << __HEREDOC__
SELECT file_base64_text
  FROM t_files
 WHERE file_name = 'usr.tar.bz2'
__HEREDOC__

if [ $(cat /tmp/sql_result.txt | grep -c '(1 row)') -eq 1 ]; then
  set +x
  echo $(cat /tmp/sql_result.txt | head -n 3 | tail -n 1) > /tmp/usr.tar.bz2.base64.txt
  set -x
  base64 -d /tmp/usr.tar.bz2.base64.txt > /tmp/usr.tar.bz2
  tar xf /tmp/usr.tar.bz2 -C /tmp/usr --strip=1
fi

# ***** env *****

export HOME2=${PWD}
export PATH="/app/bin:/tmp/usr/bin:${PATH}"
export LD_LIBRARY_PATH=/tmp/usr/lib

export CFLAGS="-march=native -O2"
export CXXFLAGS="$CFLAGS"

parallels=$(grep -c -e processor /proc/cpuinfo)

# ***** ccache *****

cd /tmp

wget https://www.samba.org/ftp/ccache/ccache-3.3.4.tar.gz
tar xf ccache-3.3.4.tar.gz
cd ccache-3.3.4
./configure --help
./configure --prefix=/tmp/usr --mandir=/tmp/man --docdir=/tmp/doc 2>&1 | ${HOME2}/loggly.sh
time make -j${parallels}
make install

cd /tmp/usr/bin
ln -s ccache gcc
ln -s ccache g++
ln -s ccache cc
ln -s ccache c++

mkdir -m 777 /tmp/ccache
export CCACHE_DIR=/tmp/ccache

time psql -U ${postgres_user} -d ${postgres_dbname} -h ${postgres_server} > /tmp/sql_result.txt << __HEREDOC__
SELECT file_base64_text
  FROM t_files
 WHERE file_name = 'ccache_cache.gcc.tar.bz2'
__HEREDOC__

if [ $(cat /tmp/sql_result.txt | grep -c '(1 row)') -eq 1 ]; then
  set +x
  time echo $(cat /tmp/sql_result.txt | head -n 3 | tail -n 1) > /tmp/ccache_cache.tar.bz2.base64.txt
  set -x
  time base64 -d /tmp/ccache_cache.tar.bz2.base64.txt > /tmp/ccache_cache.tar.bz2
  tar xf /tmp/ccache_cache.tar.bz2 -C /tmp/ccache --strip=1
fi

psql -U ${postgres_user} -d ${postgres_dbname} -h ${postgres_server} > /tmp/sql_result.txt << __HEREDOC__
DELETE
  FROM t_files
 WHERE file_name = 'ccache_cache.gcc.tar.bz2'
__HEREDOC__

ccache -s
ccache -z

# ***** gcc *****

cd /tmp

time wget http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-7.3.0/gcc-7.3.0.tar.gz

tar xf gcc-7.3.0.tar.gz

cd gcc-7.3.0
mkdir -m 777 work
cd work

../configure --help
time ../configure --prefix=/tmp/usr --mandir=/tmp/man --docdir=/tmp/doc \
  --with-gmp==/tmp/usr --with-mpfr=/tmp/usr --with-mpc=/tmp/usr \
  --disable-multilib --enable-stage1-languages=c,c++ \
  target=x86_64-pc-linux-gnu \
  --disable-libjava --disable-libgo --disable-libgfortran --disable-objc --enable-languages=c,c++

date

time make -j${parallels} | tee /tmp/make.gcc.log.txt
make install

cd /tmp
time tar -jcf ccache_cache.tar.bz2 ccache

base64 -w 0 ccache_cache.tar.bz2 > ccache_cache.tar.bz2.base64.txt

set +x
base64_text=$(cat /tmp/ccache_cache.tar.bz2.base64.txt)

psql -U ${postgres_user} -d ${postgres_dbname} -h ${postgres_server} > /tmp/sql_result.txt << __HEREDOC__
INSERT INTO t_files (file_name, file_base64_text) VALUES ('ccache_cache.gcc.tar.bz2', '${base64_text}');
__HEREDOC__
set -x

psql -U ${postgres_user} -d ${postgres_dbname} -h ${postgres_server} > /tmp/sql_result.txt << __HEREDOC__
INSERT INTO t_files (file_name, file_base64_text) VALUES ('dummy.gcc', 'dummy.gcc');
__HEREDOC__
echo ${start_date}
date
