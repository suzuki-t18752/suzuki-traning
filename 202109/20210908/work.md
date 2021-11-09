## バーチャルホスト
### 概要
バーチャルホストという用語は、1 台のマシン上で (www.company1.com and www.company2.com のような) 二つ以上のウェブサイトを扱う運用方法のこと

### 作業
```
#設定ファイルのバックアップをする
[suzuki@localhost /]$ sudo cp /usr/local/httpd/httpd-2.4.48/conf/httpd.conf /usr/local/httpd/httpd-2.4.48/conf/httpd.conf.org

#httpd.conf(apacheの設定ファイル)を編集する
[suzuki@localhost /]$ sudo vi /usr/local/httpd/httpd-2.4.48/conf/httpd.conf

#コメントアウトを外す
Include /conf/extra/httpd-vhosts.conf

#ファイルを閉じる
:wq
enter

#設定ファイルのバックアップをする
[suzuki@localhost /]$ sudo cp /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf.org

#httpd-vhosts.conf(virtualhostの設定ファイル)を編集する
[suzuki@localhost /]$ sudo vi /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf

#下記のように編集
Listen 443

NameVirtualHost 192.168.56.2:80
NameVirtualHost 192.168.56.2:443

<VirtualHost 192.168.56.2:80>
  DocumentRoot "/var/www/html"
  ServerName suzuki-t.com

    <Directory "/var/www/html">
         Require all granted
    </Directory>
</VirtualHost>

<VirtualHost 192.168.56.2:443>
  DocumentRoot "/var/www/html443"
  ServerName suzuki-t.com

    <Directory "/var/www/html443">
         Require all granted
    </Directory>
</VirtualHost>

<VirtualHost 192.168.56.2:80>
  DocumentRoot "/var/www/htmlu"
  ServerName suzuki-u.com

    <Directory "/var/www/htmlu">
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
192.168.56.2    suzuki-t.com
192.168.56.2    suzuki-u.com

# C:\Windows\System32\drivers\etc内のhostファイルの編集し、下記を入力する
192.168.56.2    suzuki-t.com
192.168.56.2    suzuki-u.com

#表示するファイルとドキュメントルートのディレクトリを作成する
[suzuki@localhost /]$ sudo mkdir /var/www
[suzuki@localhost /]$ sudo mkdir /var/www/html
[suzuki@localhost /]$ sudo touch /var/www/html/index.html

#下記を入力する
<html><h1>Hello Wrold</h1></html>

#ファイルを閉じる
:wq
enter

#表示するファイルとドキュメントルートのディレクトリを作成する(port443用)
[suzuki@localhost /]$ sudo mkdir /var/www/html443
[suzuki@localhost /]$ sudo touch /var/www/html443/index.html
[suzuki@localhost /]$ sudo vi /var/www/html443/index.html

#下記を入力する
<html><h1>Hello Wrold port443</h1></html>

#ファイルを閉じる
:wq
enter

#表示するファイルとドキュメントルートのディレクトリを作成する(suzuki-uドメイン用)
[suzuki@localhost /]$ sudo mkdir /var/www/htmlu
[suzuki@localhost /]$ sudo touch /var/www/htmlu/index.html
[suzuki@localhost /]$ sudo vi /var/www/htmlu/index.html

#下記を入力する
<html><h1>Hello Wrold domain-u</h1></html>

#ファイルを閉じる
:wq
enter

#シンタックスのチェックを行う
[suzuki@localhost /]$ sudo /usr/local/httpd/httpd-2.4.48/bin/apachectl -t

#apacheを再起動する
[suzuki@localhost /]$ sudo /usr/local/httpd/httpd-2.4.48/bin/apachectl graceful

#access_logを確認
[suzuki@localhost /]$ tail -f /usr/local/httpd/httpd-2.4.48/logs/access_log

#ブラウザにてipアドレスやドメイン名を入力し、表示を確認

リソース部分(GET / HTTP/1.1)の後ろのステータスが200や304なら正常に実行されている
```

## アクセスできるディレクトリとアクセスできないディレクトリを設定する

[参考](https://httpd.apache.org/docs/2.2/ja/vhosts/examples.html)
```
#httpd-vhosts.conf(virtualhostの設定ファイル)を編集する
[suzuki@localhost /]$ sudo vi /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf

#下記を<VirtualHost 192.168.56.2:80>内に追記する
<Directory "/var/www/html/true">
         Require all granted
</Directory>
<Directory "/var/www/html/false">
      Require all denied
</Directory>

#ファイルを閉じる
:wq
enter

#ディレクトリとファイルを作成する
[suzuki@localhost /]$ sudo mkdir /var/www/html/true
[suzuki@localhost /]$ sudo mkdir /var/www/html/false
[suzuki@localhost /]$ sudo touch /var/www/html/false/index.html
[suzuki@localhost /]$ sudo touch /var/www/html/true/index.html

[suzuki@localhost /]$ sudo vi /var/www/html/true/index.html

#下記を入力する
<html><h1>true</h1></html>

#ファイルを閉じる
:wq
enter

#シンタックスのチェックを行う
[suzuki@localhost /]$ sudo /usr/local/httpd/httpd-2.4.48/bin/apachectl -t

#apacheを再起動する
[suzuki@localhost /]$ sudo /usr/local/httpd/httpd-2.4.48/bin/apachectl graceful

#access_logを確認
[suzuki@localhost /]$ tail -f /usr/local/httpd/httpd-2.4.48/logs/access_log

#ブラウザにてipアドレスやドメイン名を入力し、表示を確認

true:リソース部分(GET / HTTP/1.1)の後ろのステータスが200や304なら正常に実行されている
false:リソース部分(GET / HTTP/1.1)の後ろのステータスが403なら正常に設定出来ている
```

### ベーシック認証を入れる

- 概要  
Webサイトの閲覧に使うプロトコル「HTTP」が備える、最も基本的なユーザ認証方式。 アクセスの制限されたWebページにアクセスしようとすると、Webブラウザでユーザ名とパスワードの入力を求め、サーバでアクセスを許可しているユーザに一致すると、ページを閲覧することができる

[参考](https://pointsandlines.jp/server-infra/basic-authorize)
```
#認証用のユーザーとパスワードを設定する
[suzuki@localhost /]$ sudo /usr/local/httpd/httpd-2.4.48/bin/htpasswd -c /usr/local/httpd/httpd-2.4.48/htpasswd suzuki
コマンド入力後任意のパスワードを2回入力する

#バーチャルホストの設定ファイルを編集する
[suzuki@localhost /]$ sudo vi /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf

#下記を<VirtualHost 192.168.56.2:443>内に追記する
<Directory "/var/www/html443/basic">
  AuthType Basic
  AuthName "auth"
  AuthUserFile /usr/local/httpd/httpd-2.4.48/htpasswd
  Require valid-user
</Directory>
```
- 設定内容について  
AuthType（認証の種類）Basicと記述

AuthName（ダイアログメッセージに※表示する名前）（任意）※Google Chrome、Safariには表示されませんが正しく動作させるために必要

AuthUserFile（パスワードファイル）htpasswdコマンドで作成したパスワードファイルのファイル名をパスから記述

Require（認証するユーザ）「valid-user」でパスワードファイルに記述された全ユーザが対象となる
```
#ファイルを閉じる
:wq
enter

ディレクトリとファイルを作成する
[suzuki@localhost /]$ sudo mkdir /var/www/html443/basic
[suzuki@localhost /]$ sudo touch /var/www/html443/basic/index.html

[suzuki@localhost /]$ sudo vi /var/www/html443/basic/index.html

#下記を入力する
<html><h1>basic</h1></html>

#ファイルを閉じる
:wq
enter

#シンタックスのチェックを行う
[suzuki@localhost /]$ sudo /usr/local/httpd/httpd-2.4.48/bin/apachectl -t

#apacheを再起動する
[suzuki@localhost /]$ sudo /usr/local/httpd/httpd-2.4.48/bin/apachectl graceful

#access_logを確認
[suzuki@localhost /]$ tail -f /usr/local/httpd/httpd-2.4.48/logs/access_log

#ブラウザにてipアドレスやドメイン名を入力し、表示を確認
```
### ダイジェスト認証を入れる

- 概要  
WebサーバとWebブラウザなどの間で利用者の認証を行う方式の一つで、認証情報をハッシュ化して送受信する方式。

- ハッシュ化
ある特定の文字列や数字の羅列を一定のルール（ハッシュ関数）に基づいた計算手順によって別の値（ハッシュ値）に置換させることをさします

[参考](https://qiita.com/takahashi-kazuki/items/0b89f37faf57c1d2b957)
```
#httpd.conf(apacheの設定ファイル)を編集する
[suzuki@localhost /]$ sudo vi /usr/local/httpd/httpd-2.4.48/conf/httpd.conf

#下記のコメントアウトを外す
LoadModule auth_digest_module modules/mod_auth_digest.so

#ファイルを閉じる
:wq
enter

#認証用のパスワードファイルを作成する
[suzuki@localhost /]$ sudo /usr/local/httpd/httpd-2.4.48/bin/htdigest -c /usr/local/httpd/httpd-2.4.48/htdigestpasswd "auth" suzuki
設定したパスワードを2回入力する
```
- digestコマンドについて
basic認証の時と違い、領域名(今回は"auth"にしている)を指定する必要があり、vhostsファイルに記載するAuthNameと同じにする必要がある。

```
#バーチャルホストの設定ファイルを編集する
[suzuki@localhost /]$ sudo vi /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf

#下記を<VirtualHost 192.168.56.2:443>内に追記する
<Directory "/var/www/html443/digest">
  AuthType Digest
  AuthName "auth"
  AuthUserFile /usr/local/httpd/httpd-2.4.48/htdigestpasswd
  Require valid-user
</Directory>

#ファイルを閉じる
:wq
enter

ディレクトリとファイルを作成する
[suzuki@localhost /]$ sudo mkdir /var/www/html443/digest
[suzuki@localhost /]$ sudo touch /var/www/html443/digest/index.html

[suzuki@localhost /]$ sudo vi /var/www/html443/digest/index.html

#下記を入力する
<html><h1>digest</h1></html>

#ファイルを閉じる
:wq
enter

#シンタックスのチェックを行う
[suzuki@localhost /]$ sudo /usr/local/httpd/httpd-2.4.48/bin/apachectl -t

#apacheを再起動する
[suzuki@localhost /]$ sudo /usr/local/httpd/httpd-2.4.48/bin/apachectl graceful

#access_logを確認
[suzuki@localhost /]$ tail -f /usr/local/httpd/httpd-2.4.48/logs/access_log

#ブラウザにてipアドレスやドメイン名を入力し、表示を確認
```

### 特定のipアドレスのみ許可する
```
#httpd-vhosts.conf(virtualhostの設定ファイル)を編集する
[suzuki@localhost /]$ sudo vi /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf

#<VirtualHost 192.168.56.2:80>内に下記を追記する
<Directory "/var/www/htmlu/ip">
  Require ip 192.168.56.1
</Directory>

#※拒否する場合
<RequireAll>
  Require all granted
  Require not ip 192.168.56.1
</RequireAll>


#ファイルを閉じる
:wq
enter

ディレクトリとファイルを作成する
[suzuki@localhost /]$ sudo mkdir /var/www/htmlu/ip
[suzuki@localhost /]$ sudo touch /var/www/htmlu/ip/index.html

[suzuki@localhost /]$ sudo vi /var/www/htmlu/ip/index.html

#下記を入力する
<html><h1>ip only</h1></html>

#ファイルを閉じる
:wq
enter

#シンタックスのチェックを行う
[suzuki@localhost /]$ sudo /usr/local/httpd/httpd-2.4.48/bin/apachectl -t

#apacheを再起動する
[suzuki@localhost /]$ sudo /usr/local/httpd/httpd-2.4.48/bin/apachectl graceful

#access_logを確認
[suzuki@localhost /]$ tail -f /usr/local/httpd/httpd-2.4.48/logs/access_log

#ブラウザにてipアドレスやドメイン名を入力し、表示を確認

#別の仮想環境を起動し、接続する(ip192.168.56.3)
[suzuki@localhost /]$ curl suzuki-u.com/ip
```
![結果](指定のipアドレス以外での接続結果.png)

### プロキシ