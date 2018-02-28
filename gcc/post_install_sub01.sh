#!/bin/bash

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

sleep 3m

cd /tmp
time tar -jcf ccache_cache.tar.bz2 ccache

base64 -w 0 ccache_cache.tar.bz2 > ccache_cache.tar.bz2.base64.txt

base64_text=$(cat /tmp/ccache_cache.tar.bz2.base64.txt)

psql -U ${postgres_user} -d ${postgres_dbname} -h ${postgres_server} > /tmp/sql_result.txt << __HEREDOC__
INSERT INTO t_files (file_name, file_base64_text) VALUES ('ccache_cache.gcc.tar.bz2', '${base64_text}');
__HEREDOC__
