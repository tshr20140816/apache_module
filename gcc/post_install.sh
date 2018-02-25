#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

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
CREATE TABLE t_files (
  file_name character varying(255) NOT NULL
 ,file_base64_text text NOT NULL
);
ALTER TABLE t_files ADD CONSTRAINT table_key PRIMARY KEY(file_name);
__HEREDOC__
cat /tmp/sql_result.txt

psql -U ${postgres_user} -d ${postgres_dbname} -h ${postgres_server} > /tmp/sql_result.txt << __HEREDOC__
SELECT file_name
      ,length(file_base64_text)
  FROM t_files
 ORDER BY file_name
__HEREDOC__
cat /tmp/sql_result.txt

# ***** env *****

export HOME2=${PWD}
export PATH="/tmp/usr/bin:${PATH}"
export LD_LIBRARY_PATH=/tmp/usr/lib

export CFLAGS="-march=native -O2"
export CXXFLAGS="$CFLAGS"

parallels=$(grep -c -e processor /proc/cpuinfo)

# ***** gmp ******

cd /tmp

wget https://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.bz2
tar xf gmp-6.1.2.tar.bz2
cd gmp-6.1.2

./configure --help
./configure --prefix=/tmp/usr --mandir=/tmp/man --docdir=/tmp/doc
time make -j${parallels}
make install

# ***** mpfr ******

cd /tmp

wget http://www.mpfr.org/mpfr-current/mpfr-4.0.1.tar.gz
tar xf mpfr-4.0.1.tar.gz
cd mpfr-4.0.1
./configure --help
./configure --prefix=/tmp/usr --mandir=/tmp/man --docdir=/tmp/doc
time make -j${parallels}
make install

# ***** mpc ******

cd /tmp

wget https://ftp.gnu.org/gnu/mpc/mpc-1.1.0.tar.gz
tar xf mpc-1.1.0.tar.gz
cd mpc-1.1.0
./configure --help
./configure --prefix=/tmp/usr --mandir=/tmp/man --docdir=/tmp/doc --with-gmp==/tmp/usr --with-mpfr=/tmp/usr
time make -j${parallels}
make install

# ***** gcc ******

cd /tmp

wget http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-7.3.0/gcc-7.3.0.tar.gz

tar xf gcc-7.3.0.tar.gz

cd gcc-7.3.0

./configure --help
./configure --prefix=/tmp/usr --mandir=/tmp/man --docdir=/tmp/doc \
  --with-gmp==/tmp/usr --with-mpfr=/tmp/usr --with-mpc=/tmp/usr \
  --disable-multilib

cd /tmp/usr

ls -Ralng

cd /tmp

time tar -jcf usr.tar.bz2 usr

base64 -w 0 usr.tar.bz2 > usr.tar.bz2.base64.txt

set +x
base64_text=$(cat /tmp/ccache_cache.tar.bz2.base64.txt)

psql -U ${postgres_user} -d ${postgres_dbname} -h ${postgres_server} > /tmp/sql_result.txt << __HEREDOC__
INSERT INTO t_files (file_name, file_base64_text) VALUES ('usr.tar.bz2', '${base64_text}');
__HEREDOC__
set -x

ls -lang

echo ${start_date}
date
