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
	libcurl4-gnutls-dev

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
&& composer --version


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
            soap \
            sockets \
            zip \
            pcntl \
            ftp \
    && docker-php-ext-enable \
            redis \
            memcached \
            opcache \
            mongodb


RUN pecl install xdebug-3.2.0alpha3
RUN docker-php-ext-enable xdebug

RUN docker-php-ext-install bcmath

RUN echo "extension=yaml.so" > /usr/local/etc/php/conf.d/yaml.ini

ADD crontab /etc/cron.d/hello-cron
RUN chmod 0644 /etc/cron.d/hello-cron
RUN touch /var/log/cron.log
RUN apt-get update
RUN apt-get -y install cron

RUN apt-get install -y git

ENV PHALCON_VERSION=3.4.0
RUN curl -sSL "https://codeload.github.com/phalcon/cphalcon/tar.gz/v${PHALCON_VERSION}" | tar -xz \
    && cd cphalcon-${PHALCON_VERSION}/build \
    && ./install \
    && cp ../tests/_ci/phalcon.ini $(php-config --configure-options | grep -o "with-config-file-scan-dir=\([^ ]*\)" | awk -F'=' '{print $2}') \
    && cd ../../ \
    && rm -r cphalcon-${PHALCON_VERSION}

RUN apt-get install -y --reinstall procps

ARG XDEBUG_HOST
ARG XDEBUG_PORT

RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
   && echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_connect_back=${XDEBUG_REMOTE_CONNECT_BACK}" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_handler = dbgp" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_mode = req" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_host=$XDEBUG_HOST" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_port=$XDEBUG_PORT" >> /usr/local/etc/php/conf.d/xdebug.ini

CMD cron & php-fpm