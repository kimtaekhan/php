#!/bin/sh

. /usr/local/src/apm/config/apm_config

# yum install lynx
yum -y install lynx

on_mysqli=`cat -n ${php_path}/php-7.0.8/ext/mysqli/mysqli_api.c | grep '#include "ext/mysqlnd/mysql_float_to_double.h"' | awk '{printf $1}'`
sed -i ''"$on_mysqli"'d' ${php_path}/php-7.0.8/ext/mysqli/mysqli_api.c
sed -i ''"$on_mysqli"'i #include "'"${php_path}"'/php-7.0.8/ext/mysqlnd/mysql_float_to_double.h"' /usr/local/src/apm/php/php-7.0.8/ext/mysqli/mysqli_api.c

cd ${php_path}/php-7.0.8/ext/mysqli/
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config --with-mysqli=/usr/local/mysql/bin/mysql_config
make && make install

echo "extension=/usr/local/php/lib/php/extensions/no-debug-non-zts-20151012/mysqli.so" >> /usr/local/php/lib/php.ini

/usr/local/apache/bin/apachectl -k restart

check_done=`/usr/local/php/bin/php -m | grep mysqli | wc -l`

if [ ${check_done} -eq 1 ]
then
	echo -en "mysqli module installed done !"
fi

cat << mysqlis > /usr/local/apache/htdocs/mysqli_test.php
<?php
\$mysqli_connection = new MySQLi('localhost', 'root', '', 'mysql');
if (\$mysqli_connection->connect_error) {
   echo "Not connected, error: " . \$mysqli_connection->connect_error;
}
else {
   echo "Connected.";
}
?>
mysqlis

check_page=`lynx --dump 127.0.0.1/mysqli_test.php | grep "Connected." | wc -l`

if [ ${check_page} -eq 1 ]
then
	echo -en "mysqli page work !!"
fi
