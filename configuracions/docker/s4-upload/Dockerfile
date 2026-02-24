FROM php:8.2-fpm-alpine

# Instalar extensiones MySQL
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Copiar archivos PHP
COPY upload.php /var/www/html/
COPY delete.php /var/www/html/
COPY recover.php /var/www/html/

# Crear directorio uploads y dar permisos a www-data
RUN mkdir -p /var/www/html/uploads && \
    chown -R www-data:www-data /var/www/html/uploads && \
    chmod -R 755 /var/www/html/uploads

# Cambiar al usuario www-data
USER www-data

EXPOSE 9000

CMD ["php-fpm"]
