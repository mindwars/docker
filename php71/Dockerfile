FROM php:7.1-fpm-alpine

RUN apk add --no-cache --update --virtual buildDeps bash libcurl curl curl-dev autoconf gcc make g++ zlib-dev libzip-dev postgresql-dev libxml2-dev libpng libpng-dev libjpeg-turbo-dev libwebp-dev zlib-dev libxpm-dev gd icu-dev libxslt libxslt-dev libmemcached libmemcached-dev

RUN docker-php-ext-install mbstring curl zip mysqli pdo pdo_pgsql pdo_mysql soap bcmath


RUN pecl install xdebug redis-4.0.1 mongodb
RUN apk del buildDeps

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
&& composer --version

ARG XDEBUG_HOST
ARG XDEBUG_PORT

RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
   && echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_connect_back=${XDEBUG_REMOTE_CONNECT_BACK}" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_handler = dbgp" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_mode = req" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_host=${XDEBUG_HOST}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
   echo "xdebug.remote_port=${XDEBUG_PORT}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
   
   
