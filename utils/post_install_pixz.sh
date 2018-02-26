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
SELECT file_name
      ,length(file_base64_text)
  FROM t_files
 ORDER BY file_name
__HEREDOC__
cat /tmp/sql_result.txt

# ***** env *****

export PATH="/tmp/usr/bin:${PATH}"

export CFLAGS="-march=native -O2"
export CXXFLAGS="$CFLAGS"

# ***** libarchive *****

cd /tmp

wget https://www.libarchive.org/downloads/libarchive-3.3.2.tar.gz

tar xf libarchive-3.3.2.tar.gz

cd libarchive*

./configure --help
./configure --prefix=/tmp/usr
time make -j2
make install

# ***** pixz *****

cd /tmp

git clone --depth 1 https://github.com/vasi/pixz.git

cd pixz
./autogen.sh

./configure --help
./configure --prefix=/tmp/usr --without-manpage
time make -j2
make install

echo ${start_date}
date
