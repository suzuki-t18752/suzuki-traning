# 1.virtualboxのインストール

[インストール元](https://www.virtualbox.org/wiki/Downloads)

## 1.1.CPUの仮想化が出来ているか確認
再起動して立ち上がり時にF2を入力続けてBIOSを開く  
Advanced  
→ Advanced Chipset Control   
→　Intel Virtualization TechnologyをEnabledに変更

## 1.2.virtualbox仮想マシン設定
virtualboxの立ち上げ  
→ 新規作成  
→ 下記設定を順番に入力していく  

名前: centOS7  
バージョン：red hat 64bit(red hat社の提供するディストリビューション)  
メモリ：4G  
ファイルタイプ：VDI(virtualboxの基本的ファイルタイプ)  
ストレージサイズ設定：可変サイズ(使用した分だけ物理ハードディスク領域を使用)  
ストレージサイズ：20G

# 2.linuxのインストール

[インストール元](https://www.centos.org/download/)  

## 2.1.centOSダウンロード  
インストール元を開く  
→ 7のタブを選択  
→ x86_64をクリック  
→ ISO images available内の好きなリンクを選択  
→DVD ISOを選択しダウンロード

## 2.2.centOSの設定方法  
virtualboxの立ち上げ後、起動ボタンを押下  
→ デバイス内の光学ドライブ、ディスクファイルの選択を押下  
→ ダウンロードしたISOファイル(centOS~~~)を選択  
→　virtualboxの再起動を行う  
→　インストール先を選択  
→　インストール開始を選択  
→ ユーザーの設定を行う(rootユーザーのパスワードを設定)  
→ 設定完了を押下  
→ 再起動を押下 

## 2.3.ユーザーの作成  
```
#rootユーザーにてログイン

#suzukiユーザーを作成
[root@localhost ~]# useradd suzuki 

#suzukiユーザーにパスワードを設定
[root@localhost ~]# passwd suzuki

#設定したパスワードを2回入力

#wheelグループにユーザーをつ追加
#sudoコマンドを使えるようにする(sodoグループ、centOsの場合はwheelグループ)
[root@localhost ~]# usermod -aG wheel suzuki

#ログアウトする
[root@localhost ~]# exit

#suzukiユーザーにてログイン

#sudoコマンドが使えるか確認
[suzuki@localhost ~]$ sudo su -

#パスワードを入力しrootユーザーに切り替わればOK
```

# 3.virtualboxのネットワーク接続設定

[ネットワーク設定の詳細](https://www.it-poem.com/?p=310)

1. virtualbox、ツールの横にある横線3つのボタンを選択し、ネットワークを開き、ipv4のアドレス(ホストOSのアドレス)を確認する

2. 作成したOSの設定ボタンを押下すると、設定画面が開くのでネットワークを押下してアダプター1の割り当てがNATになっていることを確認する。なっていない場合は変更する

3. アダプター2の設定を変更する
- ネットワークの有効化:チェックを入れる
- 割り当て:ホストオンリーアダプター

4. OSを起動後、コマンドを実行し、設定画面を開く
```
[suzuki@localhost ~]$ nmtui
```
5. Edit a connection → enp0s3の順にenterキーで選択

6. IPv6の部分をenterで選択後、プルダウンが表示されるのでIgnoreを選択する

7. Automatically connectにspaceキーでバツマークを入れてから、OKをenterキーで選択し完了する

8. enp0s3の上(文字化けしている □□□)にカーソルを合わせてenterキーで選択する

9. nameをenp0s8に変更し、IPv4の部分をenterで選択後、プルダウンが表示されるのでManualを選択し、showボタンを押下する

10. Addressをenterキーで選択し、1で確認したipアドレスを下限、ネットマスクを上限の範囲として適当に決めて入力します

11. 6,7と同じようにIPv6とAutomatically connectを設定し、完了する

12. Back → Quitの順で選択し、OS起動画面に戻る

# 4.firewall(iptables)の設定
```
#iptabelsがインストールされているか確認
[suzuki@localhost ~]$ which iptabels

#yumのアップデート
[suzuki@localhost ~]$ sudo yum update

#iptabelsのインストール
[suzuki@localhost ~]$ sudo yum install iptables-services

#firewalldの状態を確認する
[suzuki@localhost ~]$ systemctl status firewalld
[suzuki@localhost ~]$ systemctl is-enabled firewalld

#firewalldのサービス停止と自動起動設定の停止
[suzuki@localhost ~]$ systemctl stop firewalld
[suzuki@localhost ~]$ systemctl disable firewalld

#再度firewalldの状態を確認する 起動状態がactive(running),自動起動設定中はenable
[suzuki@localhost ~]$ systemctl status firewalld
[suzuki@localhost ~]$ systemctl is-enabled firewalld

#iptablesの状態を確認する 起動状態がactive(exited),自動起動設定中はenable
[suzuki@localhost ~]$ systemctl status iptables
[suzuki@localhost ~]$ systemctl is-enabled iptables

#サービスの起動と自動起動設定の起動 
[suzuki@localhost ~]$ systemctl start iptables
[suzuki@localhost ~]$ systemctl enable iptables

#再度iptablesの状態を確認する 起動状態がactive(exited),自動起動設定中はenable
[suzuki@localhost ~]$ systemctl status iptables
[suzuki@localhost ~]$ systemctl is-enabled iptables

#現在の設定内容を確認する
[suzuki@localhost ~]$ sudo iptables -nL

#ルールを追加する
[suzuki@localhost ~]$ sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT  
[suzuki@localhost ~]$ sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

#ルールを削除する
[suzuki@localhost ~]$ sudo iptables -D INPUT -j REJECT --reject-with icmp-host-prohibited

#先ほど削除したルールを再び追加する(最初に追加したルールを優先させる為)
[suzuki@localhost ~]$ sudo iptables -A INPUT -j REJECT --reject-with icmp-host-prohibited

#変更したルールの保存を行う
[suzuki@localhost ~]$ sudo /usr/libexec/iptables/iptables.init save

#iptablesの再起動を行い、設定を適用する
[suzuki@localhost ~]$ systemctl restart iptables

#設定の反映を確認する
[suzuki@localhost ~]$ sudo iptables -nL
```

# 5.apacheの設定

## 5.1.APRのダウンロード、インストール
```
#パッケージのインストール
[suzuki@localhost ~]$ sudo yum install gcc make pcre-devel expat-devel

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

## 5.2.apr-utilのダウンロード、インストール手順  
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

## 5.3.apacheのダウンロード、インストール手順
```
#パッケージのインストール
[suzuki@localhost apr-util-1.6.1]$ sudo yum install openssl-devel

#ファイルを置くディレクトリへ移動
[suzuki@localhost apr-util-1.6.1]$ cd /usr/local/src

#ファイルのダウンロードする
[suzuki@localhost src]$ sudo curl -O --url https://dlcdn.apache.org//httpd/httpd-2.4.48.tar.gz

#ファイルを解凍する
[suzuki@localhost src]$ sudo tar xvf httpd-2.4.48.tar.gz

#作業ディレクトリへ移動
[suzuki@localhost apr-util-1.6.1]$ cd /usr/local/src/httpd-2.4.48

#Makefileを作成
[suzuki@localhost httpd-2.4.48]$ sudo ./configure --prefix=/usr/local/httpd/httpd-2.4.48 --with-apr=/usr/local/apr/apr-1.7.0 --with-apr-util=/usr/local/apr-util/apr-util-1.6.1 --enable-ssl

#Makefikeを元にmake installに必要なファイルをコンパイル
[suzuki@localhost httpd-2.4.48]$ sudo make

#インストール実施
[suzuki@localhost httpd-2.4.48]$ sudo make install
```
## 5.4.apacheの起動、確認
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


## バーチャルホスト
```
#設定ファイルのバックアップをする
[suzuki@localhost /]$ sudo cp /usr/local/httpd/httpd-2.4.48/conf/httpd.conf /usr/local/httpd/httpd-2.4.48/conf/httpd.conf.org

#httpd.conf(apacheの設定ファイル)を編集する
[suzuki@localhost /]$ sudo sed -i -e 's%#Include /conf/extra/httpd-vhosts.conf%Include /conf/extra/httpd-vhosts.conf%g' /usr/local/httpd/httpd-2.4.48/conf/httpd.conf

[suzuki@localhost /]$ diff -i /usr/local/httpd/httpd-2.4.48/conf/httpd.conf /usr/local/httpd/httpd-2.4.48/conf/httpd.conf.org
478c478
< Include conf/extra/httpd-vhosts.conf
---
> #Include conf/extra/httpd-vhosts.conf


#設定ファイルのバックアップをする
[suzuki@localhost /]$ sudo cp /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf.org

#httpd-vhosts.conf(virtualhostの設定ファイル)を編集する
[suzuki@localhost /]$ sudo vi /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf

#下記のように編集
Listen 443

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

[suzuki@localhost /]$ diff -i /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf.org
23,34c23,29
< Listen 443
<
< NameVirtualHost 192.168.56.2:80
< NameVirtualHost 192.168.56.2:443
<
< <VirtualHost 192.168.56.2:80>
<   DocumentRoot "/var/www/html"
<   ServerName suzuki-t.com
<
<     <Directory "/var/www/html">
<          Require all granted
<     </Directory>
---
> <VirtualHost *:80>
>     ServerAdmin webmaster@dummy-host.example.com
>     DocumentRoot "/usr/local/httpd/httpd-2.4.48/docs/dummy-host.example.com"
>     ServerName dummy-host.example.com
>     ServerAlias www.dummy-host.example.com
>     ErrorLog "logs/dummy-host.example.com-error_log"
>     CustomLog "logs/dummy-host.example.com-access_log" common
37,52c32,37
< <VirtualHost 192.168.56.2:443>
<   DocumentRoot "/var/www/html443"
<   ServerName suzuki-t.com
<
<     <Directory "/var/www/html443">
<          Require all granted
<     </Directory>
< </VirtualHost>
<
< <VirtualHost 192.168.56.2:80>
<   DocumentRoot "/var/www/htmlu"
<   ServerName suzuki-u.com
<
<     <Directory "/var/www/htmlu">
<          Require all granted
<     </Directory>
---
> <VirtualHost *:80>
>     ServerAdmin webmaster@dummy-host2.example.com
>     DocumentRoot "/usr/local/httpd/httpd-2.4.48/docs/dummy-host2.example.com"
>     ServerName dummy-host2.example.com
>     ErrorLog "logs/dummy-host2.example.com-error_log"
>     CustomLog "logs/dummy-host2.example.com-access_log" common


#/etc/hosts(ホスト名とIPアドレスの対応付けを書いておくファイル)を編集する
[suzuki@localhost /]$ sudo sh -c "echo '192.168.56.2    suzuki-t.com' >> /etc/hosts"
[suzuki@localhost /]$ sudo sh -c "echo '192.168.56.2    suzuki-u.com' >> /etc/hosts"

[suzuki@localhost /]$ diff -i /etc/hosts /etc/hosts.bak
3,4d2
< 192.168.56.2    suzuki-t.com
< 192.168.56.2    suzuki-u.com


# C:\Windows\System32\drivers\etc内のhostファイルの編集し、下記を入力する
192.168.56.2    suzuki-t.com
192.168.56.2    suzuki-u.com

#表示するファイルとドキュメントルートのディレクトリを作成する
[suzuki@localhost /]$ sudo mkdir /var/www
[suzuki@localhost /]$ sudo mkdir /var/www/html
[suzuki@localhost /]$ sudo sh -c "echo '<html><h1>Hello Wrold</h1></html>' >> /var/www/html/index.html"

#表示するファイルとドキュメントルートのディレクトリを作成する(port443用)
[suzuki@localhost /]$ sudo mkdir /var/www/html443
[suzuki@localhost /]$ sudo sh -c "echo '<html><h1>Hello Wrold port443</h1></html>' >> /var/www/html443/index.html"


#表示するファイルとドキュメントルートのディレクトリを作成する(suzuki-uドメイン用)
[suzuki@localhost /]$ sudo mkdir /var/www/htmlu
[suzuki@localhost /]$ sudo sh -c "echo '<html><h1>Hello Wrold domain-u</h1></html>' >> /var/www/htmlu/index.html"

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

#
[suzuki@localhost mysql]$ sudo bin/mysql_ssl_rsa_setup

#ログ用のディレクトリとファイルを作成し、mysqlユーザーに権限を与える
[suzuki@localhost mysql]$ sudo mkdir /var/log/mariadb
[suzuki@localhost mysql]$ sudo touch /var/log/mariadb/mariadb.log
[suzuki@localhost mysql]$ sudo chown mysql:mysql /var/log/mariadb/mariadb.log
[suzuki@localhost mysql]$ sudo chown mysql:mysql /var/log/mariadb

#mysqlの設定ファイルのバックアップをする
[suzuki@localhost mysql]$ sudo cp /etc/my.cnf /etc/my.cnf.org

#mysqlの設定ファイルを編集する
[suzuki@localhost mysql]$ sudo sed -i -e 's%socket=/var/lib/mysql/mysql.sock%socket=/tmp/mysql.sock%g' /etc/my.cnf

#mysqlを実行する
[suzuki@localhost mysql]$ sudo support-files/mysql.server start

#mysqlへアクセス
[suzuki@localhost mysql]$ bin/mysql -u root -p 

#メモしていたパスワードを入力する

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


# 「MySQLのユーザー」suzukiを作成して、mysqldが動いているサーバーからパスワードでmysqlコマンドで接続できるようにする
```
#mysqldを起動
[suzuki@localhost mysql]$ sudo support-files/mysql.server start

#rootユーザーでログイン
[suzuki@localhost mysql]$ bin/mysql -u root -p

#rootユーザーのパスワードを設定する
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'suzuki0901';

#suzukiを作成する
mysql> CREATE USER 'suzuki'@'localhost' IDENTIFIED BY 'suzuki0901';

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
mysql> CREATE USER 'suzuki'@'192.168.56.3' IDENTIFIED BY 'suzuki0901';

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
[suzuki@localhost mysql]$ bin/mysql -u suzuki -psuzuki0901 -h 192.168.56.2

実行時に下記エラーが発生した為、firewallの設定を行う
[suzuki@localhost mysql]$ bin/mysql -u suzuki -psuzuki0901 -h 192.168.56.2
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
[suzuki@localhost mysql]$ bin/mysql -u suzuki -psuzuki0901 -h 192.168.56.2
```

### 結果
```
#接続結果
[suzuki@localhost mysql]$ bin/mysql -u suzuki -psuzuki0901 -h 192.168.56.2
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
#パッケージのインストール
[suzuki@os1 php-7.4.23]$ sudo yum install libcurl-devel libpng-devel libicu-devel libsodium-devel libxml2-devel sqlite-devel perl

[suzuki@os1 php-7.4.23]$ sudo yum install http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

[suzuki@os1 php-7.4.23]$ sudo yum install oniguruma-devel

#ソースコードをダウンロードするディレクトリへ
[suzuki@localhost ~]$ cd /usr/local/src

#ソースコードのダウンロード
[suzuki@localhost src]$ sudo curl -LO --url https://www.php.net/distributions/php-7.4.23.tar.gz

#ファイルの解凍
[suzuki@localhost src]$ sudo tar xvf php-7.4.23.tar.gz

#作業ディレクトリへ
[suzuki@localhost src]$ cd php-7.4.23

#
[suzuki@localhost src]$ sudo sed -i -e 's%#!/replace/with/path/to/perl/interpreter -w%#!/usr/bin/perl -w%g' /usr/local/httpd/httpd-2.4.48/bin/apxs

#Makefileの作成
[suzuki@localhost php-7.4.23]$ sudo ./configure --with-apxs2=/usr/local/httpd/httpd-2.4.48/bin/apxs --with-pdo-mysql --with-mysqli --with-curl --enable-exif --enable-mbstring --with-openssl-dir=/usr/bin --with-sodium  --enable-bcmath --enable-gd --enable-intl --enable-ftp --enable-sockets --with-zlib
```
```
#インストールに必要なファイルのコンパイル
[suzuki@localhost php-7.4.23]$ sudo make

#インストールの実施
[suzuki@localhost php-7.4.23]$ sudo make install

#設定ファイルを作成する
[suzuki@localhost php-7.4.23]$ sudo cp php.ini-development /usr/local/lib/php.ini

#確認
[suzuki@localhost php-7.4.23]$ php -v
PHP 7.4.23 (cli) (built: Sep 16 2021 11:15:12) ( ZTS )
Copyright (c) The PHP Group
Zend Engine v3.4.0, Copyright (c) Zend Technologies

#設定ファイルのバックアップ
[suzuki@localhost php-7.4.23]$ sudo cp /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf.bak_20210922

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

#httpd.conf内のDirectoryIndexにindex.phpを追加(トップページを探しに行く設定)
sudo sed -i -e 's%DirectoryIndex index.html%DirectoryIndex index.html index.php%g' /usr/local/httpd/httpd-2.4.48/conf/httpd.conf
```

# wordpress

```
#ソースコードをダウンロードするディレクトリへ
[suzuki@os1 ~]$ cd /var/www/html

#ソースコードのダウンロード
[suzuki@localhost html]$ curl -LO --url https://ja.wordpress.org/latest-ja.tar.gz

#ファイルの解凍
[suzuki@localhost html]$ sudo tar xvf latest-ja.tar.gz -C /var/www/html

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