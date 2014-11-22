#http://qiita.com/hnakamur/items/0b72590136cece29faee
FROM typista/base

RUN wget https://raw.githubusercontent.com/typista/docker-nginx-lua/master/files/etc_init.d_nginx -O /root/etc_init.d_nginx && \
	wget https://raw.githubusercontent.com/typista/docker-nginx-lua/master/files/nginx.conf -O /root/nginx.conf && \
	wget https://raw.githubusercontent.com/typista/docker-nginx-lua/master/files/services.sh -O /root/services.sh && \
	wget https://raw.githubusercontent.com/typista/docker-nginx-lua/master/files/start.sh -O /root/start.sh && \
	echo "/root/monitor_nginx.sh" >> /root/start.sh && \
	wget https://raw.githubusercontent.com/typista/docker-nginx-lua/master/files/monitor_nginx.sh -O /root/monitor_nginx.sh && \
	echo "#########################" && \
	echo " install LuaJIT" && \
	echo "#########################" && \
	cd /usr/local/src && \
    curl -O http://luajit.org/download/LuaJIT-2.0.3.tar.gz && \
    tar xf LuaJIT-2.0.3.tar.gz && \
    cd LuaJIT-2.0.3 && \
    make && \
    make PREFIX=/usr/local/luajit install && \
	adduser nginx && \
	export LUAJIT_LIB=/usr/local/luajit/lib && \
    export LUAJIT_INC=/usr/local/luajit/include/luajit-2.0 && \
    cd /usr/local/src && \
    git clone git://github.com/simpl/ngx_devel_kit.git && \
    git clone git://github.com/chaoslawful/lua-nginx-module.git && \
    curl -LO http://downloads.sourceforge.net/project/pcre/pcre/8.36/pcre-8.36.tar.bz2 && \
    tar xf pcre-8.36.tar.bz2 && \
	echo "#########################" && \
	echo " install nginx" && \
	echo "#########################" && \
    curl -O http://nginx.org/download/nginx-1.7.6.tar.gz && \
    tar xf nginx-1.7.6.tar.gz && \
    cd nginx-1.7.6 && \
    ./configure --prefix=/usr/local/nginx \
      --user=nginx \
      --group=nginx \
      --with-http_ssl_module \
      --with-http_gzip_static_module \
      --with-http_realip_module \
      --with-pcre=/usr/local/src/pcre-8.36 \
      --add-module=/usr/local/src/ngx_devel_kit \
      --add-module=/usr/local/src/lua-nginx-module \
      --with-ld-opt="-Wl,-rpath,$LUAJIT_LIB" && \
    make && \
    make install && \
	cp /root/etc_init.d_nginx /etc/init.d/nginx && \
	cp /root/services.sh /etc/services.sh && \
	cp /root/nginx.conf /usr/local/nginx/conf/nginx.conf && \
	chmod +x /etc/init.d/nginx && \
	chmod +x /etc/services.sh && \
	chmod +x /etc/start.sh
EXPOSE 80
ENTRYPOINT /etc/services.sh

