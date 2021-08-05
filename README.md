# Dockers for software development

## alpine-php5.6-7.2-mysql5
Building time: 162.7s, size: 264M

You can pull built image directly from: https://hub.docker.com/r/uuware/alpine-php5.6-7.2-mysql5

* OS: alpine:3.8
* Apache: 2.4
* PHP: 5.6, 7.2, access port: 9056, 9072
* MYSQL: 5.7
* phpMyAdmin: 4.9
* NodeJS: 14.17
* Python: 2.7

## debian-php5-7-8-mysql5
Building time: 40m (5 PHP versions), size: 431M

You can pull built image directly from: https://hub.docker.com/r/uuware/debian-php5-7-8-mysql5


* OS: debian:jessie
* Apache: 2.4
* PHP: 5.3 5.6 7.0 7.4 8.0, access port: 8053, 8056, 8070, 8074, 8080
** support version: 5.3.29 5.4.45 5.5.38 5.6.40 7.0.33 7.1.33 7.2.34 7.3.28 7.4.22 8.0.9 (you need to build by yourself)
* MYSQL: 5.5
* phpMyAdmin: 4.9
* NodeJS: 14.17
* Python3: 3.4

## Change password for MYSQL root is supported
After installation, mysql root password can be chenged by running this in docker:
'/usr/bin/mysqladmin' -u root password 'new-password'

PHP part is from:
https://github.com/splitbrain/docker-phpfarm

## How to use (for example: debian-php5-7-8-mysql5)
You can clone the repository to local and use docker-compose to start it.

`docker-compose -f "debian-php5-7-8-mysql5-my/docker-compose.yml" up -d --build`

The easy and fast way is to run from built image.

`docker run -p 8053:8053 -p 8056:8056 -p 8070:8070 -p 8074:8074 -v "/your-www:/var/www" -v "/your-data:/var/lib/mysql" -v "/your-init:/var/init" uuware/debian-php5-7-8-mysql5`

* /var/www: web root
* /var/lib/mysql: MYSQL data
* /var/init: if you put init.sh here, then it's called when containser is started

If you are using VS Code and installed Docker Extension, then you can create a docker-compose.yml, and right click on it to Compose Up.
A sample for docker-compose.yml.

```
# By default, it contains PHP 5.3 5.6 7.0 7.4 8.0, but you can change it by using source: https://github.com/uuware/dockers
# The port 8053 maps to PHP5.3, 8080 maps to PHP8.0 and so on
version: '3.1'
services:
  web:
    hostname: web
    environment:
      # if installed from image, then this for changing mysql root password doesn't work. don't know why.
      # '/usr/bin/mysqladmin' -u root password 'new-password'
      # but you can login with inputing a password in terminal: mysql -uroot -hlocalhost -p
      # login from phpmyadmin is OK.
      - MYSQL_ROOT_PASSWORD=MysqlPassword123
    image: uuware/debian-php5-7-8-mysql5
    volumes:
      # /var/init/init.sh is called when start the container to do some initial process.
      - "./var/init:/var/init"
      - "./var/mysql-data:/var/lib/mysql"
      - "./var/www:/var/www"
    ports:
      - "8053:8053"
      - "8056:8056"
      - "8070:8070"
      - "8074:8074"
      - "8080:8080"
      - "8306:3306"
```
