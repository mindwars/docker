FROM php:8.1.11RC1-fpm

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        inetutils-ping \
        libpng-dev \
        zlib1g-dev \
        libicu-dev \
        libonig-dev \
        g++ \
        unixodbc-dev \
        libxml2-dev \
        libzip-dev \
        libaio-dev \
        libmemcached-dev \
        freetds-dev \
        libyaml-dev \
        libssl-dev \
        openssl \
        libcurl4-gnutls-dev \
        libpq-dev

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
&& composer --version

RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql

RUN  pecl install redis \
    && pecl install memcached \
    && pecl install mongodb \
    && pecl install yaml \
    && docker-php-ext-install \
	    curl \
            iconv \
            mbstring \
            intl \
            gd \
            exif \
            mysqli \
            pdo_mysql \
            pdo_pgsql \
            pgsql \
            soap \
            sockets \
            zip \
            pcntl \
            ftp \
            bcmath \
    && docker-php-ext-enable \
            redis \
            memcached \
            opcache \
            mongodb

RUN docker-php-ext-install bcmath

RUN echo "extension=yaml.so" > /usr/local/etc/php/conf.d/yaml.ini

ADD crontab /etc/cron.d/hello-cron
RUN chmod 0644 /etc/cron.d/hello-cron
RUN touch /var/log/cron.log
RUN apt-get update
RUN apt-get -y install cron

RUN apt-get install -y git
RUN apt-get install -y --reinstall procps

CMD cron & php-fpm