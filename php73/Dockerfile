FROM php:7.3-fpm

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
	libcurl4-gnutls-dev \
	libpq-dev

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
&& composer --version


RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
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
            soap


RUN docker-php-ext-install bcmath

RUN echo "extension=yaml.so" > /usr/local/etc/php/conf.d/yaml.ini

ENV PHALCON_VERSION=3.2.4

RUN curl -sSL "https://codeload.github.com/phalcon/cphalcon/tar.gz/v${PHALCON_VERSION}" | tar -xz \
    && cd cphalcon-${PHALCON_VERSION}/build \
    && ./install \
    && cp ../tests/_ci/phalcon.ini $(php-config --configure-options | grep -o "with-config-file-scan-dir=\([^ ]*\)" | awk -F'=' '{print $2}') \
    && cd ../../ \
    && rm -r cphalcon-${PHALCON_VERSION}

RUN apt-get install -y --reinstall procps

ADD crontab /etc/cron.d/hello-cron
RUN chmod 0644 /etc/cron.d/hello-cron
RUN touch /var/log/cron.log
RUN apt-get update
RUN apt-get -y install cron
RUN apt-get install -y git

CMD cron & php-fpm

