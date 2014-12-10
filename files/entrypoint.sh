#!/bin/bash
# mount:/var/www
LOCALTIME=/etc/localtime
if [ ! -L $LOCALTIME ]; then
  rm $LOCALTIME
  ln -s /usr/share/zoneinfo/Asia/Tokyo $LOCALTIME
fi

HOSTNAME=`hostname`
FQDN=`echo $HOSTNAME | sed -r "s/_/\./g"`
ROOT=/var/www/$HOSTNAME
HTML=$ROOT/html
if [ ! -e $HTML ]; then
	mkdir -p $HTML
fi
LINK=/usr/share/nginx/html
if [ ! -L $LINK ]; then
	rm -rf $LINK
	ln -s $HTML $LINK
fi
chown -R nginx: $ROOT

# mount:/var/log/nginx
LOG=/var/log/nginx/$HOSTNAME
NGINX=/usr/local/nginx
if [ ! -e $LOG ]; then
	mkdir -p $LOG
	mkdir -p $NGINX/conf.d
fi
NGINX_CONF=$NGINX/conf/nginx.conf
PROCNUM=`grep processor /proc/cpuinfo | wc -l`
ISDEFAULT=`grep $HOSTNAME $NGINX_CONF | wc -l`
if [ $ISDEFAULT -eq 0 ]; then
	sed -ri "s/__PROCNUM__/$PROCNUM/g" $NGINX_CONF
	sed -ri "s/__HOSTNAME__/$HOSTNAME/g" $NGINX_CONF
	sed -ri "s/__FQDN__/$FQDN/g" $NGINX_CONF
fi
chown -R nginx: $LOG
crontab /root/crontab.txt
/etc/init.d/nginx start
/etc/init.d/crond start
/usr/bin/tail -f /dev/null
