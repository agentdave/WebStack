#!/bin/sh

# Works with MacPorts-1.8.2, or more specifically:
#
# Apache 2.2.14
# PHP 5.3.2
# MySQL 5.1.45
# Ruby 1.8.7

INSTALL_DIR=/Applications/WebStack
SITES_DIR=$HOME/Sites

MACPORTS_VERSION=MacPorts-1.8.2
MACPORTS_DOWNLOAD=$MACPORTS_VERSION.tar.gz
MACPORTS_URL=http://distfiles.macports.org/MacPorts/$MACPORTS_DOWNLOAD

export PATH=/bin:/sbin:/usr/bin:/usr/sbin

cd $INSTALL_DIR
mkdir temp
cd temp

curl -O $MACPORTS_URL

tar -xvf $MACPORTS_DOWNLOAD

cd $MACPORTS_VERSION

mkdir $INSTALL_DIR

./configure --prefix=$INSTALL_DIR/opt/local --with-tclpackage=$INSTALL_DIR/Library/Tcl --with-applications-dir=$INSTALL_DIR/Applications
make
sudo make install

export PATH=$INSTALL_DIR/opt/local/bin:$INSTALL_DIR/opt/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin

sudo ln -s $INSTALL_DIR/opt/local/etc $INSTALL_DIR/config

sudo port selfupdate

# Apache
sudo port install apache2 +no_startupitem

sudo ln -s $INSTALL_DIR/opt/local/apache2/conf $INSTALL_DIR/config/apache

# MySQL
sudo port install mysql5-server
sudo mysql_install_db5 --datadir=$INSTALL_DIR/db
sudo chown -R mysql:mysql $INSTALL_DIR/db/mysql/
sudo chown -R mysql:mysql $INSTALL_DIR/opt/local/var/db/mysql5/ 
sudo chown -R mysql:mysql $INSTALL_DIR/opt/local/var/run/mysql5/ 
sudo chown -R mysql:mysql $INSTALL_DIR/opt/local/var/log/mysql5/

sudo rm -fr $INSTALL_DIR/opt/local/var/db
sudo ln -s $INSTALL_DIR/db $INSTALL_DIR/opt/local/var/db

# PHP5
sudo port install php5 +apache2 +fastcgi
sudo port install php5-mysql +mysqlnd
cd $INSTALL_DIR/opt/local/apache2/modules
sudo $INSTALL_DIR/opt/local/apache2/bin/apxs -a -e -n "php5" libphp5.so
sed "s/DirectoryIndex \(.*\)/DirectoryIndex index\.php \1/g" $INSTALL_DIR/config/apache/httpd.conf | sudo tee $INSTALL_DIR/config/apache/httpd.conf >/dev/null
sed "s/#.*\(Include.*httpd-vhosts\.conf\)/\1/g" $INSTALL_DIR/config/apache/httpd.conf | sudo tee $INSTALL_DIR/config/apache/httpd.conf >/dev/null
sed 's|^DocumentRoot.*|DocumentRoot '$SITES_DIR'|g' $INSTALL_DIR/config/apache/httpd.conf | sudo tee $INSTALL_DIR/config/apache/httpd.conf >/dev/null
sed 's|^<Directory  *".*htdocs.*" *>|<Directory "'$SITES_DIR'">|g' $INSTALL_DIR/config/apache/httpd.conf | sudo tee $INSTALL_DIR/config/apache/httpd.conf >/dev/null
sed "s/AllowOverride None/AllowOverride All/g" $INSTALL_DIR/config/apache/httpd.conf | sudo tee $INSTALL_DIR/config/apache/httpd.conf >/dev/null

echo "" | sudo tee -a $INSTALL_DIR/config/apache/httpd.conf >/dev/null
echo "#" | sudo tee -a $INSTALL_DIR/config/apache/httpd.conf >/dev/null
echo "# Include PHP configuration" | sudo tee -a $INSTALL_DIR/config/apache/httpd.conf >/dev/null
echo "#" | sudo tee -a $INSTALL_DIR/config/apache/httpd.conf >/dev/null
echo "Include conf/extra/mod_php.conf" | sudo tee -a $INSTALL_DIR/config/apache/httpd.conf >/dev/null

cd $INSTALL_DIR/opt/local/etc/php5
sudo cp php.ini-development php.ini
sudo cp php.ini php.ini.bak
defSock=`$INSTALL_DIR/opt/local/bin/mysql_config5 --socket`

cat php.ini | sed \
-e "s#pdo_mysql\.default_socket.*#pdo_mysql\.default_socket=${defSock}#" \
-e "s#mysql\.default_socket.*#mysql\.default_socket=${defSock}#" \
-e "s#mysqli\.default_socket.*#mysqli\.default_socket=${defSock}#" | sudo tee php.ini >/dev/null

sudo cp $INSTALL_DIR/opt/local/share/mysql5/mysql/my-medium.cnf $INSTALL_DIR/opt/local/etc/mysql5/my.cnf

# Ruby
sudo port install ruby
sudo port install rb-rubygems
sudo port install rb-termios
sudo port install rb-mysql
sudo port install ImageMagick
sudo port install memcached
sudo port install php5-memcached
sudo port install php5-memcache
sudo port install rb-memcache

sed "s|-L/opt/local/lib||g" $INSTALL_DIR/opt/local/bin/Magick-config | sudo tee $INSTALL_DIR/opt/local/bin/Magick-config >/dev/null

# Ruby Gems
sudo gem install rails
sudo gem install rails -v2.2.2
sudo gem install rmagick
sudo gem install mysql
sudo gem install passenger

echo "" | sudo tee -a $INSTALL_DIR/config/apache/httpd.conf >/dev/null
echo "LoadModule passenger_module $INSTALL_DIR/opt/local/lib/ruby/gems/1.8/gems/passenger-2.2.11/ext/apache2/mod_passenger.so" | sudo tee -a $INSTALL_DIR/config/apache/httpd.conf >/dev/null
echo "PassengerRoot $INSTALL_DIR/opt/local/lib/ruby/gems/1.8/gems/passenger-2.2.11" | sudo tee -a $INSTALL_DIR/config/apache/httpd.conf >/dev/null
echo "PassengerRuby $INSTALL_DIR/opt/local/bin/ruby" | sudo tee -a $INSTALL_DIR/config/apache/httpd.conf >/dev/null

sudo passenger-install-apache2-module

# Fix Permissions
sudo chown -R $LOGNAME:admin $INSTALL_DIR/Library
sudo chown -R $LOGNAME:admin $INSTALL_DIR/bin
sudo chown -R $LOGNAME:admin $INSTALL_DIR/install
sudo chown -R $LOGNAME:admin $INSTALL_DIR/opt
sudo chown -R $LOGNAME:admin $INSTALL_DIR/temp

# Repeated from above (because they'll have been reset while fixing permissions)
sudo chown -R mysql:mysql $INSTALL_DIR/opt/local/var/run/mysql5/ 
sudo chown -R mysql:mysql $INSTALL_DIR/opt/local/var/log/mysql5/