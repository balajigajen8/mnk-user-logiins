# Base PHP image with FPM
FROM php:8.2-fpm

# Install required system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git \
    curl \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql mbstring zip gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Composer globally
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy the application code
COPY . /var/www

# Set permissions for storage and bootstrap/cache
RUN chmod -R 775 storage bootstrap/cache && \
    chown -R www-data:www-data storage bootstrap/cache

# Install Laravel dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Expose the application port
EXPOSE 8000

# Start the Laravel application server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
