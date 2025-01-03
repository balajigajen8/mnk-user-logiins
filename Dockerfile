FROM php:8.1-fpm

# Set working directory
WORKDIR /var/www

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git \
    curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql gd

# Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Copy existing application directory contents
COPY . /var/www

# Set permissions for storage and cache
RUN chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Clear Composer cache
RUN composer clear-cache

# Install application dependencies
RUN composer install --no-interaction --prefer-dist --verbose

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
