# apache

## 1. APRのダウンロード、インストール

### APRのダウンロード、インストール手順

```
#[suzuki@localhost ~]$ sudo yum install gcc make pcre-devel expat-devel

# ファイルを置くディレクトリへ移動
[suzuki@localhost ~]$ cd /usr/local/src

#ファイルのダウンロードする
[suzuki@localhost src]$ sudo curl -O --url https://dlcdn.apache.org//apr/apr-1.7.0.tar.gz

#ファイルを解凍
[suzuki@localhost src]$ sudo tar xvf apr-1.7.0.tar.gz

#作業ディレクトリへ移動
[suzuki@localhost src]$ cd apr-1.7.0

#Makefileを作成
[suzuki@localhost apr-1.7.0]$ sudo ./configure --prefix=/usr/local/apr/apr-1.7.0

#Makefikeを元にmake installに必要なファイルをコンパイル
[suzuki@localhost apr-1.7.0]$ sudo make

#インストール実施
[suzuki@localhost apr-1.7.0]$ sudo make install
```

### apr-utilのダウンロード、インストール手順  
```
#ファイルを置くディレクトリへ移動
[suzuki@localhost apr-1.7.0]$ cd /usr/local/src

#ファイルのダウンロードする
[suzuki@localhost src]$ sudo curl -O --url https://dlcdn.apache.org//apr/apr-util-1.6.1.tar.gz

#ファイルを解凍
[suzuki@localhost src]$ sudo tar xvf apr-util-1.6.1.tar.gz

#作業ディレクトリへ移動
[suzuki@localhost src]$ cd apr-util-1.6.1

#Makefileを作成
[suzuki@localhost apr-util-1.6.1]$ sudo ./configure --prefix=/usr/local/apr-util/apr-util-1.6.1 --with-apr=/usr/local/apr/apr-1.7.0

#Makefikeを元にmake installに必要なファイルをコンパイル
[suzuki@localhost apr-util-1.6.1]$ sudo make

#インストール実施
[suzuki@localhost apr-util-1.6.1]$ sudo make install
```

## 2. apacheのダウンロード、インストール手順
```
#ファイルを置くディレクトリへ移動
[suzuki@localhost apr-util-1.6.1]$ cd /usr/local/src

#ファイルのダウンロードする
[suzuki@localhost src]$ sudo curl -O --url https://dlcdn.apache.org//httpd/httpd-2.4.48.tar.gz

#ファイルを解凍する
[suzuki@localhost src]$ sudo tar xvf httpd-2.4.48.tar.gz

#作業ディレクトリへ移動
[suzuki@localhost apr-util-1.6.1]$ cd /usr/local/src/httpd-2.4.48

#Makefileを作成
[suzuki@localhost httpd-2.4.48]$ sudo ./configure --prefix=/usr/local/httpd/httpd-2.4.48 --with-apr=/usr/local/apr/apr-1.7.0 --with-apr-util=/usr/local/apr-util/apr-util-1.6.1

#Makefikeを元にmake installに必要なファイルをコンパイル
[suzuki@localhost httpd-2.4.48]$ sudo make

#インストール実施
[suzuki@localhost httpd-2.4.48]$ sudo make install
```
## 4. apacheの起動、確認
```
#apacheを起動する
[suzuki@localhost httpd-2.4.48]$ sudo /usr/local/httpd/httpd-2.4.48/bin/apachectl start 

#ブラウザにて　192.168.56.2 (仮想環境のipアドレス)を入力する

#ログの確認をする
[suzuki@localhost src]$ sudo find /usr/local/httpd/httpd-2.4.48/ -name "*log" -type f
/usr/local/httpd/httpd-2.4.48/logs/error_log
/usr/local/httpd/httpd-2.4.48/logs/access_log

#access_logを確認
[suzuki@localhost src]$ less /usr/local/httpd/httpd-2.4.48/logs/access_log

192.168.56.1 - - [07/Sep/2021:10:28:48 +0900] "GET /favicon.ico HTTP/1.1" 404 196
192.168.56.1 - - [07/Sep/2021:10:29:39 +0900] "-" 408 -
192.168.56.1 - - [07/Sep/2021:10:56:45 +0900] "GET / HTTP/1.1" 200 45
192.168.56.1 - - [07/Sep/2021:11:57:47 +0900] "GET / HTTP/1.1" 200 45

リソース部分(GET / HTTP/1.1)の後ろのステータスが200なので正常に実行されている
```
[ログの見方](https://webllica.com/apache-web-server-log-analyze/)

# suzuki.comでHello Worldを表示する

## バーチャルホスト
### 概要
バーチャルホストという用語は、1 台のマシン上で (www.company1.com and www.company2.com のような) 二つ以上のウェブサイトを扱う運用方法のこと

### 作業
```
#設定ファイルのバックアップをする

#httpd.conf(apacheの設定ファイル)を編集する
[suzuki@localhost local]$ sudo vi /usr/local/httpd/httpd-2.4.48/conf/httpd.conf

#コメントアウトを外す
Include /conf/extra/httpd-vhosts.conf

#ファイルを閉じる
:wq
enter

#設定ファイルのバックアップをする

#httpd-vhosts.conf(virtualhostの設定ファイル)を編集する
[suzuki@localhost local]$ sudo vi /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf

#下記のように<VirtualHost *:80>を編集
<VirtualHost *:80>
  DocumentRoot "/var/www/html"
  ServerName suzuki.com

    <Directory "/var/www/html">
         Require all granted
    </Directory>
</VirtualHost>
```
### Require all granted [参考](https://www.javadrive.jp/apache/allow/index1.html)
ディレクトリのアクセス制限を設定していてこの場合は全て許可する設定  

```
#ファイルを閉じる
:wq
enter

#/etc/hosts(ホスト名とIPアドレスの対応付けを書いておくファイル)を編集する
[suzuki@localhost /]$ sudo vi /etc/hosts

#下記を追記する
192.168.56.2    suzuki.com

# C:\Windows\System32\drivers\etc内のhostファイルの編集し、下記を入力する
192.168.56.2    suzuki.com

#表示するファイルとドキュメントルートのディレクトリを作成する
[suzuki@localhost /]$ sudo mkdir /var/www
[suzuki@localhost /]$ sudo mkdir /var/www/html
[suzuki@localhost /]$ sudo touch /var/www/html/index.html

#下記を入力する
<html><h1>Hello Wrold</h1></html>

#ファイルを閉じる
:wq
enter

#apacheを再起動する
[suzuki@localhost /]$ sudo /usr/local/httpd/httpd-2.4.48/bin/apachectl restart

#access_logを確認
[suzuki@localhost /]$ less /usr/local/httpd/httpd-2.4.48/logs/access_log

192.168.56.1 - - [07/Sep/2021:16:46:10 +0900] "GET / HTTP/1.1" 200 37
192.168.56.1 - - [07/Sep/2021:16:47:01 +0900] "-" 408 -
192.168.56.1 - - [07/Sep/2021:16:47:54 +0900] "-" 408 -
192.168.56.1 - - [07/Sep/2021:16:48:52 +0900] "-" 408 -
192.168.56.1 - - [07/Sep/2021:16:48:52 +0900] "-" 408 -
192.168.56.1 - - [07/Sep/2021:16:49:18 +0900] "-" 408 -
192.168.56.1 - - [07/Sep/2021:16:50:11 +0900] "-" 408 -
192.168.56.1 - - [07/Sep/2021:16:50:16 +0900] "GET / HTTP/1.1" 200 37

リソース部分(GET / HTTP/1.1)の後ろのステータスが200なので正常に実行されている

#ブラウザにてsuzuki.comを入力し、Hello Worldの表示を確認
```
