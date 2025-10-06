# बेस इमेज PHP 8.1 FPM का उपयोग करें
FROM php:8.1-fpm

# आवश्यक एक्सटेंशन्स इन्स्टॉल करें
RUN apt-get update && apt-get install -y \
    libonig-dev \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo mbstring zip exif pcntl bcmath gd

# Composer इंस्टॉल करें (यदि पहले से नहीं है)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# वर्कडायरेक्ट्री सेट करें
WORKDIR /var/www/html

# कोड कॉपी करें
COPY . .

# Composer डिपेंडेंसीज इंस्टॉल करें
RUN composer install --no-interaction --optimize-autoloader --no-dev

# अधिकार सेट करें (Laravel के लिए जरूरी)
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# पोर्ट एक्सपोज करें (यदि आवश्यक)
EXPOSE 9000

# PHP-FPM सर्वर शुरू करें
CMD ["php-fpm"]
