FROM nginx:alpine
COPY nginx.conf /etc/nginx/nginx.conf
COPY style.css /var/www/html/style.css
COPY favicon.svg /var/www/html/favicon.ico
RUN mkdir -p /var/www/html && chown -R nginx:nginx /var/www/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
