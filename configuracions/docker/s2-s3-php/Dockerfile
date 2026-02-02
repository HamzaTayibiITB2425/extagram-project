FROM php:8.2-fpm-alpine
RUN docker-php-ext-install mysqli pdo pdo_mysql
# Instalar dependencias LDAP
RUN apk add --no-cache ldb-dev libldap openldap-dev     && docker-php-ext-install ldap
WORKDIR /var/www/html
