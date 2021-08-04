#!/usr/bin/env bash

#
# Manage the running of Apache httpd and Mysql
#

# run some initial process
if [ -f "/var/init/init.sh" ]; then
    chmod a+x /var/init/init.sh
    /var/init/init.sh
fi

# if use mod-fcgid to run run php5 and php at one host, need to remove this file
# if some things went wrong because of mod-fcgid, then need to comment out here to run php5 in normal mode (php7 doesn't work then)
if [ -f "/etc/apache2/conf.d/php5-module.conf" ]; then
    mv /etc/apache2/conf.d/php5-module.conf /etc/apache2/conf.d/php5-module.conf-remove
fi

if [ -d "/var/phpmyadmin" ]; then
    if [ ! -d "/var/phpmyadmin/tmp" ]; then
        mkdir -p /var/phpmyadmin/tmp
        chmod 777  /var/phpmyadmin/tmp
    fi
    if [ ! -f "/var/phpmyadmin/config.inc.php" ]; then
        randomSecret=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 40)
        sed -e "s|cfg\['blowfish_secret'\] = ''|cfg['blowfish_secret'] = '$randomSecret'|" /var/phpmyadmin/config.sample.inc.php > /var/phpmyadmin/config.inc.php
    fi
fi

# is a certain UID wanted?
if [ ! -z "$APACHE_UID" ]; then
    useradd --home /var/www/html --gid www-data -M -N --uid $APACHE_UID  wwwrun
    echo "export APACHE_RUN_USER=wwwrun" >> /etc/apache2/envvars
    chown -R wwwrun /var/lib/apache2
fi

# Direct logs to stdout/stderr so they will show in 'docker logs' command.
ln -sf /dev/stderr /var/log/apache2/error.log
ln -sf /dev/stdout /var/log/apache2/access.log
ln -sf /dev/stdout /var/log/apache2/other_vhosts_access.log

# Apache gets grumpy about PID files pre-existing
rm -f /var/run/apache2/httpd.pid

# Start MySQL
if [ -f "/mysql-entrypoint.sh" ]; then
    /mysql-entrypoint.sh "mysqld"
fi

# Start Apache in the foreground to keep the container running.
apache2ctl -DFOREGROUND
