#!/bin/sh

sudo /Applications/WebStack/opt/local/apache2/bin/apachectl start
sudo /Applications/WebStack/opt/local/bin/mysqld_safe5 --datadir=/Applications/WebStack/db >/dev/null 2>&1 &
/Applications/WebStack/opt/local/bin/memcached &

sudo /Applications/WebStack/bin/startHosts.sh