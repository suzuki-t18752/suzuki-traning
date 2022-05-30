# プロキシの設定をする

[参考](https://httpd.apache.org/docs/2.4/en/mod/mod_proxy.html#proxyrequests)
```
#apacheの設定ファイル内のコメントアウトを外す
[suzuki@localhost ~]$ sudo sed -i -e 's/#LoadModule proxy_module/LoadModule proxy_module/g' /usr/local/httpd/httpd-2.4.48/conf/httpd.conf
[suzuki@localhost ~]$ sudo sed -i -e 's/#LoadModule proxy_http_module/LoadModule proxy_http_module/g' /usr/local/httpd/httpd-2.4.48/conf/httpd.conf

#apacheの設定ファイルに追記
[suzuki@localhost /]$ sudo sh -c "echo ProxyPass \'/true\' \'http://suzuki-t.jp\' >> /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf"
[suzuki@localhost /]$ sudo sh -c "echo ProxyPassReverse \'/true\' \'http://suzuki-t.jp\' >> /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf"
```


# mysql

[ダウンロード先](https://dev.mysql.com/downloads/mysql/)

## 1.インストールまで
```
#パッケージのインストール
[suzuki@localhost /]$ sudo yum install cmake ncurses-devel zlib-devel libaio-devel

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
```
### データディレクトリ
mysqlサーバーによって管理される情報を格納するディレクトリ

```


```