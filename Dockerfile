# STAGE 1: build
FROM composer:2 AS build

WORKDIR /app

COPY composer.json composer.lock ./
RUN composer install --no-dev --no-scripts --no-autoloader --no-interaction --prefer-dist

COPY . .
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist


# STAGE 2: runtime
FROM php:8.3-fpm-alpine

WORKDIR /var/www/html

RUN apk add --no-cache \
    bash \
    shadow \
    libpq \
    postgresql-dev \
    libzip-dev

# Habilitar extensões do PHP
RUN docker-php-ext-install pdo pdo_pgsql

COPY --from=build /app /var/www/html

RUN chown -R www-data:www-data /var/www/html

EXPOSE 9000
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]


