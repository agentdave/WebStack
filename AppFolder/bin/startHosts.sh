# /bin/sh

# Test whether we've already patched the hosts file so we don't do it twice
test_hosts=`grep WebStack /etc/hosts`

if [ "$?" -ne '0' ]; then
	echo "" | sudo tee -a /etc/hosts >/dev/null
	echo "" | sudo tee -a /etc/hosts >/dev/null
	echo "# Temporary Host Settings - WebStack" | sudo tee -a /etc/hosts >/dev/null
	cat /Applications/WebStack/config/apache/extra/httpd-vhosts.conf | grep ServerName | sed "s/.*ServerName[ \t]*\(.*\)/127\.0\.0\.1 \1 # ws-tmp/g" | sudo tee -a /etc/hosts >/dev/null
	cat /Applications/WebStack/config/apache/extra/httpd-vhosts.conf | grep ServerAlias | sed "s/.*ServerAlias[ \t]*\(.*\)/127\.0\.0\.1 \1 # ws-tmp/g" | sudo tee -a /etc/hosts >/dev/null
fi

dscacheutil -flushcache