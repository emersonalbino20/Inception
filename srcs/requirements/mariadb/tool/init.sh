#!/bin/bash

set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null
fi

mysqld --skip-networking --socket=/run/mysqld/mysqld.sock --user=mysql &
pid="$!"

until mysqladmin --socket=/run/mysqld/mysqld.sock ping >/dev/null 2>&1; do
    sleep 1
done

DB_ROOT_PWD=$(cat "${MYSQL_ROOT_PASSWORD_FILE}")
DB_USER_PWD=$(cat "${MYSQL_PASSWORD_FILE}")

mysql --socket=/run/mysqld/mysqld.sock -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PWD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_USER_PWD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

mysqladmin --socket=/run/mysqld/mysqld.sock -u root -p"${DB_ROOT_PWD}" shutdown

wait "$pid" || true

exec mysqld --user=mysql --datadir=/var/lib/mysql --socket=/run/mysqld/mysqld.sock
