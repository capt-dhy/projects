FROM richarvey/nginx-php-fpm:latest
COPY . .
ENV WEBROOT /var/www/html/public
ENV RUN_SCRIPTS 1
CMD ["/start.sh"]
