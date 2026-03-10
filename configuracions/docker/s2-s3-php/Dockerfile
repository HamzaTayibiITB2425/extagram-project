FROM php:8.2-fpm-alpine

RUN docker-php-ext-install mysqli pdo pdo_mysql

# Instalar dependencias LDAP (SIN ldb-dev)
RUN apk add --no-cache libldap openldap-dev \
    && docker-php-ext-install ldap

WORKDIR /var/www/html

EXPOSE 9000

CMD ["php-fpm"]
