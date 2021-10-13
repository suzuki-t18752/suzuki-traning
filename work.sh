#!/bin/sh

#sudo実行時
#echo $password | -S コマンド

#echo -e "\n" エンター入力


#source work.sh | tee -a ./work_sh.log
#上記にて実行する(標準入出力をロギングする)

#CentOS7
#virtualbox,ネットワークの設定はあらかじめ行う
#ストレージは40G程度必要
#root権限にて実行する
#画像の投稿を行う為画像ファイルを置いておく

#パスワード変数ファイル
# MYSQL57_ROOT_PASS=~~~~
# MYSQL56_ROOT_PASS=~~~~
# MYSQL57_WP_PASS=~~~~
# MYSQL56_WP_PASS=~~~~
# BASIC_PASS=~~~~~
# DIGEST_PASS=~~~~~
# WP_USER_COM_PASS=~~~~
# WP_USER_NET_PASS=~~~~





#変数のセット
export $(cat ./.pass)

#ホスト名を変更する
hostnamectl set-hostname suzuki-t

cp /etc/hosts /etc/hosts_bak

#hostsに設定
sh -c "echo '192.168.56.3   suzuki-t.com' >> /etc/hosts"
sh -c "echo '192.168.56.3   suzuki-t.net' >> /etc/hosts"

diff /etc/hosts /etc/hosts_bak


#yumのアップデート
yum -y update

#リポジトリの追加
yum -y install http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

#パッケージのインストール
yum -y install patch cmake ncurses-devel zlib-devel \
libaio-devel openssl-devel gcc-c++ bison \
gcc make pcre-devel expat-devel \
openssl-devel libcurl-devel libpng-devel libicu-devel \
libxml2-devel sqlite-devel perl oniguruma-devel \
libsodium-devel perl-Data-Dumper iptables-services

#iptablesの設定########################################################################
#firewalld停止
systemctl stop firewalld

systemctl status firewalld

#自動起動停止
systemctl disable firewalld

systemctl is-enabled firewalld

#iptables起動
systemctl start iptables

systemctl status iptables

#iptables自動起動設定
systemctl enable iptables

systemctl is-enable iptables

#記録
iptables -nL

#ルールの追加
iptables -I INPUT 5 -p tcp --dport 80 -j ACCEPT
iptables -I INPUT 5 -p tcp --dport 443 -j ACCEPT
iptables -I INPUT 5 -p tcp --dport 3306 -j ACCEPT
iptables -I INPUT 5 -p tcp --dport 3307 -j ACCEPT

#記録
iptables -nL

cp /etc/sysconfig/iptables /etc/sysconfig/iptables.bak

#変更したルールの保存を行う
/usr/libexec/iptables/iptables.init save

diff /etc/sysconfig/iptables /etc/sysconfig/iptables.bak

##################################################################################

#apache###########################################################################
#APRのダウンロード、インストール
#ファイルを置くディレクトリへ移動
cd /usr/local/src

#ファイルのダウンロードする
curl -O --url https://dlcdn.apache.org//apr/apr-1.7.0.tar.gz

#ファイルを解凍
tar xvf apr-1.7.0.tar.gz

#作業ディレクトリへ移動
cd apr-1.7.0

#Makefileを作成
./configure --prefix=/usr/local/apr/apr-1.7.0

#Makefikeを元にmake installに必要なファイルをコンパイル
make

#インストール実施
make install

#apr-utilのダウンロード、インストール手順
#ファイルを置くディレクトリへ移動
cd /usr/local/src

#ファイルのダウンロードする
curl -O --url https://dlcdn.apache.org//apr/apr-util-1.6.1.tar.gz

#ファイルを解凍
tar xvf apr-util-1.6.1.tar.gz

#作業ディレクトリへ移動
cd apr-util-1.6.1

#Makefileを作成
./configure --prefix=/usr/local/apr-util/apr-util-1.6.1 --with-apr=/usr/local/apr/apr-1.7.0

#Makefikeを元にmake installに必要なファイルをコンパイル
make

#インストール実施
make install



#apacheのダウンロード、インストール手順
#ファイルを置くディレクトリへ移動
cd /usr/local/src

#ファイルのダウンロードする
curl -O --url https://dlcdn.apache.org//httpd/httpd-2.4.48.tar.gz

#ファイルを解凍する
tar xvf httpd-2.4.48.tar.gz

#作業ディレクトリへ移動
cd /usr/local/src/httpd-2.4.48

#Makefileを作成
./configure --prefix=/usr/local/httpd/httpd-2.4.48 --with-apr=/usr/local/apr/apr-1.7.0 \
--with-apr-util=/usr/local/apr-util/apr-util-1.6.1 --enable-ssl --with-mpm=prefork

#Makefikeを元にmake installに必要なファイルをコンパイル
make

#インストール実施
make install

#apacheを起動する
/usr/local/httpd/httpd-2.4.48/bin/apachectl start  


###################################################################################################

#phpインストール####################################################################################
cd /usr/local/src

#phpのソースコードダウンロード
curl -LO --url https://www.php.net/distributions/php-7.4.23.tar.gz

#解凍
tar xvf php-7.4.23.tar.gz

#
cd php-7.4.23

#perlのインストール先を設定
sed -i -e 's%#!/replace/with/path/to/perl/interpreter -w%#!/usr/bin/perl -w%g' /usr/local/httpd/httpd-2.4.48/bin/apxs

#Makefileの作成
./configure --with-apxs2=/usr/local/httpd/httpd-2.4.48/bin/apxs --with-pdo-mysql --with-mysqli \
--with-curl --enable-exif --enable-mbstring --with-openssl --with-sodium \
--enable-bcmath --enable-gd --enable-intl --enable-ftp --enable-sockets --with-zlib

#コンパイル
make

#インストール
make install

php -v

#php.iniの設定
cp /usr/local/src/php-7.4.23/php.ini-development /usr/local/lib/php.ini

patch /usr/local/lib/php.ini << EOF
465c465
< error_reporting = E_ALL
---
> error_reporting = E_ALL ^ E_NOTICE ^ E_DEPRECATED
482c482
< display_errors = On
---
> display_errors = Off
586c586
< ;error_log = php_errors.log
---
> error_log = /usr/local/php/log/php_errors.log
694c694
< post_max_size = 8M
---
> post_max_size = 64M
846c846
< upload_max_filesize = 2M
---
> upload_max_filesize = 32M
1767a1768
> zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20190902/opcache.so
1769c1770
< ;opcache.enable=1
---
> opcache.enable=1
1772c1773
< ;opcache.enable_cli=0
---
> opcache.enable_cli=1
1775c1776
< ;opcache.memory_consumption=128
---
> opcache.memory_consumption=128
1778c1779
< ;opcache.interned_strings_buffer=8
---
> opcache.interned_strings_buffer=8
1782c1783
< ;opcache.max_accelerated_files=10000
---
> opcache.max_accelerated_files=4000
1800c1801
< ;opcache.revalidate_freq=2
---
> opcache.revalidate_freq=60
EOF

#phpのログ用ディレクトリ作成
mkdir /usr/local/php/log

chown -R daemon:daemon /usr/local/php/log/

diff /usr/local/src/php-7.4.23/php.ini-development /usr/local/lib/php.ini

php -v


########################################################################################################################


#mysql5.7インストール#######################################################################################################
#mysql用グループの作成
groupadd mysql

#mysql用ユーザーの作成
useradd -m mysql -g mysql

#ログ用のディレクトリとファイルを作成し、mysqlユーザーに権限を与える
mkdir /var/log/mariadb

chown -R mysql:mysql /var/log/mariadb

#ソースコードを置くディレクトリへ
cd /usr/local/src

#ソースコードのダウンロード
curl -L -O --url https://downloads.mysql.com/archives/get/p/23/file/mysql-5.7.34.tar.gz

#ファイルの解凍
tar xvf mysql-5.7.34.tar.gz

#作業ディレクトリへ移動
cd mysql-5.7.34

#Makefileを作成
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql5.7 -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/usr/local/boost \
-DMYSQL_DATADIR=/usr/local/mysql5.7/data -DMYSQL_TCP_PORT=3306

#Makefikeを元にmake installに必要なファイルをコンパイル
make

#インストール実施
make install

#作業ディレクトリへ
cd /usr/local/mysql5.7

cp /etc/my.cnf /usr/local/mysql5.7/my.cnf

#my.cnfを変更
patch -R /usr/local/mysql5.7/my.cnf << EOF
2,6c2,3
< datadir=/usr/local/mysql5.7/data
< socket=/usr/local/mysql5.7/data/mysql.sock
< port=3306
< character-set-server=utf8mb4
< collation-server=utf8_general_ci
---
> datadir=/var/lib/mysql
> socket=/var/lib/mysql/mysql.sock
EOF

#記録
diff /etc/my.cnf /usr/local/mysql5.7/my.cnf

#my.cnfを指定
sed -i -e 's%conf=/etc/my.cnf%conf=/usr/local/mysql5.7/my.cnf%g' /usr/local/mysql5.7/support-files/mysql.server

#データディレクトリを初期化
/usr/local/mysql5.7/bin/mysqld --initialize --user=mysql --datadir=/usr/local/mysql5.7/data 2>&1 | tee -a /var/log/mariadb/mariadb.log

#データディレクトリ初期化後のroot初期化パスワードを取得
DB_PASSWORD=$(grep "A temporary password is generated" /var/log/mariadb/mariadb.log | sed -s 's/.*root@localhost: //')

#データディレクトリのパーミッションを変更
chmod 755 /usr/local/mysql5.7/data

#systemctlで実行できるようプロセス起動用ファイルをinit.dへコピー
cp /usr/local/mysql5.7/support-files/mysql.server /etc/init.d/mysql57

#ststemctlへの反映
systemctl daemon-reload

#mysql5.7起動
systemctl start mysql57

systemctl status mysql57

#mysql5.7自動起動設定
systemctl enable mysql57

systemctl is-enabled mysql57



#rootユーザーのパスワードを設定
/usr/local/mysql5.7/bin/mysql -u root -p"$DB_PASSWORD" --socket=/usr/local/mysql5.7/data/mysql.sock \
-e"ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL57_ROOT_PASS';" --connect-expired-password 

/usr/local/mysql5.7/bin/mysql -t -u root --socket=/usr/local/mysql5.7/data/mysql.sock -e"select user, HOST from mysql.user;"

#wordpress用ユーザー作成
/usr/local/mysql5.7/bin/mysql -u root -p"$MYSQL57_ROOT_PASS" --socket=/usr/local/mysql5.7/data/mysql.sock \
-e"CREATE USER 'wordpress'@'localhost' IDENTIFIED BY '$MYSQL57_WP_PASS'" --connect-expired-password 

/usr/local/mysql5.7/bin/mysql -t -u root --socket=/usr/local/mysql5.7/data/mysql.sock -e"select user, HOST from mysql.user;"

/usr/local/mysql5.7/bin/mysql -u root --socket=/usr/local/mysql5.7/data/mysql.sock -e"show databases;"

#wordpress用データベース作成
/usr/local/mysql5.7/bin/mysql -u root -p"$MYSQL57_ROOT_PASS" --socket=/usr/local/mysql5.7/data/mysql.sock -e"CREATE DATABASE wpdb;"

/usr/local/mysql5.7/bin/mysql -u root --socket=/usr/local/mysql5.7/data/mysql.sock -e"show databases;"

/usr/local/mysql5.7/bin/mysql -u root --socket=/usr/local/mysql5.7/data/mysql.sock -e"show grants for 'wordpress'@'localhost'"

#wordpress用ユーザーにwordpress用データベースの権限を付与
/usr/local/mysql5.7/bin/mysql -u root -p"$MYSQL57_ROOT_PASS" --socket=/usr/local/mysql5.7/data/mysql.sock \
-e"GRANT ALL ON wpdb.* TO wordpress@localhost;"

/usr/local/mysql5.7/bin/mysql -u root --socket=/usr/local/mysql5.7/data/mysql.sock -e"show grants for 'wordpress'@'localhost'"

######################################################################################################################################




#httpd.confバックアップ
cp /usr/local/httpd/httpd-2.4.48/conf/httpd.conf /usr/local/httpd/httpd-2.4.48/conf/httpd.conf.org

#httpd.confの設定
patch -R /usr/local/httpd/httpd-2.4.48/conf/httpd.conf << EOF
82c82
< LoadModule auth_digest_module modules/mod_auth_digest.so
---
> #LoadModule auth_digest_module modules/mod_auth_digest.so
88c88
< LoadModule socache_shmcb_module modules/mod_socache_shmcb.so
---
> #LoadModule socache_shmcb_module modules/mod_socache_shmcb.so
134c134
< LoadModule ssl_module modules/mod_ssl.so
---
> #LoadModule ssl_module modules/mod_ssl.so
153,154c153
< LoadModule rewrite_module modules/mod_rewrite.so
< LoadModule php7_module        modules/libphp7.so
---
> #LoadModule rewrite_module modules/mod_rewrite.so
254c253
<     DirectoryIndex index.html index.php
---
>     DirectoryIndex index.html
279c278
< LogLevel error
---
> LogLevel warn
479c478
< Include conf/extra/httpd-vhosts.conf
---
> #Include conf/extra/httpd-vhosts.conf
496c495
< Include conf/extra/httpd-ssl.conf
---
> #Include conf/extra/httpd-ssl.conf
EOF

diff /usr/local/httpd/httpd-2.4.48/conf/httpd.conf /usr/local/httpd/httpd-2.4.48/conf/httpd.conf.org


#vhostsバックアップ
cp /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf.org

#vhosts設定
patch -R /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf << EOF
23,40c23,29
< <VirtualHost 192.168.56.3:80>
<     DocumentRoot "/var/www/html"
<     ServerName suzuki-t.com
<     RewriteEngine on
<     RewriteCond %{HTTPS} off
<     RewriteRule https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]
<       <Directory "/var/www/html/">
<               Require all granted
<               <FilesMatch \.php$>
<                       SetHandler application/x-httpd-php
<               </FilesMatch>
<       </Directory>
<       <Directory "/var/www/html/wordpress/wp-admin">
<                 AuthType Basic
<                 AuthName "auth"
<                 AuthUserFile /usr/local/httpd/httpd-2.4.48/htpasswd
<               Require valid-user
<       </Directory>
---
> <VirtualHost *:80>
>     ServerAdmin webmaster@dummy-host.example.com
>     DocumentRoot "/usr/local/httpd/httpd-2.4.48/docs/dummy-host.example.com"
>     ServerName dummy-host.example.com
>     ServerAlias www.dummy-host.example.com
>     ErrorLog "logs/dummy-host.example.com-error_log"
>     CustomLog "logs/dummy-host.example.com-access_log" common
43,60c32,37
< <VirtualHost 192.168.56.3:80>
<     DocumentRoot "/var/www/html2"
<     ServerName suzuki-t.net
<     RewriteEngine on
<     RewriteCond %{HTTPS} off
<     RewriteRule https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]
<       <Directory "/var/www/html2/">
<               Require all granted
<               <FilesMatch \.php$>
<                       SetHandler application/x-httpd-php
<               </FilesMatch>
<       </Directory>
<       <Directory "/var/www/html2/wordpress/wp-admin">
<              AuthType Digest
<                AuthName "auth"
<                 AuthUserFile /usr/local/httpd/httpd-2.4.48/htdigestpasswd
<                 Require valid-user
<         </Directory>
---
> <VirtualHost *:80>
>     ServerAdmin webmaster@dummy-host2.example.com
>     DocumentRoot "/usr/local/httpd/httpd-2.4.48/docs/dummy-host2.example.com"
>     ServerName dummy-host2.example.com
>     ErrorLog "logs/dummy-host2.example.com-error_log"
>     CustomLog "logs/dummy-host2.example.com-access_log" common
EOF

diff /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf.org


#ベーシック認証の設定
sh -c "echo 'suzuki:$BASIC_PASS' >>  /usr/local/httpd/httpd-2.4.48/htpasswd"

#ssl化
cd /usr/local/httpd/httpd-2.4.48/conf/

#認証キー作成
sh -c " openssl genrsa 2024 > server.key"

#証明書の署名要求
sh -c "openssl req -new -key server.key -subj '/C=JP/ST=Tokyo/L=shibuya-ku/O=suzuki/CN=suzuki-t.com' > server.csr"

#
sh -c "openssl x509 -req -days 3650 -signkey server.key < server.csr > server.crt"

/usr/local/httpd/httpd-2.4.48/bin/apachectl graceful



#wordpressのインストール##########################################################################################################
#ディレクトリの作成
mkdir /var/www
mkdir /var/www/html

cd /var/www/html

#ダウンロード
curl -LO --url https://ja.wordpress.org/latest-ja.tar.gz

#ファイルの解凍
tar xvf latest-ja.tar.gz -C /var/www/html

#apacheのユーザーに権限を変更
chown -R daemon:daemon wordpress

#ssl設定ファイルのバックアップ
cp /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-ssl.conf /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-ssl.conf.org

#ssl設定
patch -R /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-ssl.conf << EOF
121c121
< <VirtualHost 192.168.56.3:443>
---
> <VirtualHost _default_:443>
124,125c124,125
< DocumentRoot "/var/www/html"
< ServerName suzuki-t.com
---
> DocumentRoot "/usr/local/httpd/httpd-2.4.48/htdocs"
> ServerName www.example.com:443
129,140d128
< <Directory "/var/www/html/">
<     Require all granted
<     <FilesMatch \.php$>
<         SetHandler application/x-httpd-php
<     </FilesMatch>
< </Directory>
< <Directory "/var/www/html/wordpress/wp-admin">
<     AuthType Basic
<     AuthName "auth"
<     AuthUserFile /usr/local/httpd/httpd-2.4.48/htpasswd
<     Require valid-user
< </Directory>
302,323d289
< </VirtualHost>
< <VirtualHost 192.168.56.3:443>
<       DocumentRoot "/var/www/html2"
<       ServerName suzuki-t.net
<       ServerAdmin you@example.com
<       ErrorLog "/usr/local/httpd/httpd-2.4.48/logs/error_log"
<       TransferLog "/usr/local/httpd/httpd-2.4.48/logs/access_log"
<       <Directory "/var/www/html2/">
<               Require all granted
<               <FilesMatch \.php$>
<                       SetHandler application/x-httpd-php
<               </FilesMatch>
<       </Directory>
<       <Directory "/var/www/html2/wordpress/wp-admin">
<               AuthType Digest
<               AuthName "auth"
<               AuthUserFile /usr/local/httpd/httpd-2.4.48/htdigestpasswd
<               Require valid-user
<       </Directory>
<       SSLEngine on
<       SSLCertificateFile "/usr/local/httpd/httpd-2.4.48/conf/server2.crt"
<       SSLCertificateKeyFile "/usr/local/httpd/httpd-2.4.48/conf/server2.key"
EOF


diff /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-ssl.conf /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-ssl.conf.org

################################################################################################################################

#mysql5.6のインストール##########################################################################################################
#ソースコードを置くディレクトリへ
cd /usr/local/src

#ソースコードのダウンロード
curl -L -O --url https://downloads.mysql.com/archives/get/p/23/file/mysql-5.6.46.tar.gz

#ファイルの解凍
tar xvf mysql-5.6.46.tar.gz

#作業ディレクトリへ移動
cd mysql-5.6.46

#Makefileを作成
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql5.6 -DWITH_BOOST=/usr/local/boost -DSYSCONFDIR=/etc/my56.cnf

#Makefikeを元にmake installに必要なファイルをコンパイル
make

#インストール実施
make install

#作業ディレクトリへ
cd /usr/local/mysql5.6

#データディレクトリの初期化
scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql5.6 --datadir=/usr/local/mysql5.6/data

#データディレクトリの権限を変更
chmod 755 /usr/local/mysql5.6/data

cp /usr/local/mysql5.6/my.cnf /usr/local/mysql5.6/my.cnf.bak

#my.cnfを変更
patch -R /usr/local/mysql5.6/my.cnf << EOF
15,19c15,17
< basedir = /usr/local/mysql5.6
< datadir = /usr/local/mysql5.6/data
< port = 3307
< character-set-server=utf8mb4
< collation-server=utf8_general_ci
---
> # basedir = .....
> # datadir = .....
> # port = .....
21c19
< socket = /usr/local/mysql5.6/data/mysql.sock
---
> # socket = .....
EOF

diff /usr/local/mysql5.6/my.cnf /usr/local/mysql5.6/my.cnf.bak


#systemctlで実行できるようプロセス起動用ファイルをinit.dへコピー
cp /usr/local/mysql5.6/support-files/mysql.server /etc/init.d/mysql56

#ststemctlへの反映
systemctl daemon-reload

#mysql5.6起動
systemctl start mysql56

systemctl status mysql56

#mysql5.6自動起動設定
systemctl enable mysql56

systemctl is-enabled mysql56

/usr/local/mysql5.6/bin/mysql -t -u root --socket=/usr/local/mysql5.6/data/mysql.sock -e"select user, HOST from mysql.user;"

#wordpress用ユーザー作成
/usr/local/mysql5.6/bin/mysql -u root --socket=/usr/local/mysql5.6/data/mysql.sock \
-e"CREATE USER 'wordpress'@'localhost' IDENTIFIED BY '$MYSQL56_WP_PASS'"

/usr/local/mysql5.6/bin/mysql -t -u root --socket=/usr/local/mysql5.6/data/mysql.sock -e"select user, HOST from mysql.user;"

/usr/local/mysql5.6/bin/mysql -u root --socket=/usr/local/mysql5.6/data/mysql.sock -e"show databases;"

#wordpress用データベース作成
/usr/local/mysql5.6/bin/mysql -u root --socket=/usr/local/mysql5.6/data/mysql.sock -e"CREATE DATABASE wpdb;"

/usr/local/mysql5.6/bin/mysql -u root --socket=/usr/local/mysql5.6/data/mysql.sock -e"show databases;"

/usr/local/mysql5.6/bin/mysql -u root --socket=/usr/local/mysql5.6/data/mysql.sock -e"show grants for 'wordpress'@'localhost'"

#wordpress用ユーザーにwordpress用データベースの権限を付与
/usr/local/mysql5.6/bin/mysql -u root --socket=/usr/local/mysql5.6/data/mysql.sock -e"GRANT ALL ON wpdb.* TO wordpress@localhost;"

/usr/local/mysql5.6/bin/mysql -u root --socket=/usr/local/mysql5.6/data/mysql.sock -e"show grants for 'wordpress'@'localhost'"

#####################################################################################################################################


#wordpressのインストール
#ディレクトリの作成
mkdir /var/www
mkdir /var/www/html2

cd /var/www/html2

#ダウンロード
curl -LO --url https://ja.wordpress.org/latest-ja.tar.gz

#ファイルの解凍
tar xvf latest-ja.tar.gz -C /var/www/html2

#apacheのユーザーに権限を変更
chown -R daemon:daemon wordpress

#ダイジェスト認証の設定
sh -c "echo 'suzuki:auth:$DIGEST_PASS' >>  /usr/local/httpd/httpd-2.4.48/htdigestpasswd"

cd /usr/local/httpd/httpd-2.4.48/conf/

#ssl認証キーの作成
sudo sh -c " openssl genrsa 2024 > server2.key"

#署名要求
sudo sh -c "openssl req -new -key server2.key -subj '/C=JP/ST=Tokyo/L=shibuya-ku/O=esraku/CN=suzuki-t.net' > server2.csr"

#証明書作成
sh -c "openssl x509 -req -days 3650 -signkey server2.key < server2.csr > server2.crt"



#wordpress設定####################################################################################################################
cd /usr/local/src

#インストール
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

#権限の変更
chmod +x wp-cli.phar

#ファイルの移動
mv wp-cli.phar /usr/local/bin/wp

#確認
wp --info >> /root/work_sh.log

#wordpressのディレクトリへ
cd /var/www/html/wordpress

#設定ファイルの作成
PATH=$PATH:/usr/local/bin /usr/local/bin/wp config create --dbname=wpdb --dbuser=wordpress \
--dbpass=$MYSQL57_WP_PASS --dbhost=localhost:/usr/local/mysql5.7/data/mysql.sock --skip-check --allow-root

diff /var/www/html/wordpress/wp-config.php /var/www/html/wordpress/wp-config-sample.php

#wordpressサイト作成
wp core install --title=suzuki_blog --admin_user=suzuki --admin_password=$WP_USER_COM_PASS \
--admin_email=suzukit@suzuki.jp --allow-root --url='https://suzuki-t.com/wordpress'

#投稿を実施し投稿のIDを取得する
POST_ID="$(wp post create --post_title=test --post_content=test --porcelain  --allow-root)"

#画像を添付する
PATH=$PATH:/usr/local/bin /usr/local/bin/wp media import /root/centOSstart.png --post_id=$POST_ID \
--title=centOS --allow-root --featured_image

#ステータスを公開に変更
wp post update $POST_ID --post_status=publish --allow-root

#作成したファイルの権限変更
chown -R daemon:daemon /var/www/html/wordpress

#wordpress2のディレクトリへ
cd /var/www/html2/wordpress

#設定ファイルの作成
PATH=$PATH:/usr/local/bin /usr/local/bin/wp config create --dbname=wpdb --dbuser=wordpress \
--dbpass=$MYSQL56_WP_PASS --dbhost=localhost:/usr/local/mysql5.6/data/mysql.sock --skip-check --allow-root

diff /var/www/html/wordpress/wp-config.php /var/www/html/wordpress/wp-config-sample.php

#wordpressサイト作成
wp core install --title=suzuki_blog2 --admin_user=suzuki --admin_password=$WP_USER_NET_PASS \
--admin_email=suzukit@suzuki.jp --allow-root --url='https://suzuki-t.net/wordpress' 

#権限の設定
chown -R daemon:daemon /var/www/html2/wordpress

#apache再起動
/usr/local/httpd/httpd-2.4.48/bin/apachectl graceful 2>&1
##################################################################################################################################




#composer#################################################################################
cd /usr/local/src

#ファイルのダウンロード
curl -O https://getcomposer.org/installer

#phpファイルとして実行する為、ファイル名を変更
mv installer composer-setup.php

#実行
php composer-setup.php

#実行用ファイル置き場へ
mv composer.phar /usr/local/bin/composer

#確認 --no-interaction#rootで実行する場合質問がでないようにする(バージョンの確認だけなのでOK)
composer -v --no-interaction
#############################################################################################
