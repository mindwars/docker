FROM php:7.0-fpm-alpine

RUN apk add --no-cache --update --virtual buildDeps bash libcurl curl curl-dev autoconf gcc make g++ zlib-dev libzip-dev postgresql-dev libxml2-dev libpng libpng-dev libjpeg-turbo-dev libwebp-dev zlib-dev libxpm-dev gd icu-dev libxslt libxslt-dev libmemcached libmemcached-dev

RUN docker-php-ext-install mbstring curl zip mysqli pdo pdo_pgsql pdo_mysql soap bcmath


RUN pecl install redis-4.0.1 mongodb
RUN apk del buildDeps

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
&& composer --version
