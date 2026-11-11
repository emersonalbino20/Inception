FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    mariadb-server \
    mariadb-client \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/mysqld \
 && chown -R mysql:mysql /var/run/mysqld \
 && chmod 755 /var/run/mysqld

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tool/init.sh /usr/local/bin/init.sh

RUN chmod +x /usr/local/bin/init.sh

ENV MYSQL_ROOT_PASSWORD_FILE=root \
    MYSQL_DATABASE=app_db \
    MYSQL_USER=app_user \
    MYSQL_PASSWORD_FILE=app_pass

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/init.sh"]
