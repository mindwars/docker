FROM php:5.6-fpm

ENV COMPOSER_HOME=/root/.composer

RUN apt-get update \
    && apt-get install -q -y  --force-yes --no-install-recommends nano curl git wget zip unzip libpq-dev

RUN apt-get install -y --force-yes libmemcached11 libmemcachedutil2 build-essential libmemcached-dev libz-dev \
    && pecl install memcached-2.2.0 \
    && echo extension=memcached.so >> /usr/local/etc/php/conf.d/memcached.ini

RUN apt-get install -y --force-yes \
        libssl-dev libxslt1-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        zlib1g-dev libicu-dev g++ \
        && docker-php-ext-configure intl && docker-php-ext-install intl \
    && docker-php-ext-install  iconv mcrypt ftp \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install  gd

RUN docker-php-ext-install exif gd mbstring intl xsl zip mysql mysqli pdo pdo_pgsql pdo_mysql soap bcmath sockets

RUN pecl install mongodb-1.4.1 && echo "extension=mongodb.so" >> /usr/local/etc/php/conf.d/mongodb.ini
RUN pecl install mongo-1.6.6 && echo "extension=mongo.so" >> /usr/local/etc/php/conf.d/mongo.ini

RUN mkdir -p $COMPOSER_HOME \
&& curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
&& composer --version

RUN apt-get install -y --reinstall procps

ADD crontab /etc/cron.d/hello-cron
RUN chmod 0644 /etc/cron.d/hello-cron
RUN touch /var/log/cron.log
RUN apt-get update
RUN apt-get -y --force-yes install cron

CMD cron & php-fpm
