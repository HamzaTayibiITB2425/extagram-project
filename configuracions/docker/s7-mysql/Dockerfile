FROM mysql:8.0

COPY init.sql /docker-entrypoint-initdb.d/01-init.sql
COPY hardening.sql /docker-entrypoint-initdb.d/02-hardening.sql

EXPOSE 3306

RUN chown -R mysql:mysql /docker-entrypoint-initdb.d/
