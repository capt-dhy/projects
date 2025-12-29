FROM richarvey/nginx-php-fpm:latest

# Switch to root to install dependencies
USER root
RUN apt-get update && apt-get install -y libzip-dev unzip git \
    && docker-php-ext-install pdo pdo_mysql

# Copy Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy project files
COPY . .

# Copy start.sh and make executable
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Set webroot
ENV WEBROOT /var/www/html/public
ENV RUN_SCRIPTS 1

# Start script
CMD ["/start.sh"]
