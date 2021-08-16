# PHP Farm Docker image
#

# use Debian as the host OS
FROM debian:jessie

LABEL author="uuware <uuware@gmail.com>"
LABEL maintainer="uuuware <uuware@gmail.com>"
LABEL description="Apache 2.4, PHP 5.3 5.6 7.0 7.4 8.0, MYSQL 5. And phpmyadmin, nodejs and python"

# ENV DEBIAN_FRONTEND noninteractive

ENV \
  # Packages needed for running various build scripts.
  SCRIPT_PKGS=" \
    debian-keyring \
    wget \
  " \
  # Packages only needed for PHP build.
  BUILD_PKGS=" \
    autoconf \
    build-essential \
    lemon \
    bison \
    pkg-config \
    re2c \
  " \
  # PHP runtime dependencies.
  RUNTIME_PKGS=" \
    # Needed for PHP and Git to connect with SSL sites.
    ca-certificates \
    curl \
    # unzip is used to run php composer
    unzip \
    # apt-get complains that this is an 'essential' package.
    debian-archive-keyring \
    imagemagick \
    libbz2-dev \
    libc-client2007e-dev \
    libcurl4-openssl-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg-dev \
    libkrb5-dev \
    libldap2-dev \
    libltdl-dev \
    libmcrypt-dev \
    libmhash-dev \
    libmysqlclient-dev \
    libonig-dev \
    libpng-dev \
    libpq-dev \
    libsasl2-dev \
    libsqlite3-dev \
    libssl-dev \
    libwebp-dev \
    libxml2-dev \
    libxpm-dev \
    libxslt1-dev \
    libzip-dev \
  " \
  # Packages needed to run Apache httpd.
  APACHE_PKGS="\
    apache2 \
    apache2-mpm-prefork \
    # Fcgid mod for Apache - not a build dependency library.
    libapache2-mod-fcgid \
  "

# Install packages we need for runtime usage.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    $RUNTIME_PKGS \
    $APACHE_PKGS



# Reconfigure Apache
RUN rm -rf /var/www/*
# Import our Apache configs.
COPY docker-phpfarm/apache /etc/apache2/

# Import our own modifications for the PhpFarm script.
COPY docker-phpfarm/phpfarm /phpfarm_mod

RUN echo 'Include php-all.conf' >> /etc/apache2/apache2.conf

# expose the ports
EXPOSE 8053 8054 8055 8056 8070 8071 8072 8073 8074 8080

# The PHP versions to compile. 8.0.0 seems not working
# ENV PHP_FARM_VERSIONS="5.3.29 5.4.45 5.5.38 5.6.40 7.0.33 7.1.33 7.2.34 7.3.28 7.4.22 8.0.9" \
ENV PHP_FARM_VERSIONS="5.3.29 5.6.40 7.0.33 7.4.22 8.0.9" \
  # must be one of PHP_FARM_VERSIONS and is used to run composer
  PHP_DEFAULT_PATH="5.6" \
  \
  # Flags for C Compiler Loader: make php 5.3 work again.
  LDFLAGS="-lssl -lcrypto -lstdc++" \
  \
  # Add path to built PHP executables, for module building and for Apache.
  PATH="/phpfarm/inst/bin/:$PATH"


# Install packages needed for build.
RUN apt-get update && \
  apt-get install -y --no-install-recommends $SCRIPT_PKGS $BUILD_PKGS && \
  \
  # Download PhpFarm scripts into /phpfarm/.
  wget -O /phpfarm.tar.gz https://github.com/fpoirotte/phpfarm/archive/v0.3.0.tar.gz && \
  mkdir /phpfarm && \
  tar -xf /phpfarm.tar.gz -C /phpfarm --strip 1 && \
  #
  # Overwrite PhpFarm with our own modifications.
  rm -rf /phpfarm/src/bzips /phpfarm/src/custom && \
  mv /phpfarm_mod/* /phpfarm/src/ && \
  #
  # Wait for docker.sh to finish moving else trying to exec a file being
  # written will output "Text file busy" error.
  sleep 5s && \
  rmdir /phpfarm_mod && \
  #
  # Build all PHP versions.
  cd /phpfarm/src && \
  ./docker.sh && \
  #
  # Clean up.
  apt-get purge -y $SCRIPT_PKGS $BUILD_PKGS && \
  apt-get clean -y && apt-get autoclean -y && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/* /var/lib/log/* /tmp/* /var/tmp/*


# Install composer and phpmyadmin
RUN cd /tmp && \
    rm -f /usr/bin/php /usr/bin/php-cgi /usr/bin/phpdbg && \
    ln -s /phpfarm/inst/php-$PHP_DEFAULT_PATH/bin/php /usr/bin/php && \
    ln -s /phpfarm/inst/php-$PHP_DEFAULT_PATH/bin/php-cgi /usr/bin/php-cgi && \
    ln -s /phpfarm/inst/php-$PHP_DEFAULT_PATH/bin/phpdbg /usr/bin/phpdbg
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer 
RUN php /usr/bin/composer create-project phpmyadmin/phpmyadmin /var/phpmyadmin
VOLUME /var/phpmyadmin



# MySQL
# pass password from dock-compose.yml
ARG MYSQL_ROOT_PASSWORD=MysqlPassword123
ENV MYSQL_ROOT_PASSWORD ${MYSQL_ROOT_PASSWORD}
# # for mysql-server 5.5
RUN echo "mysql-server mysql-server/root_password password ${MYSQL_ROOT_PASSWORD}" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password ${MYSQL_ROOT_PASSWORD}" | debconf-set-selections

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r mysql && useradd -r -g mysql mysql

# can install 5.7 like this, but had some problems to start
#   php-cgi: error while loading shared libraries: libmysqlclient.so.18: cannot open shared object file: No such file or directory
# # add this to install mysql 5.7.30 (otherwise it'll install mysql 5.5.62)
# RUN echo "deb http://repo.mysql.com/apt/debian/ jessie mysql-5.7" > /etc/apt/sources.list.d/mysql.list
# # for mysql-community-server 5.7
# RUN echo "mysql-community-server mysql-community-server/root-pass password ${MYSQL_ROOT_PASSWORD}" | debconf-set-selections
# RUN echo "mysql-community-server mysql-community-server/re-root-pass password ${MYSQL_ROOT_PASSWORD}" | debconf-set-selections

# Install MySQL
# All configuration files (like my.cnf) are under /etc/mysql
# The data directory is under /var/lib/mysql and can be mounted to outside folder
RUN apt-get update && apt-get install -y --force-yes mysql-server && rm -rf /var/lib/apt/lists/* \
	&& mkdir -p /var/lib/mysql /var/run/mysqld /var/log/mysql \
	&& chown -R mysql:mysql /var/lib/mysql /var/run/mysqld /var/log/mysql \
	&& chmod -R 777 /var/run/mysqld /var/lib/mysql /var/log/mysql \
  && rm -rf /var/log/mysql/*

# start Mysql
COPY docker-phpfarm/mysql-entrypoint.sh /mysql-entrypoint.sh
RUN chmod a+x /mysql-entrypoint.sh

VOLUME /var/lib/mysql
EXPOSE 3306




# install node
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash && \
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")" && \
    . "$NVM_DIR/nvm.sh" && \
    nvm install --lts && \
    # use node with bash
   ln -s /root/.nvm/versions/node/v14.17.5/bin/node /usr/bin/node

# # install Python 3.9.2
# RUN echo 'deb http://ftp.de.debian.org/debian jessie main' >> /etc/apt/sources.list
# RUN echo 'deb http://security.debian.org/debian-security jessie/updates main ' >> /etc/apt/sources.list
# RUN echo 'deb http://ftp.de.debian.org/debian sid main' >> /etc/apt/sources.list
# RUN apt-get -y install python3 python3-distutils

# install python 3.4.2, use python3 --version to confirm
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3




# Clean up apt package lists.
RUN apt-get purge -y $SCRIPT_PKGS $BUILD_PKGS && \
    apt-get clean -y && apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /var/lib/log/* /tmp/* /var/tmp/*



# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.7
RUN set -x \
    && apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    # && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    # && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && apt-get purge -y --auto-remove ca-certificates wget


# if the file /var/init/init.sh exists, then run it to initilize some processes when start docker
# like to copy my.cnf to /etc/mysql or modify apache2's configration
RUN mkdir /var/init
VOLUME /var/init

# run it
VOLUME /var/www
WORKDIR /var/www
COPY docker-phpfarm/entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]

