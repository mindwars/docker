FROM debian:latest
LABEL maintainer="hakanbysl@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

# Update and install openssh-server, Docker, Go, PHP 7.4, Java, JDK, Nginx, Node.js, Git, net-tools, htop, telnet, lsof, maven, nano, vim, screen
RUN apt-get update && apt-get install -y openssh-server \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    golang-go \
    default-jdk \
    nginx \
    nodejs \
    npm \
    git \
    net-tools \
    htop \
    telnet \
    lsof \
    maven \
    nano \
    vim \
    screen \
    wget \
    cron \
    rsync

RUN apt-get update && apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y && apt-get install ca-certificates curl gnupg lsb-release && mkdir -p /etc/apt/keyrings && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && apt-get update && chmod a+r /etc/apt/keyrings/docker.gpg && apt-get update && apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y && apt-get install docker-compose -y && docker --version && docker-compose --version

RUN wget https://gist.githubusercontent.com/onuragtas/74f8351c4496598badbd9399814a44a5/raw/ci.sh -O /usr/local/bin/ci.sh
RUN chmod +x /usr/local/bin/ci.sh

RUN wget https://github.com/onuragtas/redock/releases/latest/download/redock_Linux_amd64 -O /usr/local/redock
RUN chmod +x /usr/local/redock
RUN echo "/usr/local/redock --devenv" >> /usr/local/bin/redock
RUN chmod +x /usr/local/bin/redock

RUN wget https://gist.githubusercontent.com/onuragtas/c6dddddd6a8e6b8663f4f0043fec052a/raw/eedfc5500af08a04099ad4eb51b5142c996db7fc/go-compiler.sh -O /usr/local/bin/go-compiler.sh -F
RUN chmod +x /usr/local/bin/go-compiler.sh

RUN echo "docker -H 192.168.36.240:4243 exec -it -w /var/www/html/\$(cat /root/.username)/\$(basename "\$PWD") php81_xdebug \$@" >> /usr/local/bin/php81_container && chmod +x /usr/local/bin/php81_container
RUN echo "docker -H 192.168.36.240:4243 exec -it -w /var/www/html/\$(cat /root/.username)/\$(basename "\$PWD") php74_xdebug \$@" >> /usr/local/bin/php74_container && chmod +x /usr/local/bin/php74_container
RUN echo "docker -H 192.168.36.240:4243 exec -it -w /var/www/html/\$(cat /root/.username)/\$(basename "\$PWD") php72_xdebug \$@" >> /usr/local/bin/php72_container && chmod +x /usr/local/bin/php72_container
RUN echo "docker -H 192.168.36.240:4243 exec -it -w /var/www/html/\$(cat /root/.username)/\$(basename "\$PWD") php56_xdebug \$@" >> /usr/local/bin/php56_container && chmod +x /usr/local/bin/php56_container
RUN echo "docker -H 192.168.36.240:4243 exec -it postgres \$@" >> /usr/local/bin/postgres_container && chmod +x /usr/local/bin/postgres_container
RUN echo "docker -H 192.168.36.240:4243 exec -it mongo \$@" >> /usr/local/bin/mongo_container && chmod +x /usr/local/bin/mongo_container
RUN echo "docker -H 192.168.36.240:4243 exec -it db \$@" >> /usr/local/bin/mysql_container && chmod +x /usr/local/bin/mysql_container
RUN echo "docker -H 192.168.36.240:4243 exec -it nginx \$@" >> /usr/local/bin/nginx_container && chmod +x /usr/local/bin/nginx_container

ENV PASSWORD=password

RUN sed -i 's/#PermitRootLogin.*/PermitRootLogin\ yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication.*/PasswordAuthentication\ yes/' /etc/ssh/sshd_config

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
RUN export NVM_DIR="$HOME/.nvm"
RUN . $HOME/.nvm/nvm.sh

EXPOSE 22 80 443 8090 9000 9001 9002 9003 9004 9005 9006 9007 9008 9010

RUN mkdir /sites
WORKDIR /sites

CMD ["/usr/sbin/sshd", "-D"]
ENTRYPOINT echo "root:${PASSWORD}" | chpasswd && service ssh restart && cron && cd /sites && bash && dockerd