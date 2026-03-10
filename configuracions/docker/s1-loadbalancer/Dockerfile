FROM nginx:alpine

COPY nginx.conf /etc/nginx/nginx.conf
COPY extagram.crt /etc/nginx/ssl/extagram.crt
COPY extagram.key /etc/nginx/ssl/extagram.key

RUN mkdir -p /etc/nginx/ssl && \
    chmod 644 /etc/nginx/ssl/extagram.crt && \
    chmod 600 /etc/nginx/ssl/extagram.key

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
