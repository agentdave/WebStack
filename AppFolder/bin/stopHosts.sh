# /bin/sh

# Test whether we've patched the hosts file before bothering to copy the backup
test_hosts=`grep WebStack /etc/hosts`

if [ "$?" -eq '0' ]; then
	cat /etc/hosts | sed '/^.*#.*ws-tmp$/d' | sed '/^# Temporary Host Settings - WebStack$/d' | sed -e :a -e '/^\n*$/{$d;N;ba' -e '}' | sudo tee /etc/hosts >/dev/null
fi

dscacheutil -flushcache