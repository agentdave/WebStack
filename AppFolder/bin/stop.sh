#!/bin/sh

killall memcached
/Applications/WebStack/opt/local/bin/mysqladmin5 -u root shutdown
sudo /Applications/WebStack/opt/local/apache2/bin/apachectl stop

sudo /Applications/WebStack/bin/stopHosts.sh