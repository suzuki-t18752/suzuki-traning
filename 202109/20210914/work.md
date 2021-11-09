# mysql

[ダウンロード先](https://dev.mysql.com/downloads/mysql/)

## 1.インストールまで
```
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

```

## 2.設定
```
#作業ディレクトリへ
[suzuki@localhost mysql-5.7.34]$ cd /usr/local/mysql

#mysql用グループの作成
[suzuki@localhost mysql]$ sudo groupadd mysql

#mysql用ユーザーの作成
[suzuki@localhost mysql]$ sudo useradd -m mysql -g mysql

#mysqlユーザーのパスワードを設定
[suzuki@localhost mysql]$ sudo passwd mysql

#パスワード入力を求められるので任意の同じパスワード２回を入力

#データディレクトリを初期化
[suzuki@localhost mysql]$ sudo bin/mysqld --initialize --user=mysql


2021-09-14T08:45:37.207561Z 0 [Warning] TIMESTAMP with implicit DEFAULT value is deprecated. Please use --explicit_defaults_for_timestamp server option (see documentation for more details).
2021-09-14T08:45:37.613722Z 0 [Warning] InnoDB: New log files created, LSN=45790
2021-09-14T08:45:37.685805Z 0 [Warning] InnoDB: Creating foreign key constraint system tables.
2021-09-14T08:45:37.763185Z 0 [Warning] No existing UUID has been found, so we assume that this is the first time that this server has been started. Generating a new UUID: 2231005f-1538-11ec-a1af-080027744419.
2021-09-14T08:45:37.770721Z 0 [Warning] Gtid table is not ready to be used. Table 'mysql.gtid_executed' cannot be opened.
2021-09-14T08:45:39.708191Z 0 [Warning] CA certificate ca.pem is self signed.
2021-09-14T08:45:39.763227Z 1 [Note] A temporary password is generated for root@localhost: XbLpAaBg:0Ng

#root@localhost:以降の文字列をメモしておく

A temporary password is generated for root@localhost: XbLpAaBg:0Ng
```
### データディレクトリ
mysqlサーバーによって管理される情報を格納するディレクトリ

```
#
[suzuki@localhost mysql]$ sudo bin/mysql_ssl_rsa_setup

```
### mysql_ssl_rsa_setup
SSLを使用した安全な接続と、暗号化されていない接続を介したRSAを使用した安全なパスワード交換をサポートするために必要なSSL証明書とキーファイル、およびRSAキーペアファイルを作成する
```

#mysqlを実行する
[suzuki@localhost mysql]$ sudo support-files/mysql.server start

#mysqlへアクセス
[suzuki@localhost mysql]$ bin/mysql -u root -p 

#メモしていたパスワードを入力する
```
[mysql起動時のコマンドの違い](https://monologu.com/mysqld-mysqld_safe-mysql-server-diff/)

```
#サーバー起動時に下記エラーが発生した場合の処理
Starting MySQL.2021-09-15T05:41:24.844605Z mysqld_safe error: log-error set to '/var/log/mariadb/mariadb.log', however file don't exists. Create writable for user 'mysql'.

#ログ用のディレクトリとファイルを作成し、mysqlユーザーに権限を与える
[suzuki@localhost mysql]$ sudo mkdir /var/log/mariadb
[suzuki@localhost mysql]$ sudo touch /var/log/mariadb/mariadb.log
[suzuki@localhost mysql]$ sudo chown mysql:mysql /var/log/mariadb/mariadb.log
[suzuki@localhost mysql]$ sudo chown mysql:mysql /var/log/mariadb

sudo chown mysql /var/log/mariadb/mariadb.log
sudo chown mysql /var/log/mariadb

```
```
#ログイン時に下記エラーが発生した場合

#mysqlの設定ファイルのバックアップをする
[suzuki@localhost mysql]$ sudo cp /etc/my.cnf /etc/my.cnf.org

#mysqlの設定ファイルを編集する
[suzuki@localhost mysql]$ sudo sed -i -e 's%socket=/var/lib/mysql/mysql.sock%socket=/tmp/mysql.sock%g' /etc/my.cnf



[mysqld]
skip-grant-tables
datadir=/var/lib/mysql
socket=/tmp/mysql.sock
#ログインパスワードがわからない時
sed -e '数字i 文字列' ファイル名
#下記を実行し、パスワードなしでログイン、rootユーザーのパスワードを設定する
sudo sed -ie '2i skip-grant-tables' /etc/my.cnf
#パスワード設定後にコメントアウトしておく
sudo sed -i -e 's%skip-grant-tables%#skip-grant-tables%g' /etc/my.cnf
```
















