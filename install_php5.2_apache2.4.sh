#!/bin/sh
. /usr/local/src/apm/config/apm_config

# Php 5.2 Install Start !
echo -en "
\033[3;36m
                            ._________     _  ___________  __________  ____           
                            |   |/  /     |__   __|       |   |__|  |                  
                            |   /  /        |\ /|         |   /__\  |                   
                            |   \  \        |/ \|         |   /__ \ |                   
                            | __|\__\       |\_/|         /__/|  |_\|                  
                            /\      \\/      //    \/        //      /\  \\/          
\033[1;0m\033[2;31m
                                        MAKE BY KIMTAEKHAN
\033[1;0m\033[1;33m\e[5m
                                      start php installtion !
\033[1;0m
"
for i in `seq 5 -1 0`;
do
	echo -en "\r\t\t\t\t\t\t${i}"
	sleep 1
done


# zlib install
cd ${php_path}
wget https://github.com/kimtaekhan/apm/raw/master/php5.2_file/zlib-1.2.8.tar.gz
tar xvfz zlib-1.2.8.tar.gz
cd zlib-1.2.8
./configure --prefix=/usr/local
make && make install

# libpng install
cd ${php_path}
wget https://github.com/kimtaekhan/apm/raw/master/php5.2_file/libpng-1.5.9.tar.gz
tar xvf libpng-1.5.9.tar.gz 
cd libpng-1.5.9
./configure 
make test
make install

# freetype install
cd ${php_path}
wget https://github.com/kimtaekhan/apm/raw/master/php5.2_file/freetype-2.4.0.tar.gz
tar xvf freetype-2.4.0.tar.gz 
cd freetype-2.4.0
./configure --prefix=/usr/local
make
make install

# jpegsrc install
cd ${php_path}
wget https://github.com/kimtaekhan/apm/raw/master/php5.2_file/jpegsrc.v8.tar.gz
tar xvf jpegsrc.v8.tar.gz 
cd jpeg-8/
./configure --prefix=/usr/local --enable-shared --enable-static
make && make install

# libgd install
cd ${php_path}
wget https://github.com/kimtaekhan/apm/raw/master/php5.2_file/libgd-2.2.4.tar.gz
tar xvf libgd-2.2.4.tar.gz 
cd libgd-2.2.4
./configure --prefix=/usr/local
make && make install

# libiconv install
cd ${php_path}
wget https://github.com/kimtaekhan/apm/raw/master/php5.2_file/libiconv-1.15.tar.gz
tar xvf libiconv-1.15.tar.gz 
cd libiconv-1.15
./configure --prefix=/usr/local
make && make install

# libmcrypt install
cd ${php_path}
wget https://github.com/kimtaekhan/apm/raw/master/php5.2_file/libmcrypt-2.5.8.tar.gz
tar xvf libmcrypt-2.5.8.tar.gz
cd libmcrypt-2.5.8/
./configure --prefix=/usr/local
make && make install

# libxml install
cd ${php_path}
wget https://github.com/kimtaekhan/apm/raw/master/php5.2_file/libxml2-2.6.30.tar.gz
tar xvf libxml2-2.6.30.tar.gz 
cd libxml2-2.6.30
./configure --prefix=/usr/local --with-zlib=/usr/local --with-iconv=/usr/local
make && make install

# libxslt install
cd ${php_path}
wget https://github.com/kimtaekhan/apm/raw/master/php5.2_file/libxslt-1.1.9.tar.gz
tar xvf libxslt-1.1.9.tar.gz 
cd libxslt-1.1.9
./configure --prefix=/usr/local --with-libxml-prefix=/usr/local --with-libxml-include-prefix=/usr/local/include --with-libxml-libs-prefix=/usr/local/lib
make && make install

# php install
cd ${php_path}
wget https://github.com/kimtaekhan/apm/raw/master/php5.2_file/php-5.2.9_apache_2.4.tar.gz
tar xvf php-5.2.9_apache_2.4.tar.gz
cd php-5.2.9

# fix php 5.2 openssl.c bug
wget "http://github.com/kimtaekhan/php_bug/raw/master/php5.2/openssl.c"
rm -f ext/openssl/openssl.c
mv openssl.c ext/openssl/openssl.c

# openssl
yum -y remove pcre-devel
yum -y install zlib zlib-devel
rm -rf /usr/local/openssl
cd /usr/local/src/apm
wget https://github.com/kimtaekhan/apm/raw/master/openssl-1.0.1i.tar.gz
tar xvf openssl-1.0.1i.tar.gz
cd openssl-1.0.1i
./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl threads zlib shared
make && make install
echo /usr/local/openssl/lib >> /etc/ld.so.conf
ldconfig

# fix openssl error
yum -y install openssl-devel

# configure php now !
cd /usr/local/src/apm/php/php-5.2.9
./configure '--prefix=/usr/local/php' '--with-apxs2=/usr/local/apache/bin/apxs' '--with-config-file-path=/usr/local/apache/conf' '--with-libdir=lib64' '--with-curl' '--enable-calendar' '--enable-shmop' '--enable-ftp' '--enable-sockets' '--enable-magic-quotes' '--disable-cgi' '--with-gd' '--with-png-dir=/usr/lib' '--with-zlib-dir' '--with-jpeg-dir=/usr/lib' '--with-freetype-dir=/usr/lib' '--with-iconv' '--enable-mbstring' '--with-mcrypt=/usr/local' '--with-openssl' '--enable-bcmath' '--enable-libxml'

# compile installation start
make && make install

# symlink
ln -s /usr/local/php/bin/* /usr/bin

# interlock php with apache
cd ${php_path}/php-5.2.9
\cp php.ini-dist /usr/local/php/lib/php.ini
ln -s /usr/local/php/lib/php.ini /etc/php.conf
sed -i '/date.timezone =/a date.timezone = Asia/Seoul' /etc/php.conf
sed -i 's/DirectoryIndex index.html/    DirectoryIndex index.html index.php/g' /usr/local/apache/conf/httpd.conf
sed -i '/AddType application\/x-gzip .gz .tgz/a # AddType application\/x-httpd-php-source .phps' /usr/local/apache/conf/httpd.conf
sed -i '/AddType application\/x-gzip .gz .tgz/a AddType application\/x-httpd-php .php .html .phps' /usr/local/apache/conf/httpd.conf

# replace libz.so
rm -f /lib64/libz.so.1
rm -f /lib64/libz.so.1.2.3
cp /usr/local/lib/libz.so.1.2.8 /lib64/
ln -s /lib64/libz.so.1.2.8 /lib64/libz.so.1

# apache service restart
/usr/local/apache/bin/apachectl -k restart

# check php page
echo "<?php phpinfo(); ?>" >> /usr/local/apache/htdocs/phpinfo.php
