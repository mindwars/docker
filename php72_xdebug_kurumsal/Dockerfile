FROM php:7.2-fpm
ENV PHALCON_VERSION=3.4.0
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        inetutils-ping \
        libpng-dev \
        zlib1g-dev \
        libicu-dev \
        g++ \
        unixodbc-dev \
        libxml2-dev \
        libaio-dev \
        libmemcached-dev \
        freetds-dev \
        libyaml-dev \
    libssl-dev \
    openssl \
    libcurl4-gnutls-dev
RUN curl -sSL "https://codeload.github.com/phalcon/cphalcon/tar.gz/v${PHALCON_VERSION}" | tar -xz \
    && cd cphalcon-${PHALCON_VERSION}/build \
    && ./install \
    && cp ../tests/_ci/phalcon.ini $(php-config --configure-options | grep -o "with-config-file-scan-dir=\([^ ]*\)" | awk -F'=' '{print $2}') \
    && cd ../../ \
    && rm -r cphalcon-${PHALCON_VERSION}
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
&& composer --version
RUN apt-get install -y supervisor
RUN docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/freetype2 \
        --with-png-dir=/usr/include \
        --with-jpeg-dir=/usr/include \
   # && pecl install shmop \
    && pecl install sqlsrv-4.1.6.1 \
    && pecl install pdo_sqlsrv-4.1.6.1 \
    && pecl install redis \
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
            shmop \
    && docker-php-ext-enable \
            sqlsrv \
            pdo_sqlsrv \
            redis \
            memcached \
            opcache \
            mongodb
RUN docker-php-ext-install fileinfo
RUN pecl install xdebug-2.9.8
RUN docker-php-ext-enable xdebug
RUN docker-php-ext-install bcmath
ARG XDEBUG_HOST
ARG XDEBUG_PORT
RUN apt-get install -y git

RUN apt-get install -y --reinstall procps

RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
   && echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_handler = dbgp" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_mode = req" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_host=$XDEBUG_HOST" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_port=$XDEBUG_PORT" >> /usr/local/etc/php/conf.d/xdebug.ini && \
   cd /usr/local/etc/php/conf.d/ && \
   echo 'memory_limit = -1' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini
RUN echo "extension=yaml.so" > /usr/local/etc/php/conf.d/yaml.ini
ADD crontab /etc/cron.d/hello-cron
RUN chmod 0644 /etc/cron.d/hello-cron
RUN touch /var/log/cron.log
RUN apt-get update

RUN apt-get -y install cron

CMD cron & php-fpm

