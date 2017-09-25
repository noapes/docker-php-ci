FROM php:7-alpine

# For PDO MySQL
RUN docker-php-ext-install pdo pdo_mysql

# For ZipArchive
RUN apk add --no-cache --virtual zlib-dev
RUN docker-php-ext-install zip

# For GD
RUN apk add --no-cache --virtual .gd-deps \
                libwebp-dev \
                freetype-dev \
                libjpeg-turbo-dev \
                libpng-dev \
    && docker-php-ext-configure gd --with-jpeg-dir=/usr/include --with-png-dir=/usr/include --with-webp-dir=/usr/include --with-freetype-dir=/usr/include \
    && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) gd

# add a custom php.ini configuration
COPY config/php.ini /usr/local/etc/php

# add git
RUN apk add --no-cache --virtual git
