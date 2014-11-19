#http://qiita.com/hnakamur/items/0b72590136cece29faee
FROM typista/base

# install LuaJIT
RUN cd /usr/local/src && \
    curl -O http://luajit.org/download/LuaJIT-2.0.3.tar.gz && \
    tar xf LuaJIT-2.0.3.tar.gz && \
    cd LuaJIT-2.0.3 && \
    make && \
    make PREFIX=/usr/local/luajit install

# install nginx with lua-nginx-module
RUN adduser nginx
RUN export LUAJIT_LIB=/usr/local/luajit/lib && \
    export LUAJIT_INC=/usr/local/luajit/include/luajit-2.0 && \
    cd /usr/local/src && \
    git clone git://github.com/simpl/ngx_devel_kit.git && \
    git clone git://github.com/chaoslawful/lua-nginx-module.git && \
    curl -LO http://downloads.sourceforge.net/project/pcre/pcre/8.36/pcre-8.36.tar.bz2 && \
    tar xf pcre-8.36.tar.bz2 && \
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
    make install

ADD files/execme1st.sh /root/
ADD files/services.sh /etc/services.sh
ADD files/etc_init.d_nginx /etc/init.d/nginx
ADD files/nginx.conf /usr/local/nginx/conf/nginx.conf
RUN chmod +x /etc/services.sh
RUN chmod +x /etc/init.d/nginx
EXPOSE 80
ENTRYPOINT /etc/services.sh

