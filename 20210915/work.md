# 「MySQLのユーザー」suzukiを作成して、mysqldが動いているサーバーからパスワードでmysqlコマンドで接続できるようにする
```
#mysqldを起動
[suzuki@localhost mysql]$ sudo support-files/mysql.server start

#rootユーザーでログイン
[suzuki@localhost mysql]$ bin/mysql -u root -p

#rootユーザーのパスワードを設定する
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'resuraku0901';

#suzukiを作成する
mysql> CREATE USER 'suzuki'@'localhost' IDENTIFIED BY 'resuraku0901';

#rootユーザーを抜ける
mysql> exit;

#suzukiで再度ログインする
[suzuki@localhost mysql]$ bin/mysql -u suzuki -p

#パスワードを入力

#suzukiにてログインできているか確認
mysql> select user(), current_user();
+------------------+------------------+
| user()           | current_user()   |
+------------------+------------------+
| suzuki@localhost | suzuki@localhost |
+------------------+------------------+
1 row in set (0.00 sec)

```

# 「MySQLのユーザー」suzukiを作成して、mysqldが動いていないサーバーからパスワードでmysqlコマンドで接続できるようにする(もう1つのOSから)

[参考](https://itlogs.net/linux-centos-mysql-remote/)

## もう1つのOS用のユーザーを作成する(192.168.56.3)
```
#mysqldを起動
[suzuki@localhost mysql]$ sudo support-files/mysql.server start

#rootユーザーでログイン
[suzuki@localhost mysql]$ bin/mysql -u root -p

#mysqldが動いているサーバーにて外部アクセス可能なアカウントを作成する
mysql> CREATE USER 'suzuki'@'192.168.56.3' IDENTIFIED BY 'resuraku0901';

mysql> select user, host from mysql.user;
+---------------+--------------+
| user          | host         |
+---------------+--------------+
| suzuki        | 192.168.56.3 |
| mysql.session | localhost    |
| mysql.sys     | localhost    |
| root          | localhost    |
| suzuki        | localhost    |
+---------------+--------------+
```
## mysqlのコマンドを使えるようにする
```
#mysqldを動かさないOSへ

#パッケージのインストール
[suzuki@localhost /]$ sudo yum install cmake ncurses-devel zlib-devel libaio-devel openssl-devel gcc-c++ bison

#ソースコードを置くディレクトリへ
[suzuki@localhost /]$ cd /usr/local/src

#ソースコードのダウンロード
[suzuki@localhost src]$ sudo curl -L -O --url https://downloads.mysql.com/archives/get/p/23/file/mysql-5.7.34.tar.gz

#ファイルの解凍
[suzuki@localhost src]$ sudo tar xvf mysql-5.7.34.tar.gz

#作業ディレクトリへ移動
[suzuki@localhost src]$ cd mysql-5.7.34

#Makefileを作成
[suzuki@localhost mysql-5.7.34]$ sudo cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/usr/local/boost

#Makefikeを元にmake installに必要なファイルをコンパイル
[suzuki@localhost mysql-5.7.34]$ sudo make

#インストール実施
[suzuki@localhost mysql-5.7.34]$ sudo make install

#作業ディレクトリへ
[suzuki@localhost mysql-5.7.34]$ cd /usr/local/mysql

#mysql用ユーザーの作成
[suzuki@localhost mysql]$ sudo useradd -m mysql
```

# 実際にmysqlに接続する
```
#mysql -u ユーザー名 -pパスワード -h ホスト名
[suzuki@localhost mysql]$ bin/mysql -u suzuki -presuraku0901 -h 192.168.56.2

実行時に下記エラーが発生した為、firewallの設定を行う
[suzuki@localhost mysql]$ bin/mysql -u suzuki -presuraku0901 -h 192.168.56.2
mysql: [Warning] Using a password on the command line interface can be insecure.
ERROR 2003 (HY000): Can't connect to MySQL server on '192.168.56.2' (113)

```
## firewallの3306番portを解放する(mysql用)
```
#現在の設定内容を確認する
[suzuki@localhost mysql]$ sudo iptables -nL

#ルールを追加する
[suzuki@localhost mysql]$ sudo iptables -A INPUT -p tcp --dport 3306 -j ACCEPT  

#ルールを削除する
[suzuki@localhost mysql]$ sudo iptables -D INPUT -j REJECT --reject-with icmp-host-prohibited

#先ほど削除したルールを再び追加する(最初に追加したルールを優先させる為)
[suzuki@localhost mysql]$ sudo iptables -A INPUT -j REJECT --reject-with icmp-host-prohibited

#変更したルールの保存を行う
[suzuki@localhost mysql]$ sudo /usr/libexec/iptables/iptables.init save

#iptablesの再起動を行い、設定を適用する
[suzuki@localhost mysql]$ systemctl restart iptables

#設定の反映を確認する
[suzuki@localhost mysql]$ sudo iptables -nL

#再度mysqlへアクセスする
[suzuki@localhost mysql]$ bin/mysql -u suzuki -presuraku0901 -h 192.168.56.2
```

### 結果
```
#接続結果
[suzuki@localhost mysql]$ bin/mysql -u suzuki -presuraku0901 -h 192.168.56.2
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 6
Server version: 5.7.34 Source distribution

Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

#MySQLサーバー接続情報表示
mysql> \s
--------------
bin/mysql  Ver 14.14 Distrib 5.7.34, for Linux (x86_64) using  EditLine wrapper

Connection id:          6
Current database:
Current user:           suzuki@192.168.56.3
SSL:                    Cipher in use is DHE-RSA-AES128-GCM-SHA256
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         5.7.34 Source distribution
Protocol version:       10
Connection:             192.168.56.2 via TCP/IP
Server characterset:    latin1
Db     characterset:    latin1
Client characterset:    utf8
Conn.  characterset:    utf8
TCP port:               3306
Uptime:                 3 hours 3 min 23 sec

Threads: 1  Questions: 21  Slow queries: 0  Opens: 112  Flush tables: 1  Open tables: 105  Queries per second avg: 0.001
--------------

mysql>

```

# suzukiユーザーでサンプルDBを作成する https://dev.mysql.com/doc/index-other.html のemployee dataをインポートする

[参考](https://dev.mysql.com/doc/employee/en/employees-installation.html)

```
#
[suzuki@localhost mysql]$ cd

#作業用ディレクトリの作成
[suzuki@localhost ~]$ mkdir mysql_test

#作業用ディレクトリへ移動
[suzuki@localhost ~]$ cd mysql_test

#ファイルのダウンロード
[suzuki@localhost mysql_test]$ sudo curl -L -O --url https://github.com/datacharmer/test_db/archive/refs/heads/master.zip

#解凍の為にunzipパッケージのインストール
[suzuki@localhost mysql_test]$ sudo yum install unzip

#zipファイルの解凍
[suzuki@localhost mysql_test]$ unzip master.zip

#作業ディレクトリへ移動
[suzuki@localhost mysql_test]$ cd test_db-master/
```
## mysql < sqlファイル
/usr/local/mysql/bin/mysql -t < employees.sql -u root -p
ファイル内のsqlコマンドを実行する

## mysql -t
表形式を結果を出力する

## timeコマンド
実行時間の表示
```
#データのインポート
[suzuki@localhost test_db-master]$ /usr/local/mysql/bin/mysql -t < employees.sql -u root -p
Enter password:
+-----------------------------+
| INFO                        |
+-----------------------------+
| CREATING DATABASE STRUCTURE |
+-----------------------------+
+------------------------+
| INFO                   |
+------------------------+
| storage engine: InnoDB |
+------------------------+
+---------------------+
| INFO                |
+---------------------+
| LOADING departments |
+---------------------+
+-------------------+
| INFO              |
+-------------------+
| LOADING employees |
+-------------------+
+------------------+
| INFO             |
+------------------+
| LOADING dept_emp |
+------------------+
+----------------------+
| INFO                 |
+----------------------+
| LOADING dept_manager |
+----------------------+
+----------------+
| INFO           |
+----------------+
| LOADING titles |
+----------------+
+------------------+
| INFO             |
+------------------+
| LOADING salaries |
+------------------+
+---------------------+
| data_load_time_diff |
+---------------------+
| 00:00:36            |
+---------------------+

#データの検証
[suzuki@localhost test_db-master]$ time /usr/local/mysql/bin/mysql -t < test_employees_sha.sql -u root -p
Enter password:
+----------------------+
| INFO                 |
+----------------------+
| TESTING INSTALLATION |
+----------------------+
+--------------+------------------+------------------------------------------+
| table_name   | expected_records | expected_crc                             |
+--------------+------------------+------------------------------------------+
| departments  |                9 | 4b315afa0e35ca6649df897b958345bcb3d2b764 |
| dept_emp     |           331603 | d95ab9fe07df0865f592574b3b33b9c741d9fd1b |
| dept_manager |               24 | 9687a7d6f93ca8847388a42a6d8d93982a841c6c |
| employees    |           300024 | 4d4aa689914d8fd41db7e45c2168e7dcb9697359 |
| salaries     |          2844047 | b5a1785c27d75e33a4173aaa22ccf41ebd7d4a9f |
| titles       |           443308 | d12d5f746b88f07e69b9e36675b6067abb01b60e |
+--------------+------------------+------------------------------------------+
+--------------+------------------+------------------------------------------+
| table_name   | found_records    | found_crc                                |
+--------------+------------------+------------------------------------------+
| departments  |                9 | 4b315afa0e35ca6649df897b958345bcb3d2b764 |
| dept_emp     |           331603 | d95ab9fe07df0865f592574b3b33b9c741d9fd1b |
| dept_manager |               24 | 9687a7d6f93ca8847388a42a6d8d93982a841c6c |
| employees    |           300024 | 4d4aa689914d8fd41db7e45c2168e7dcb9697359 |
| salaries     |          2844047 | b5a1785c27d75e33a4173aaa22ccf41ebd7d4a9f |
| titles       |           443308 | d12d5f746b88f07e69b9e36675b6067abb01b60e |
+--------------+------------------+------------------------------------------+
+--------------+---------------+-----------+
| table_name   | records_match | crc_match |
+--------------+---------------+-----------+
| departments  | OK            | ok        |
| dept_emp     | OK            | ok        |
| dept_manager | OK            | ok        |
| employees    | OK            | ok        |
| salaries     | OK            | ok        |
| titles       | OK            | ok        |
+--------------+---------------+-----------+
+------------------+
| computation_time |
+------------------+
| 00:00:40         |
+------------------+
+---------+--------+
| summary | result |
+---------+--------+
| CRC     | OK     |
| count   | OK     |
+---------+--------+

real    0m43.522s
user    0m0.006s
sys     0m0.005s
[suzuki@localhost test_db-master]$ time /usr/local/mysql/bin/mysql -t < test_employees_md5.sql -u root -p
Enter password:
+----------------------+
| INFO                 |
+----------------------+
| TESTING INSTALLATION |
+----------------------+
+--------------+------------------+----------------------------------+
| table_name   | expected_records | expected_crc                     |
+--------------+------------------+----------------------------------+
| departments  |                9 | d1af5e170d2d1591d776d5638d71fc5f |
| dept_emp     |           331603 | ccf6fe516f990bdaa49713fc478701b7 |
| dept_manager |               24 | 8720e2f0853ac9096b689c14664f847e |
| employees    |           300024 | 4ec56ab5ba37218d187cf6ab09ce1aa1 |
| salaries     |          2844047 | fd220654e95aea1b169624ffe3fca934 |
| titles       |           443308 | bfa016c472df68e70a03facafa1bc0a8 |
+--------------+------------------+----------------------------------+
+--------------+------------------+----------------------------------+
| table_name   | found_records    | found_crc                        |
+--------------+------------------+----------------------------------+
| departments  |                9 | d1af5e170d2d1591d776d5638d71fc5f |
| dept_emp     |           331603 | ccf6fe516f990bdaa49713fc478701b7 |
| dept_manager |               24 | 8720e2f0853ac9096b689c14664f847e |
| employees    |           300024 | 4ec56ab5ba37218d187cf6ab09ce1aa1 |
| salaries     |          2844047 | fd220654e95aea1b169624ffe3fca934 |
| titles       |           443308 | bfa016c472df68e70a03facafa1bc0a8 |
+--------------+------------------+----------------------------------+
+--------------+---------------+-----------+
| table_name   | records_match | crc_match |
+--------------+---------------+-----------+
| departments  | OK            | ok        |
| dept_emp     | OK            | ok        |
| dept_manager | OK            | ok        |
| employees    | OK            | ok        |
| salaries     | OK            | ok        |
| titles       | OK            | ok        |
+--------------+---------------+-----------+
+------------------+
| computation_time |
+------------------+
| 00:00:40         |
+------------------+
+---------+--------+
| summary | result |
+---------+--------+
| CRC     | OK     |
| count   | OK     |
+---------+--------+

real    0m43.667s
user    0m0.004s
sys     0m0.006s

```

# php
[参考](https://www.php.net/manual/ja/install.unix.php)

## インストールまで
```
#ソースコードをダウンロードするディレクトリへ
[suzuki@localhost ~]$ cd /usr/local/src

#ソースコードのダウンロード
[suzuki@localhost src]$ sudo curl -LO --url https://www.php.net/distributions/php-7.4.23.tar.gz

#ファイルの解凍
[suzuki@localhost src]$ sudo tar xvf php-7.4.23.tar.gz

#作業ディレクトリへ
[suzuki@localhost src]$ cd php-7.4.23

#Makefileの作成
[suzuki@localhost php-7.4.23]$ sudo ./configure --with-apxs2=/usr/local/httpd/httpd-2.4.48/bin/apxs --with-pdo-mysql=/usr/local/mysql

#インストールに必要なファイルのコンパイル
[suzuki@localhost php-7.4.23]$ sudo make

#インストールの実施
[suzuki@localhost php-7.4.23]$ sudo make install

#設定ファイルを作成する
[suzuki@localhost php-7.4.23]$ sudo cp php.ini-development /usr/local/lib/php.ini

#インストールされたもの
Installing shared extensions:     /usr/local/lib/php/extensions/no-debug-zts-20190902/
Installing PHP CLI binary:        /usr/local/bin/
Installing PHP CLI man page:      /usr/local/php/man/man1/
Installing phpdbg binary:         /usr/local/bin/
Installing phpdbg man page:       /usr/local/php/man/man1/
Installing PHP CGI binary:        /usr/local/bin/
Installing PHP CGI man page:      /usr/local/php/man/man1/
Installing build environment:     /usr/local/lib/php/build/
Installing header files:          /usr/local/include/php/
Installing helper programs:       /usr/local/bin/
  program: phpize
  program: php-config
Installing man pages:             /usr/local/php/man/man1/
  page: phpize.1
  page: php-config.1
/usr/local/src/php-7.4.23/build/shtool install -c ext/phar/phar.phar /usr/local/bin/phar.phar
ln -s -f phar.phar /usr/local/bin/phar
Installing PDO headers:           /usr/local/include/php/ext/pdo/

#確認
[suzuki@localhost php-7.4.23]$ php -v
PHP 7.4.23 (cli) (built: Sep 16 2021 11:15:12) ( ZTS )
Copyright (c) The PHP Group
Zend Engine v3.4.0, Copyright (c) Zend Technologies

```


### ./configure実行時のエラー
1. apacheのインストール前にperlをインストールしていないと下記エラーが発生する
- perlのパスが違うから
```
Configuring SAPI modules
checking for Apache 2 handler module support via DSO through APXS...

Sorry, I cannot run apxs.  Possible reasons follow:

1. Perl is not installed
2. apxs was not found. Try to pass the path using --with-apxs2=/path/to/apxs
3. Apache was not built using --enable-so (the apxs usage page is displayed)

#下記コマンドを実行
sudo sed -i -e 's%#!/replace/with/path/to/perl/interpreter -w%#!/usr/bin/perl -w%g' /usr/local/httpd/httpd-2.4.48/bin/apxs
```
2. パッケージの未インストール libxml2-devel
```
configure: error: Package requirements (libxml-2.0 >= 2.7.6) were not met:

No package 'libxml-2.0' found

Consider adjusting the PKG_CONFIG_PATH environment variable if you
installed software in a non-standard prefix.

#下記コマンドを実行
[suzuki@localhost php-7.4.23]$ sudo yum install libxml2-devel

```

3. パッケージの未インストール sqlite

```
configure: error: Package requirements (sqlite3 > 3.7.4) were not met:

No package 'sqlite3' found

Consider adjusting the PKG_CONFIG_PATH environment variable if you
installed software in a non-standard prefix.

Alternatively, you may set the environment variables SQLITE_CFLAGS
and SQLITE_LIBS to avoid the need to call pkg-config.
See the pkg-config man page for more details.

[suzuki@localhost php-7.4.23]$ sudo yum install sqlite-devel
```

