FROM nginx:alpine

# Copiar configuración de NGINX
COPY nginx.conf /etc/nginx/nginx.conf

# Copiar archivos estáticos
COPY style.css /var/www/html/style.css
COPY preview.svg /var/www/html/preview.svg

# Asegurar permisos
RUN chown -R nginx:nginx /var/www/html

# Exponer puerto
EXPOSE 80

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
