FROM php:7.1

# For PDO MySQL
RUN docker-php-ext-install pdo pdo_mysql

# For ZipArchive
RUN apt-get update && apt-get -y install \
		libzip-dev
 
RUN docker-php-ext-install zip

# For GD
RUN  apt-get -y install  \
                libwebp-dev \
                libfreetype6-dev \
                libjpeg62-turbo-dev \
		libpng-dev \
    	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    	&& docker-php-ext-install -j$(nproc) gd

# add a custom php.ini configuration
COPY config/php.ini /usr/local/etc/php

# add git
RUN apt-get -y install  git
# add php-openssl extension
# add mongodb 
RUN apt-get -y install libbson-dev \
		libmongoc-dev \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb
