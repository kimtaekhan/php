#!/bin/sh

. /usr/local/src/apm/config/apm_config

# yum install
yum -y install ncurses-devel # ncurses 라이브러리가 없어서 발생할수 있는 에러를 예방하기 위해 설치합니다.
yum -y install compat-* # gcc 호환성 패키지들  compat-* 을 시스템에 설치한다.
yum -y install ntsysv # chkconfig 의 GUI 버전
<<COMMENT3
GD Library 란  
Graphics 라이브러리로 선, 도형, 텍스트, 다중 색깔, 
이미지의 cut paste, 채우기 등의 이미지 처리기능과 이 결과를 
그래픽 파일로 (gif,jpeg,png) 저장하는 기능을 제공한다.

GD Library는 APM 설치 시 반드시 깔는 기본 패키지이다.

GD 라이브러리는 소스로 설치하는 방법과 yum으로 설치하는 방법있다.
여기서는 yum으로 설치하는 방법을 이용한다.
COMMENT3
yum -y install gd gd-devel libjpeg libjepg-devel giflib giflib-devel libpng libpng-devel freetype freetype-devel
yum -y remove pcre-devel
yum -y install zlib zlib-devel
yum -y install libxml2-devel
yum -y install curl-devel
yum -y remove bison-develyum remove bison
yum -y remove byacc-devel
yum -y remove byacc
yum -y install wget
#yum -y install lynx
#yum -y install tcpdump

# wget

cd ${php_path}/

# php-7.0.8.tar.gz
wget "https://github.com/kimtaekhan/apm/raw/master/php-7.0.8.tar.gz"

# bison-2.7.91.tar.gz
wget "https://github.com/kimtaekhan/apm/raw/master/bison-2.7.91.tar.gz"

# re2c-0.13.7.5.tar.gz
wget "https://github.com/kimtaekhan/apm/raw/master/re2c-0.13.7.5.tar.gz"

# tar & mv
cd ${php_path}/
tar xvf php-7.0.8.tar.gz
tar xvf bison-2.7.91.tar.gz

# install bison-2.7.91
cd ${php_path}/bison-2.7.91
./configure
make & make install
make install check

# install php-7.0.8 now
cd ${php_path}/php-7.0.8
./configure --prefix=/usr/local/php --with-mysql=/usr/local/mysql --with-apxs2=/usr/local/apache/bin/apxs --with-jpeg-dir --with-png-dir --with-curl --with-zlib-dir --with-gd --with-freetype-dir --with-iconv --with-zlib --with-openssl --with-pcre-regex --with-pear --enable-sockets --disable-debug --enable-ftp --enable-sysvsem=yes --enable-sysvshm=yes --enable-bcmath --enable-exif --enable-zip --enable-gd-native-ttf --enable-mbstring
make && make install

# symlink
ln -s /usr/local/php/bin/* /usr/bin

cd ${php_path}/php-7.0.8
\cp php.ini-development /usr/local/php/lib/php.ini
ln -s /usr/local/php/lib/php.ini /etc/php.conf
sed -i '/date.timezone =/a date.timezone = Asia/Seoul' /etc/php.conf
sed -i 's/DirectoryIndex index.html/    DirectoryIndex index.html index.php/g' /usr/local/apache/conf/httpd.conf
sed -i '/AddType application\/x-gzip .gz .tgz/a # AddType application\/x-httpd-php-source .phps' /usr/local/apache/conf/httpd.conf
sed -i '/AddType application\/x-gzip .gz .tgz/a AddType application\/x-httpd-php .php .html' /usr/local/apache/conf/httpd.conf

# apache service restart
/etc/init.d/httpd stop
/etc/init.d/httpd start

# check php page
echo "<?php phpinfo(); >?" >> /usr/local/apache/htdocs/phpinfo.php
