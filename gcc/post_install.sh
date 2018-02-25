#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

gcc --version

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

# ***** GMP ******

cd /tmp

wget https://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.bz2

cd gmp-6.1.2

./configure --help
./configure --prefix=/tmp/usr

cd /tmp

#wget http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-7.3.0/gcc-7.3.0.tar.gz

#tar xf gcc-7.3.0.tar.gz

#cd gcc-7.3.0

#./configure --help
#./configure --prefix=/tmp/usr

echo ${start_date}
date
