FROM php:7-alpine

# For PDO MySQL
RUN docker-php-ext-install pdo pdo_mysql

# For ZipArchive
RUN apk add --no-cache --virtual zlib-dev
RUN docker-php-ext-install zip

# add a custom php.ini configuration
COPY config/php.ini /usr/local/etc/php

# add git
RUN apk add --no-cache --virtual git
