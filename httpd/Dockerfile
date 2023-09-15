FROM ubuntu:latest
LABEL maintainer="Sinan Turgut <mail@sinanturgut.com.tr>"

RUN apt-get update && apt-get install -y --force-yes nano unzip wget curl

RUN apt-get update && apt-get install -y --force-yes apache2 && apt-get clean

RUN a2enmod proxy_http && a2enmod rewrite && a2enmod proxy_fcgi && a2enmod headers


EXPOSE 80
ENTRYPOINT ["/usr/sbin/apache2ctl"]
CMD ["-D", "FOREGROUND"]
