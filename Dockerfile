FROM php:7.1-alpine

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
# add php-openssl extension
#RUN apk add --no-cache --virtual 
# add php-mongodb extension
RUN apk add --no-cache --virtual php7-mongodb
# add zookeeper
RUN apk add --no-cache --virtual alpine-sdk
RUN apk add --no-cache --virtual autoconf

ENV ZOOKEEPER_VERSION="3.4.12"
ENV ZOOKEEPER_PHP_EXT_VERSION="0.5.0"

RUN curl https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/zookeeper-$ZOOKEEPER_VERSION/zookeeper-$ZOOKEEPER_VERSION.tar.gz | tar xvz -C /tmp \
    && curl https://pecl.php.net/get/zookeeper-$ZOOKEEPER_PHP_EXT_VERSION.tgz | tar xvz -C /tmp

RUN cd /tmp/zookeeper-3.4.12/src/c \
    && ./configure && make && make install \
    && cd /tmp/zookeeper-0.5.0 \
    && phpize && ./configure --with-php-config=$(which php-config) --with-libzookeeper-dir=/usr/local && make && make install
