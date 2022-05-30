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
[suzuki@localhost php-7.4.23]$ sudo ./configure --with-apxs2=/usr/local/httpd/httpd-2.4.48/bin/apxs --with-pdo-mysql --with-mysqli --with-curl --enable-exif --enable-mbstring --with-openssl-dir=/usr/bin --with-sodium  --enable-bcmath --enable-gd --enable-intl --enable-ftp --enable-sockets --with-zlib
```
### apxs
apxsとは「APache eXtenSion tool」
Apacheの拡張モジュールをビルドしてインストールするためのツールです。
後から拡張モジュールを組み込んだり、モジュールだけ再コンパイルして入れ直したりすることができます。
DSOサポートが有効になっている必要があります。

- 有効かの確認方法　httpd -l
Compiled in modules:
  core.c
  prefork.c
  http_core.c
  mod_so.c
→core.c、mod_so.cがあればOK


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

```
#インストールに必要なファイルのコンパイル
[suzuki@localhost php-7.4.23]$ sudo make

#インストールの実施
[suzuki@localhost php-7.4.23]$ sudo make install

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

#設定ファイルを作成する
[suzuki@localhost php-7.4.23]$ sudo cp php.ini-development /usr/local/lib/php.ini

#確認
[suzuki@localhost php-7.4.23]$ php -v
PHP 7.4.23 (cli) (built: Sep 16 2021 11:15:12) ( ZTS )
Copyright (c) The PHP Group
Zend Engine v3.4.0, Copyright (c) Zend Technologies

#設定ファイルのバックアップ
[suzuki@localhost php-7.4.23]$ sudo cp /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf.org2

#phpを実行できるよう設定ファイルを編集する
[suzuki@localhost php-7.4.23]$ sudo vi /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf

#before
<VirtualHost 192.168.56.2:80>
  DocumentRoot "/var/www/html"
  ServerName suzuki-t.com

    <Directory "/var/www/html">
         Require all granted
    </Directory>
    <Directory "/var/www/html/true">
         Require all granted
    </Directory>
    <Directory "/var/www/html/false">
         Require all denied
    </Directory>
</VirtualHost>

#after
<VirtualHost 192.168.56.2:80>
  DocumentRoot "/var/www/html"
  ServerName suzuki-t.com

    <Directory "/var/www/html">
         Require all granted
         <FilesMatch \.php$>
             SetHandler application/x-httpd-php
         </FilesMatch>
    </Directory>
    <Directory "/var/www/html/true">
         Require all granted
    </Directory>
    <Directory "/var/www/html/false">
         Require all denied
    </Directory>
</VirtualHost>

#apacheを再起動して設定を反映する
[suzuki@os1 ~]$ sudo /usr/local/httpd/httpd-2.4.48/bin/apachectl graceful

#画面確認用ファイルを作成
[suzuki@os1 ~]$ sudo sh -c "echo '<?php echo phpinfo(); ?>' >> /var/www/html/index.php"
```
### shコマンドを使ってリダイレクションする理由
sudoコマンドでechoの処理はroot権限で行われるがリダイレクションに関しては一般ユーザーで行われる為
```
#表示の確認
```
![確認画面](./php_view.png)


# wordpress

```
#ソースコードをダウンロードするディレクトリへ
[suzuki@os1 ~]$ cd /var/www/html

#ソースコードのダウンロード
[suzuki@os1 ~]$ curl -LO --url https://ja.wordpress.org/latest-ja.tar.gz

#ファイルの解凍
[suzuki@os1 ~]$ sudo tar xvf latest-ja.tar.gz -C /var/www/html

#apacheに設定されているユーザーをグループを確認する
[suzuki@os1 html]$ less /usr/local/httpd/httpd-2.4.48/conf/httpd.conf
User daemon
Group daemon

#権限を変更する
sudo chown -R daemon:daemon wordpress

#作業ディレクトリへ
[suzuki@os1 ~]$ cd /var/www/html/wordpress

#sqlへ
[suzuki@os1 html]$ /usr/local/mysql/bin/mysql -u root -p

#wordpress用のDB作成
mysql> CREATE DATABASE wpdb;

#suzukiにwpdbの権限を付与
mysql> GRANT ALL ON wpdb.* TO suzuki@localhost;

#権限の確認
mysql> show grants for suzuki@localhost;

#before
+----------------------------------------------------------+
| Grants for suzuki@localhost                              |
+----------------------------------------------------------+
| GRANT USAGE ON *.* TO 'suzuki'@'localhost'               |
+----------------------------------------------------------+

#after
+----------------------------------------------------------+
| Grants for suzuki@localhost                              |
+----------------------------------------------------------+
| GRANT USAGE ON *.* TO 'suzuki'@'localhost'               |
| GRANT ALL PRIVILEGES ON `wpdb`.* TO 'suzuki'@'localhost' |
+----------------------------------------------------------+

```

## ファイル名まで入れないとページが表示されない
- httpd.conf内のDirectoryIndexにindex.phpを追加(トップページを探しに行く設定)
sudo sed -i -e 's%DirectoryIndex index.html%DirectoryIndex index.html index.php%g' /usr/local/httpd/httpd-2.4.48/conf/httpd.conf

## パッケージの未インストール
No package 'libcurl' found
No package 'libpng' found
No package 'icu-uc' found
No package 'icu-io' found
No package 'icu-i18n' found
No package 'libsodium' found

[suzuki@os1 php-7.4.23]$ sudo yum install libcurl-devel libpng-devel libicu-devel libsodium-devel

- onigurumaのみパッケージがなかった為、
No package 'oniguruma' found
[remiリポジトリについて](https://qiita.com/charon/items/6d34ae798e9b05e8bd0a)

[suzuki@os1 php-7.4.23]$ sudo yum install http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

[suzuki@os1 php-7.4.23]$ sudo yum install oniguruma-devel





## urlの変更(ipアドレス→ドメイン名)
メニューより設定を選択し、wordpressアドレスとサイトアドレスの項目を変更する

### 設定項目はwp_optionテーブルに格納されている
```
mysql> select * from wp_options WHERE option_name in("siteurl","home");
+-----------+-------------+-------------------------------+----------+
| option_id | option_name | option_value                  | autoload |
+-----------+-------------+-------------------------------+----------+
|         2 | home        | http://suzuki-t.com/wordpress | yes      |
|         1 | siteurl     | http://suzuki-t.com/wordpress | yes      |
+-----------+-------------+-------------------------------+----------+
2 rows in set (0.00 sec)
```
## 容量を超えた画像をアップロードできるようにする
[参考](https://kinsta.com/jp/blog/increase-max-upload-size-wordpress/)

- php.ini(php全体の容量をあげる)
```
#設定ファイルのバックアップ
[suzuki@os1 wordpress]$ sudo cp /usr/local/lib/php.ini /usr/local/lib/php.ini.bak_20210917

#ファイルの編集
[suzuki@os1 wordpress]$ sudo sed -i -e 's%upload_max_filesize = 2M%upload_max_filesize = 32M%g' /usr/local/lib/php.ini
[suzuki@os1 wordpress]$ sudo sed -i -e 's%post_max_size = 8M%post_max_size = 64M%g' /usr/local/lib/php.ini

upload_max_filesize = 2M
upload_max_filesize = 32M

post_max_size = 8M
post_max_size = 64M

memory_limit = 128M

[suzuki@os1 wordpress]$ diff -i /usr/local/lib/php.ini.bak_20210917 /usr/local/lib/php.ini
694c694
< post_max_size = 8M
---
> post_max_size = 64M
846c846
< upload_max_filesize = 2M
---
> upload_max_filesize = 32M

#設定の反映
[suzuki@os1 ~]$ sudo /usr/local/httpd/httpd-2.4.48/bin/apachectl graceful
```

## DBのバックアップ
### mysqldump - a database backup program
```
#バックアップ用ディレクトリ作成
[suzuki@os1 wordpress]$ mkdir /home/suzuki/wpdb_bak

#バックアップの実施
[suzuki@os1 wordpress]$ sudo /usr/local/mysql/bin/mysqldump --single-transaction -u suzuki -p wpdb > /home/suzuki/wpdb_bak/wpdb_bak_20210917.dump

#ファイルの確認
[suzuki@os1 wordpress]$ ls -l /home/suzuki/wpdb_bak/
合計 444
-rw-rw-r--. 1 suzuki suzuki 450641  9月 17 17:21 wpdb_bak_20210917.dump

```

## SSL
SSL（Secure Sockets Layer）とは、インターネット上におけるウェブブラウザとウェブサーバ間でのデータの通信を暗号化し、送受信させる仕組みのこと
ウェブサイトでSSL(https)を利用する場合、通信の暗号化に必要な鍵とウェブサイトの運営者の情報が含まれた「SSLサーバ証明書」を、サーバにインストールする必要があります。

### SSLサーバ証明書
SSLサーバ証明書は、ウェブサイトの「運営者の実在性を確認」し、ブラウザとウェブサーバ間で「通信データの暗号化」を行うための電子証明書で、GMOグローバルサインなどの認証局から発行されます。
SSLサーバ証明書には、ウェブサイトの所有者の情報や、暗号化通信に必要な鍵、発行者の署名データが含まれています。
SSLサーバ証明書に含まれる2つの鍵(共通鍵暗号方式・公開鍵暗号方式)によって、ブラウザ⇔サーバ間で送受信される個人情報や決済情報などの通信データを暗号化することができます

- SSLサーバ証明書の種類
1. ドメイン認証  

ウェブサイトのドメインの使用権を所有していることを認証します。
組織の実在性は確認しないため、登記簿謄本などの提出は不要、個人事業主の方でも証明書の申請が可能です。

2. 企業実在認証

ウェブサイトのドメインの使用権の所有の他、その運営組織が法的に実在すること認証します。
第三者データベースに照会の上確認し、さらに申し込みの意思を確認の上証明書が発行されます。

3. EV認証

世界標準のガイドラインに沿って、ドメインの使用権の他、その運営組織の法的・物理的実在性を第三者データベースに照会の上確認し、さらに申し込みの意思と権限を確認の上証明書が発行されます。

### 設定(今回は自己証明書にて行う)
[参考](https://weblabo.oscasierra.net/openssl-gencert-1/)
```
#SSL秘密鍵用のディレクトリ作成
[suzuki@os1 wordpress]$ mkdir /home/suzuki/ssl

[suzuki@os1 ssl]$ cd /home/suzuki/ssl

#秘密鍵の作成
[suzuki@os1 ssl]$ openssl genrsa 2024 > server.key

#証明書署名要求(CSR / Certificate Signing Request)の作成
[suzuki@os1 ssl]$ openssl req -new -key server.key > server.csr

```
###  証明書署名要求
認証局にサーバの公開鍵に電子署名してもらうよう要求するメッセージです。 (本稿では自己証明書を作成する為、認証局も自分自身ということになります) OpenSSL で証明書署名要求を作成するには openssl req コマンドを実行します

### サーバ証明書の作成
普通であれば上で作成した証明書署名要求 (server.csr) を VeriSign などの機関に送付して認証局の秘密鍵で署名してもらいます。

今回は自分で署名することでサーバ証明書を作成しますので上で作成した自分の秘密鍵 (server.key) で署名します。 サーバ証明書に署名するには openssl x509 コマンドを実行します。 今回は証明書の有効期限が10年(3650日)ある証明書を作成します。

```
#サーバ証明書の作成
[suzuki@os1 ssl]$ openssl x509 -req -days 3650 -signkey server.key < server.csr > server.crt

#設定ファイルのコピー
[suzuki@os1 ssl]$ sudo cp /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-ssl.conf /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-ssl.conf.bak_20210917

#設定ファイルの変更
[suzuki@os1 ssl]$ sudo sed -i -e 's%SSLCertificateFile "/usr/local/httpd/httpd-2.4.48/conf/server.crt"%SSLCertificateFile "/home/susuki/ssl/server.crt"%g' /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-ssl.conf

[suzuki@os1 ssl]$ sudo sed -i -e 's%SSLCertificateKeyFile "/usr/local/httpd/httpd-2.4.48/conf/server.key"%SSLCertificateKeyFile "/home/suzuki/ssl/server.key"%g' /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-ssl.conf

[suzuki@os1 ssl]$ diff -i /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-ssl.conf /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-ssl.conf.bak_20210917
144c144
< SSLCertificateFile "/home/susuki/ssl/server.crt"
---
> SSLCertificateFile "/usr/local/httpd/httpd-2.4.48/conf/server.crt"
154c154
< SSLCertificateKeyFile "/home/suzuki/ssl/server.key"
---
> SSLCertificateKeyFile "/usr/local/httpd/httpd-2.4.48/conf/server.key"

#
[suzuki@os1 ssl]$ sudo /usr/local/httpd/httpd-2.4.48/bin/apachectl graceful

```
