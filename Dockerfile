FROM php:8.2-fpm

RUN apt-get update && apt-get install -y     libzip-dev git curl libpng-dev libonig-dev libxml2-dev zip     mariadb-client openssl     libfreetype-dev libjpeg-dev     && docker-php-ext-configure gd --with-freetype --with-jpeg     && docker-php-ext-install pdo pdo_mysql zip mbstring exif pcntl bcmath gd

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html
COPY /src /var/www/html

COPY ./docker/init.sh /init.sh
RUN chmod +x /init.sh
CMD ["/init.sh"]
