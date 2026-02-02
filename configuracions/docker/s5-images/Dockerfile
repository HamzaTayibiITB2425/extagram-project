FROM nginx:alpine
COPY nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /var/www/html/uploads
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
