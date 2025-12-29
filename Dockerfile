# Base image: PHP 8.2 FPM (Debian-based)
FROM php:8.2-fpm

# Switch to root to install dependencies
USER root

# Install system dependencies for Laravel + MySQL
RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
    git \
    curl \
    && docker-php-ext-install pdo pdo_mysql

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy project files
COPY . .

# Copy start.sh and make it executable
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Set environment variables for Laravel webroot
ENV WEBROOT=/var/www/html/public
ENV RUN_SCRIPTS=1

# Expose port (Laravel will use $PORT from Render)
EXPOSE 80

# Start Laravel using start.sh
CMD ["/start.sh"]
