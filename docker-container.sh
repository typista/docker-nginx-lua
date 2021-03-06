#!/bin/sh
USER=typista
if [ "$2" = "" ];then
	echo "Input parametor FQDN and HTTP-PORT [and TAG]"
else
	__FQDN__=$1
	__PORT__=$2
	__HOSTNAME__=`echo $__FQDN__ | sed -r "s/\./_/g"`
	FULLPATH=$(cd `dirname $0`; pwd)/`basename $0`
	DIR=`dirname $FULLPATH`
	REPO=`basename $DIR`
	REPO=`echo $REPO | sed -r "s/docker\-//g"`
	IMAGE=$USER/$REPO
	if [ "$3" != "" ];then
    		IMAGE=$IMAGE:$3
	fi
	docker run -d --privileged --restart=always --name="$__FQDN__" --hostname="$__HOSTNAME__" \
		-p $__PORT__:80 \
		-v /var/www/:/var/www/ \
		-v /var/log/nginx/:/var/log/nginx/ \
		-v ${PWD}/export/conf/:/usr/local/nginx/conf/ \
		-v ${PWD}/export/conf.d/:/usr/local/nginx/conf.d/ \
		-v ${PWD}/export/root/:/root/export/ \
		$IMAGE

	DIR_CONTAINER=dst/$__FQDN__
	if [ ! -e $DIR_CONTAINER ];then
		mkdir -p $DIR_CONTAINER
	fi

	BOOT=./container/docker-boot-$__HOSTNAME__.sh
	BOOT_OFF=./container/docker-boot-off-$__HOSTNAME__.sh
	REMOVE=./container/docker-remove-$__HOSTNAME__.sh
	echo "./docker-boot.sh $__FQDN__" > $BOOT
	echo "./docker-boot-off.sh $__FQDN__" > $BOOT_OFF
	echo "docker rm -f $__FQDN__" > $REMOVE
	echo "sudo rm -rf /var/www/$__HOSTNAME__" >> $REMOVE
	chmod +x $BOOT
	chmod +x $BOOT_OFF
	chmod +x $REMOVE
	$BOOT
fi
