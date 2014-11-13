#!/bin/sh
USER=typista
FULLPATH=$(cd `dirname $0`; pwd)/`basename $0`
DIR=`dirname $FULLPATH`
REPO=`basename $DIR`
IMAGE=$USER/$REPO
if [ "$1" != "" ];then
    IMAGE=$IMAGE:$1
fi
docker build -t $IMAGE .
