# docker image with PHP, MYSQL, phpmyadmin, nodejs, python
FROM alpine:3.8
LABEL author="uuware <uuware@gmail.com>"
LABEL maintainer="uuuware <uuware@gmail.com>"
LABEL description="Apache 2.4, PHP 5.6, 7.2, MYSQL 5.7. And phpmyadmin, nodejs and python"

# set time zone
ARG TIME_ZONE='Pacific/Auckland'
ENV DEFAULT_TZ ${TIME_ZONE}
RUN apk add --update --no-cache tzdata && \
    cp /usr/share/zoneinfo/${DEFAULT_TZ} /etc/localtime && \
    apk del tzdata

RUN apk add --no-cache zip unzip curl bash \
    # git openssl ffmpeg wget \
    apache2 \
    apache-mod-fcgid \
    imagemagick-dev \
    apache2-utils



# Install php5.6
RUN apk add --update --no-cache \
    # curl-dev \
    php5-sqlite3 \
    php5-mysql \
    php5-mysqli \
    php5-pgsql \
    php5-odbc \
    php5-pdo \
    php5-pdo_mysql \
    php5-pdo_pgsql \
    php5-pdo_dblib \
    php5-pdo_odbc \
    php5-pdo_sqlite \
    php5-intl \
    php5-openssl \
    php5-dba \
    php5-pear \
    php5-phpdbg \
    php5-gmp \
    php5-pcntl \
    php5-common \
    php5-xsl \
    php5-fpm \	
    php5-enchant \
    php5-pspell \
    php5-snmp \
    php5-doc \
    php5-dev \
    php5-xmlrpc \
    php5-embed \
    php5-xmlreader \
    php5-exif \
    php5-opcache \
    php5-ldap \
    php5-posix \	
    php5-gd  \
    php5-gettext \
    php5-json \
    php5-xml \
    php5 \
    php5-iconv \
    php5-sysvshm \
    php5-curl \
    php5-shmop \
    # can only install php5 or php7 phar
    php5-phar \
    php5-imap \
    #php5-xdebug \
    php5-zip \
    php5-apache2 \
    php5-cgi \
    php5-ctype \
    php5-mcrypt \
    php5-wddx \
    php5-bcmath \
    php5-calendar \
    php5-dom \
    php5-sockets \
    php5-soap \
    php5-apcu \
    php5-sysvmsg \
    php5-zlib \
    php5-ftp \
    php5-sysvsem \ 
    php5-bz2 \
    libxml2-dev


RUN sed -E -i -e 's/max_execution_time = 30/max_execution_time = 180/' /etc/php5/php.ini && \
  sed -E -i -e 's/max_input_time = 60/max_input_time = 180/' /etc/php5/php.ini && \
  # sed -E -i -e 's/memory_limit = 128M/memory_limit = 512M/' /etc/php5/php.ini && \
  sed -E -i -e 's/post_max_size = 8M/post_max_size = 50M/' /etc/php5/php.ini && \
  sed -E -i -e 's/upload_max_filesize = 2M/upload_max_filesize = 50M/' /etc/php5/php.ini

RUN  rm -rf /var/cache/apk/*

# AllowOverride ALL
RUN sed -i '264s#AllowOverride None#AllowOverride All#' /etc/apache2/httpd.conf
#Rewrite Moduble Enable
RUN sed -i 's#\#LoadModule rewrite_module modules/mod_rewrite.so#LoadModule rewrite_module modules/mod_rewrite.so#' /etc/apache2/httpd.conf
# Document Root to /var/www//html
RUN sed -i 's#/var/www/localhost/htdocs#/var/www/html#g' /etc/apache2/httpd.conf
#Start apache
RUN mkdir -p /run/apache2

COPY php-5.6.conf /etc/apache2/conf.d/
RUN { \
    echo '# global FCGI config'; \
    echo 'FcgidFixPathinfo 1'; \
    echo '<IfModule dir_module>'; \
    echo '  DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm'; \
    echo '</IfModule>'; \
    echo '# mod_fcgid mode, set request len to 50M'; \
    echo 'MaxRequestLen 51200000'; \
    } > /etc/apache2/conf.d/phpfarm.conf


RUN mkdir -p /var/www/html

VOLUME  /var/www/html
WORKDIR  /var/www/html

EXPOSE 8056
EXPOSE 80
EXPOSE 443



# Install PHP 7
# # # this can install 7.4 on alpine:3.12
# ADD https://packages.whatwedo.ch/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub

# RUN apk --update-cache add ca-certificates && \
#     echo "https://packages.whatwedo.ch/php-alpine/v3.12/php-7.4" >> /etc/apk/repositories
# # Or add this
#  --repository=https://packages.whatwedo.ch/php-alpine/v3.12/php-7.4

RUN apk add --no-cache php7 \
    php7-common \
    php7-fpm \
    php7-sqlite3 \
    # php7-mysql \
    php7-mysqli \
    php7-mysqlnd \
    php7-pgsql \
    php7-odbc \
    php7-pdo \
    php7-pdo_mysql \
    php7-pdo_sqlite \
    php7-pdo_pgsql \
    php7-opcache \
    php7-zip \
    php7-cgi \
    php7-gd \
    php7-mcrypt \
    # php7-phar \
    php7-iconv \
    php7-cli \
    php7-curl \
    php7-openssl \
    php7-mbstring \
    php7-tokenizer \
    php7-fileinfo \
    php7-json \
    php7-xml \
    # php7-xdebug \
    php7-xmlwriter \
    php7-xmlreader \
    php7-simplexml \
    php7-dom \
    php7-session \
    libxml2-dev \
    php7-tokenizer
    # php-pecl-redis


RUN sed -E -i -e 's/max_execution_time = 30/max_execution_time = 180/' /etc/php7/php.ini && \
  sed -E -i -e 's/max_input_time = 60/max_input_time = 180/' /etc/php7/php.ini && \
  # sed -E -i -e 's/memory_limit = 128M/memory_limit = 512M/' /etc/php7/php.ini && \
  sed -E -i -e 's/post_max_size = 8M/post_max_size = 50M/' /etc/php7/php.ini && \
  sed -E -i -e 's/upload_max_filesize = 2M/upload_max_filesize = 50M/' /etc/php7/php.ini


RUN  rm -rf /var/cache/apk/*

COPY php-7.2.conf /etc/apache2/conf.d/
EXPOSE 8074




# this increases 150M size
# install Mysql, Server version: 10.2.32-MariaDB - MariaDB Server
# pass password from dock-compose.yml
ARG MYSQL_ROOT_PASSWORD=MysqlPassword123
ARG MYSQL_DATABASE=
ARG MYSQL_USER=
ARG MYSQL_PASSWORD=
ENV MYSQL_ROOT_PASSWORD ${MYSQL_ROOT_PASSWORD}
ENV MYSQL_DATABASE ${MYSQL_DATABASE}
ENV MYSQL_USER ${MYSQL_USER}
ENV MYSQL_PASSWORD ${MYSQL_PASSWORD}
# ENV TIMEZONE Pacific/Auckland

# install Mysql
COPY mysql-entrypoint.sh /mysql-entrypoint.sh
RUN chmod a+x /mysql-entrypoint.sh

RUN \
    apk --no-cache add bash pwgen su-exec tzdata \
    mysql \
    mysql-client \
    && mkdir -p /run/mysqld && chmod 777 /run/mysqld

VOLUME [ "/var/lib/mysql" ]
EXPOSE 3306



# this increases 250M size
# Install composer and phpmyadmin
RUN cd /tmp && \
    rm -f /usr/bin/php /usr/bin/php-cgi /usr/bin/phpdbg && \
    ln -s /usr/bin/php5 /usr/bin/php && \
    ln -s /usr/bin/php-cgi5 /usr/bin/php-cgi && \
    ln -s /usr/bin/phpdbg5 /usr/bin/phpdbg
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer 
RUN php /usr/bin/composer create-project phpmyadmin/phpmyadmin /var/phpmyadmin
VOLUME /var/phpmyadmin


# this increases 35M size
# install python
RUN apk add --no-cache python

# this increases 110M size
# # install node
ENV NODE_VERSION 14.17.4
RUN addgroup -g 1000 node \
    && adduser -u 1000 -G node -s /bin/sh -D node \
    && apk add --no-cache \
        libstdc++ \
    && apk add --no-cache --virtual .build-deps \
        curl \
    && ARCH= && alpineArch="$(apk --print-arch)" \
      && case "${alpineArch##*-}" in \
        x86_64) \
          ARCH='x64' \
          CHECKSUM="78f4b05466f4bc9e33e62e912724fc835f476cd2ae89fb909fd9eac64484e40a" \
          ;; \
        *) ;; \
      esac \
  && if [ -n "${CHECKSUM}" ]; then \
    set -eu; \
    curl -fsSLO --compressed "https://unofficial-builds.nodejs.org/download/release/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz"; \
    echo "$CHECKSUM  node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" | sha256sum -c - \
      && tar -xJf "node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
      && ln -s /usr/local/bin/node /usr/local/bin/nodejs; \
  else \
    echo "Building from source" \
    # backup build
    && apk add --no-cache --virtual .build-deps-full \
        binutils-gold \
        g++ \
        gcc \
        gnupg \
        libgcc \
        linux-headers \
        make \
        python3 \
    # gpg keys listed at https://github.com/nodejs/node#release-keys
    && for key in \
      4ED778F539E3634C779C87C6D7062848A1AB005C \
      94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
      74F12602B6F1C4E913FAA37AD3A89613643B6201 \
      71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
      8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
      C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
      C82FA3AE1CBEDC6BE46B9360C43CEC45C17AB93C \
      DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
      A48C2BEE680E841632CD4E44F07496B3EB3C1762 \
      108F52B48DB57BB0CC439B2997B01419BD92F80A \
      B9E2F5981AA6E0CD28160D9FF13993A75599653C \
    ; do \
      gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$key" || \
      gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key" ; \
    done \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz" \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
    && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
    && grep " node-v$NODE_VERSION.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
    && tar -xf "node-v$NODE_VERSION.tar.xz" \
    && cd "node-v$NODE_VERSION" \
    && ./configure \
    && make -j$(getconf _NPROCESSORS_ONLN) V= \
    && make install \
    && apk del .build-deps-full \
    && cd .. \
    && rm -Rf "node-v$NODE_VERSION" \
    && rm "node-v$NODE_VERSION.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt; \
  fi \
  && rm -f "node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" \
  && apk del .build-deps \
  # smoke tests
  && node --version \
  && npm --version

ENV YARN_VERSION 1.22.5

RUN apk add --no-cache --virtual .build-deps-yarn curl gnupg tar \
  && for key in \
    6A010C5166006599AA17F08146C2130DFD2497F5 \
  ; do \
    gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$key" || \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key" ; \
  done \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
  && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && mkdir -p /opt \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && apk del .build-deps-yarn \
  # smoke test
  && yarn --version


# if the file /var/init/init.sh exists, then run it to initilize some processes when start docker
# like to copy mysql's configuration file to /etc/mysql/mysql.conf.d/ or modify apache2's configration
RUN mkdir -p /var/init
VOLUME /var/init


COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
# CMD /usr/sbin/httpd  -D   FOREGROUND
