#!/bin/sh
BIN=/etc/init.d/nginx
IS_EXEC=`cat $TEMP | grep -v 'null' | grep -v 'grep'`
if [ -f $BIN -a "$IS_EXEC" = "" ];then
    $BIN start
fi

