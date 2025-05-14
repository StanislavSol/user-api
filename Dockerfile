# Используем официальный образ PHP с Apache
FROM php:8.2-apache

# Устанавливаем зависимости
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    && docker-php-ext-install \
    pdo_mysql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd \
    zip

# Устанавливаем Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Копируем файлы проекта
COPY . /var/www/html

# Устанавливаем права
RUN chown -R www-data:www-data /var/www/html \
    && a2enmod rewrite

# Устанавливаем зависимости Laravel
RUN composer install --no-dev --optimize-autoloader

# Копируем .env.production в .env (для Render)
COPY .env.production .env

# Генерируем ключ приложения
RUN php artisan key:generate

# Оптимизируем загрузку
RUN php artisan optimize

# Указываем рабочую директорию
WORKDIR /var/www/html

# Порт, который будет слушать Apache
EXPOSE 80

# Команда для запуска Apache
CMD ["apache2-foreground"]
