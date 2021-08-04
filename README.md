# Dockers for software development

## alpine-php5.6-7.2-mysql5
Building time: 162.7s, size: 781M

* OS: alpine:3.8
* Apache: 2.4
* PHP: 5.6, 7.2, access port: 9056, 9072
* MYSQL: 5.7
* phpMyAdmin: 4.9
* NodeJS: 14.17
* Python: 2.7

Installing Mysql increases 150M size

Installing composer and phpmyadmin increases 250M size

Installing python increases 35M size

Installing nodejs increases 110M size

## debian-php5-7-8-mysql5
Building time: 40m (5 PHP versions), size: 1.19G

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