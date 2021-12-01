## git tag
- 基本確認前にfetchを掛ける
- git tag
  - ローカルのタグのリスト
- git tag タグの名前
  - タグの作成
- git tag -d タグの名前
  - ローカルタグの削除
- git push --tags
  - リモートにタグを作成する
- git push --delete origin タグ名
  - リモートのタグの削除
- git ls-remote --tags
  - リモートのタグリスト


# [nginxインストール](https://nginx.org/en/linux_packages.html#RHEL-CentOS)
```
#必要なライブラリをインストール
[suzuki@suzuki-t ~]$ sudo yum install yum-utils
[sudo] suzuki のパスワード:
読み込んだプラグイン:fastestmirror
Loading mirror speeds from cached hostfile
 * base: ftp.riken.jp
 * extras: ftp.riken.jp
 * updates: ftp.riken.jp
base                                                                                                                                                                                        | 3.6 kB  00:00:00
extras                                                                                                                                                                                      | 2.9 kB  00:00:00
updates                                                                                                                                                                                     | 2.9 kB  00:00:00
依存性の解決をしています
--> トランザクションの確認を実行しています。
---> パッケージ yum-utils.noarch 0:1.1.31-54.el7_8 を インストール
--> 依存性の処理をしています: python-kitchen のパッケージ: yum-utils-1.1.31-54.el7_8.noarch
--> 依存性の処理をしています: libxml2-python のパッケージ: yum-utils-1.1.31-54.el7_8.noarch
--> トランザクションの確認を実行しています。
---> パッケージ libxml2-python.x86_64 0:2.9.1-6.el7_9.6 を インストール
---> パッケージ python-kitchen.noarch 0:1.1.1-5.el7 を インストール
--> 依存性の処理をしています: python-chardet のパッケージ: python-kitchen-1.1.1-5.el7.noarch
--> トランザクションの確認を実行しています。
---> パッケージ python-chardet.noarch 0:2.2.1-3.el7 を インストール
--> 依存性解決を終了しました。

依存性を解決しました

===================================================================================================================================================================================================================
 Package                                               アーキテクチャー                              バージョン                                               リポジトリー                                    容量
===================================================================================================================================================================================================================
インストール中:
 yum-utils                                             noarch                                        1.1.31-54.el7_8                                          base                                           122 k
依存性関連でのインストールをします:
 libxml2-python                                        x86_64                                        2.9.1-6.el7_9.6                                          updates                                        247 k
 python-chardet                                        noarch                                        2.2.1-3.el7                                              base                                           227 k
 python-kitchen                                        noarch                                        1.1.1-5.el7                                              base                                           267 k

トランザクションの要約
===================================================================================================================================================================================================================
インストール  1 パッケージ (+3 個の依存関係のパッケージ)

総ダウンロード容量: 863 k
インストール容量: 4.3 M
Is this ok [y/d/N]: y
Downloading packages:
(1/4): python-chardet-2.2.1-3.el7.noarch.rpm                                                                                                                                                | 227 kB  00:00:00
(2/4): libxml2-python-2.9.1-6.el7_9.6.x86_64.rpm                                                                                                                                            | 247 kB  00:00:00
(3/4): python-kitchen-1.1.1-5.el7.noarch.rpm                                                                                                                                                | 267 kB  00:00:00
(4/4): yum-utils-1.1.31-54.el7_8.noarch.rpm                                                                                                                                                 | 122 kB  00:00:00
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
合計                                                                                                                                                                               1.7 MB/s | 863 kB  00:00:00
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  インストール中          : python-chardet-2.2.1-3.el7.noarch                                                                                                                                                  1/4
  インストール中          : python-kitchen-1.1.1-5.el7.noarch                                                                                                                                                  2/4
  インストール中          : libxml2-python-2.9.1-6.el7_9.6.x86_64                                                                                                                                              3/4
  インストール中          : yum-utils-1.1.31-54.el7_8.noarch                                                                                                                                                   4/4
  検証中                  : python-kitchen-1.1.1-5.el7.noarch                                                                                                                                                  1/4
  検証中                  : yum-utils-1.1.31-54.el7_8.noarch                                                                                                                                                   2/4
  検証中                  : libxml2-python-2.9.1-6.el7_9.6.x86_64                                                                                                                                              3/4
  検証中                  : python-chardet-2.2.1-3.el7.noarch                                                                                                                                                  4/4

インストール:
  yum-utils.noarch 0:1.1.31-54.el7_8

依存性関連をインストールしました:
  libxml2-python.x86_64 0:2.9.1-6.el7_9.6                                 python-chardet.noarch 0:2.2.1-3.el7                                 python-kitchen.noarch 0:1.1.1-5.el7

完了しました!
[suzuki@suzuki-t ~]$ echo $?
0

#パッケージをインストールする為にリポジトリを作成する
[suzuki@suzuki-t ~]$ sudo sh -c "cat << EOF > /etc/yum.repos.d/nginx.repo
> [nginx-stable]
> name=nginx stable repo
> baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
> gpgcheck=1
> enabled=1
> gpgkey=https://nginx.org/keys/nginx_signing.key
> module_hotfixes=true
>
> [nginx-mainline]
> name=nginx mainline repo
> baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
> gpgcheck=1
> enabled=0
> gpgkey=https://nginx.org/keys/nginx_signing.key
> module_hotfixes=true
> EOF"
[suzuki@suzuki-t ~]$ cat /etc/yum.repos.d/nginx.repo
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos///
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos///
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true

[suzuki@suzuki-t ~]$ yum repolist
読み込んだプラグイン:fastestmirror
Loading mirror speeds from cached hostfile
 * base: ftp.nara.wide.ad.jp
 * extras: ftp.nara.wide.ad.jp
 * updates: ftp.nara.wide.ad.jp
http://nginx.org/packages/centos///repodata/repomd.xml: [Errno 14] HTTP Error 404 - Not Found
他のミラーを試します。
To address this issue please refer to the below wiki article

https://wiki.centos.org/yum-errors

If above article doesn't help to resolve this issue please use https://bugs.centos.org/.

http://nginx.org/packages/centos///repodata/repomd.xml: [Errno 14] HTTP Error 404 - Not Found
他のミラーを試します。
リポジトリー ID                                                                                      リポジトリー名                                                                                          状態
base/7/x86_64                                                                                        CentOS-7 - Base                                                                                         10,072
extras/7/x86_64                                                                                      CentOS-7 - Extras                                                                                          500
nginx-stable                                                                                         nginx stable repo                                                                                            0
updates/7/x86_64                                                                                     CentOS-7 - Updates                                                                                       2,963
repolist: 13,535

#リポジトリの確認時エラー発生
#下記に変更
#変数を展開しないようにする
sudo sh -c 'cat << "EOF" > /etc/yum.repos.d/nginx.repo
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
EOF'

[suzuki@suzuki-t ~]$ diff a.txt /etc/yum.repos.d/nginx.repo
0a1,15
> [nginx-stable]
> name=nginx stable repo
> baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
> gpgcheck=1
> enabled=1
> gpgkey=https://nginx.org/keys/nginx_signing.key
> module_hotfixes=true
> #
> [nginx-mainline]
> name=nginx mainline repo
> baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
> gpgcheck=1
> enabled=0
> gpgkey=https://nginx.org/keys/nginx_signing.key
> module_hotfixes=true

#pacth
sudo patch /etc/yum.repos.d/nginx.repo << 'EOF'
0a1,15
> [nginx-stable]
> name=nginx stable repo
> baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
> gpgcheck=1
> enabled=1
> gpgkey=https://nginx.org/keys/nginx_signing.key
> module_hotfixes=true
> #
> [nginx-mainline]
> name=nginx mainline repo
> baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
> gpgcheck=1
> enabled=0
> gpgkey=https://nginx.org/keys/nginx_signing.key
> module_hotfixes=true
EOF

[suzuki@suzuki-t ~]$ sudo yum install patch
読み込んだプラグイン:fastestmirror
Loading mirror speeds from cached hostfile
 * base: ftp.riken.jp
 * extras: ftp.riken.jp
 * updates: ftp.riken.jp
base                                                                                                                                                                                        | 3.6 kB  00:00:00
extras                                                                                                                                                                                      | 2.9 kB  00:00:00
nginx-stable                                                                                                                                                                                | 2.9 kB  00:00:00
updates                                                                                                                                                                                     | 2.9 kB  00:00:00
nginx-stable/7/x86_64/primary_db                                                                                                                                                            |  70 kB  00:00:01
依存性の解決をしています
--> トランザクションの確認を実行しています。
---> パッケージ patch.x86_64 0:2.7.1-12.el7_7 を インストール
--> 依存性解決を終了しました。

依存性を解決しました

===================================================================================================================================================================================================================
 Package                                         アーキテクチャー                                 バージョン                                                  リポジトリー                                    容量
===================================================================================================================================================================================================================
インストール中:
 patch                                           x86_64                                           2.7.1-12.el7_7                                              base                                           111 k

トランザクションの要約
===================================================================================================================================================================================================================
インストール  1 パッケージ

総ダウンロード容量: 111 k
インストール容量: 210 k
Is this ok [y/d/N]: y
Downloading packages:
patch-2.7.1-12.el7_7.x86_64.rpm                                                                                                                                                             | 111 kB  00:00:00
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  インストール中          : patch-2.7.1-12.el7_7.x86_64                                                                                                                                                        1/1
  検証中                  : patch-2.7.1-12.el7_7.x86_64                                                                                                                                                        1/1

インストール:
  patch.x86_64 0:2.7.1-12.el7_7

完了しました!

[suzuki@suzuki-t ~]$ yum repolist
読み込んだプラグイン:fastestmirror
Loading mirror speeds from cached hostfile
 * base: ftp.nara.wide.ad.jp
 * extras: ftp.nara.wide.ad.jp
 * updates: ftp.nara.wide.ad.jp
リポジトリー ID                                                                                         リポジトリー名                                                                                       状態
base/7/x86_64                                                                                           CentOS-7 - Base                                                                                      10,072
extras/7/x86_64                                                                                         CentOS-7 - Extras                                                                                       500
nginx-stable/7/x86_64                                                                                   nginx stable repo                                                                                       256
updates/7/x86_64                                                                                        CentOS-7 - Updates                                                                                    2,963
repolist: 13,791


#インストール
[suzuki@suzuki-t ~]$ sudo yum install nginx
読み込んだプラグイン:fastestmirror
Loading mirror speeds from cached hostfile
 * base: ftp.riken.jp
 * extras: ftp.riken.jp
 * updates: ftp.riken.jp
依存性の解決をしています
--> トランザクションの確認を実行しています。
---> パッケージ nginx.x86_64 1:1.20.2-1.el7.ngx を インストール
--> 依存性解決を終了しました。

依存性を解決しました

===================================================================================================================================================================================================================
 Package                                      アーキテクチャー                              バージョン                                                   リポジトリー                                         容量
===================================================================================================================================================================================================================
インストール中:
 nginx                                        x86_64                                        1:1.20.2-1.el7.ngx                                           nginx-stable                                        790 k

トランザクションの要約
===================================================================================================================================================================================================================
インストール  1 パッケージ

総ダウンロード容量: 790 k
インストール容量: 2.8 M
Is this ok [y/d/N]: y
Downloading packages:
警告: /var/cache/yum/x86_64/7/nginx-stable/packages/nginx-1.20.2-1.el7.ngx.x86_64.rpm: ヘッダー V4 RSA/SHA1 Signature、鍵 ID 7bd9bf62: NOKEY==-                                  ] 158 kB/s | 458 kB  00:00:02 ETA
nginx-1.20.2-1.el7.ngx.x86_64.rpm の公開鍵がインストールされていません
nginx-1.20.2-1.el7.ngx.x86_64.rpm                                                                                                                                                           | 790 kB  00:00:02
https://nginx.org/keys/nginx_signing.key から鍵を取得中です。
Importing GPG key 0x7BD9BF62:
 Userid     : "nginx signing key <signing-key@nginx.com>"
 Fingerprint: 573b fd6b 3d8f bc64 1079 a6ab abf5 bd82 7bd9 bf62
 From       : https://nginx.org/keys/nginx_signing.key
上記の処理を行います。よろしいでしょうか？ [y/N]y
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  インストール中          : 1:nginx-1.20.2-1.el7.ngx.x86_64                                                                                                                                                    1/1
----------------------------------------------------------------------

Thanks for using nginx!

Please find the official documentation for nginx here:
* https://nginx.org/en/docs/

Please subscribe to nginx-announce mailing list to get
the most important news about nginx:
* https://nginx.org/en/support.html

Commercial subscriptions for nginx are available on:
* https://nginx.com/products/

----------------------------------------------------------------------
  検証中                  : 1:nginx-1.20.2-1.el7.ngx.x86_64                                                                                                                                                    1/1

インストール:
  nginx.x86_64 1:1.20.2-1.el7.ngx

完了しました!

#確認
[suzuki@suzuki-t ~]$ systemctl status nginx
● nginx.service - nginx - high performance web server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
     Docs: http://nginx.org/en/docs/

#起動
[suzuki@suzuki-t ~]$ systemctl start nginx
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===
Authentication is required to manage system services or units.
Authenticating as: suzuki
Password:
==== AUTHENTICATION COMPLETE ===
[suzuki@suzuki-t ~]$ echo $?
0
[suzuki@suzuki-t ~]$ systemctl status nginx
● nginx.service - nginx - high performance web server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: active (running) since 水 2021-11-24 11:25:49 JST; 20s ago
     Docs: http://nginx.org/en/docs/
  Process: 11490 ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx.conf (code=exited, status=0/SUCCESS)
 Main PID: 11491 (nginx)
   CGroup: /system.slice/nginx.service
           ├─11491 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx.conf
           ├─11492 nginx: worker process
           └─11493 nginx: worker process

11月 24 11:25:49 suzuki-t systemd[1]: Starting nginx - high performance web server...
11月 24 11:25:49 suzuki-t systemd[1]: Started nginx - high performance web server.
[suzuki@suzuki-t ~]$ ps aux | grep nginx
root     11491  0.0  0.0  46504  1144 ?        Ss   11:25   0:00 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx.conf
nginx    11492  0.0  0.0  46904  1872 ?        S    11:25   0:00 nginx: worker process
nginx    11493  0.0  0.0  46904  1872 ?        S    11:25   0:00 nginx: worker process
suzuki   11497  0.0  0.0 112824   980 pts/0    S+   11:26   0:00 grep --color=auto nginx
[suzuki@suzuki-t ~]$ nginx -v
nginx version: nginx/1.20.2


#ブラウザにてhttp://192.168.56.3/を確認
#下記の表示
Welcome to nginx!
If you see this page, the nginx web server is successfully installed and working. Further configuration is required.

For online documentation and support please refer to nginx.org.
Commercial support is available at nginx.com.

Thank you for using nginx.

#自動起動設定
[suzuki@suzuki-t ~]$ systemctl is-enabled nginx
disabled
[suzuki@suzuki-t ~]$ systemctl enable nginx
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-unit-files ===
Authentication is required to manage system service or unit files.
Authenticating as: suzuki
Password:
==== AUTHENTICATION COMPLETE ===
Created symlink from /etc/systemd/system/multi-user.target.wants/nginx.service to /usr/lib/systemd/system/nginx.service.
==== AUTHENTICATING FOR org.freedesktop.systemd1.reload-daemon ===
Authentication is required to reload the systemd state.
Authenticating as: suzuki
Password:
==== AUTHENTICATION COMPLETE ===
[suzuki@suzuki-t ~]$ systemctl is-enabled nginx
enabled

```
```
[suzuki@suzuki-t ~]$ sudo find / -name "nginx"
/etc/logrotate.d/nginx
/etc/nginx
/var/log/nginx
/var/cache/nginx
/usr/sbin/nginx
/usr/lib64/nginx
/usr/share/nginx
/usr/libexec/initscripts/legacy-actions/nginx
```

### nginxのログ
```
[suzuki@suzuki-t ~]$ ls -l /var/log/nginx/
合計 8
-rw-r-----. 1 nginx adm 422 11月 24 11:27 access.log
-rw-r-----. 1 nginx adm 845 11月 24 11:27 error.log

[suzuki@suzuki-t ~]$ sudo cat /var/log/nginx/access.log
192.168.56.1 - - [24/Nov/2021:11:27:13 +0900] "GET / HTTP/1.1" 200 612 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36" "-"
192.168.56.1 - - [24/Nov/2021:11:27:13 +0900] "GET /favicon.ico HTTP/1.1" 404 555 "http://192.168.56.3/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36" "-"

[suzuki@suzuki-t ~]$ sudo cat /var/log/nginx/error.log
2021/11/24 11:25:49 [notice] 11490#11490: using the "epoll" event method
2021/11/24 11:25:49 [notice] 11490#11490: nginx/1.20.2
2021/11/24 11:25:49 [notice] 11490#11490: built by gcc 4.8.5 20150623 (Red Hat 4.8.5-44) (GCC)
2021/11/24 11:25:49 [notice] 11490#11490: OS: Linux 3.10.0-1160.45.1.el7.x86_64
2021/11/24 11:25:49 [notice] 11490#11490: getrlimit(RLIMIT_NOFILE): 1024:4096
2021/11/24 11:25:49 [notice] 11491#11491: start worker processes
2021/11/24 11:25:49 [notice] 11491#11491: start worker process 11492
2021/11/24 11:25:49 [notice] 11491#11491: start worker process 11493
2021/11/24 11:27:13 [error] 11493#11493: *1 open() "/usr/share/nginx/html/favicon.ico" failed (2: No such file or directory), client: 192.168.56.1, server: localhost, request: "GET /favicon.ico HTTP/1.1", host: "192.168.56.3", referrer: "http://192.168.56.3/"
```
### systemctl管理用設定ファイル
/etc/nginx/conf.d/default.conf

### nginxデフォルト表示html
/usr/share/nginx/html/

### pidファイル
/var/run/nginx.pid

### 設定ファイル
/etc/nginx/nginx.conf

## [nginxをwebサーバーとして](https://docs.nginx.com/nginx/admin-guide/)
## [virtualhost設定について](https://docs.nginx.com/nginx/admin-guide/basic-functionality/managing-configuration-files/)


# [php-fpm](https://www.php.net/manual/ja/install.fpm.php)
```
#epelをインストールする(追加リポジトリ)
[suzuki@suzuki-t ~]$ sudo yum -y install epel-release
[sudo] suzuki のパスワード:
読み込んだプラグイン:fastestmirror
Loading mirror speeds from cached hostfile
 * base: ftp.riken.jp
 * extras: ftp.riken.jp
 * updates: ftp.riken.jp
依存性の解決をしています
--> トランザクションの確認を実行しています。
---> パッケージ epel-release.noarch 0:7-11 を インストール
--> 依存性解決を終了しました。

依存性を解決しました

===================================================================================================================================================================================================================
 Package                                                 アーキテクチャー                                  バージョン                                      リポジトリー                                       容量
===================================================================================================================================================================================================================
インストール中:
 epel-release                                            noarch                                            7-11                                            extras                                             15 k

トランザクションの要約
===================================================================================================================================================================================================================
インストール  1 パッケージ

総ダウンロード容量: 15 k
インストール容量: 24 k
Downloading packages:
epel-release-7-11.noarch.rpm                                                                                                                                                                |  15 kB  00:00:00
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  インストール中          : epel-release-7-11.noarch                                                                                                                                                           1/1
  検証中                  : epel-release-7-11.noarch                                                                                                                                                           1/1

インストール:
  epel-release.noarch 0:7-11

完了しました!
[suzuki@suzuki-t ~]$ ^C
[suzuki@suzuki-t ~]$ sudo yum repolist
読み込んだプラグイン:fastestmirror
Loading mirror speeds from cached hostfile
epel/x86_64/metalink                                                                                                                                                                        | 6.4 kB  00:00:00
 * base: ftp.riken.jp
 * epel: mirrors.nipa.cloud
 * extras: ftp.riken.jp
 * updates: ftp.riken.jp
epel                                                                                                                                                                                        | 4.7 kB  00:00:00
(1/3): epel/x86_64/group_gz                                                                                                                                                                 |  96 kB  00:00:00
(2/3): epel/x86_64/updateinfo                                                                                                                                                               | 1.0 MB  00:00:00
(3/3): epel/x86_64/primary_db                                                                                                                                                               | 7.0 MB  00:00:01
リポジトリー ID                                                                           リポジトリー名                                                                                                     状態
base/7/x86_64                                                                             CentOS-7 - Base                                                                                                    10,072
*epel/x86_64                                                                              Extra Packages for Enterprise Linux 7 - x86_64                                                                     13,687
extras/7/x86_64                                                                           CentOS-7 - Extras                                                                                                     500
nginx-stable/7/x86_64                                                                     nginx stable repo                                                                                                     256
updates/7/x86_64                                                                          CentOS-7 - Updates                                                                                                  2,963
repolist: 27,478

```

```
#yumでphpをインストールする場合remiリポジトリを使うしかない
sudo yum -y install http://rpms.famillecollet.com/enterprise/remi-release-7.rpm


#php本体とphp-fpmのインストール
[suzuki@suzuki-t ~]$ sudo yum install php74 php74-php-fpm
読み込んだプラグイン:fastestmirror
Loading mirror speeds from cached hostfile
 * base: ftp.riken.jp
 * epel: ftp.riken.jp
 * extras: ftp.riken.jp
 * remi-safe: ftp.riken.jp
 * updates: ftp.riken.jp
依存性の解決をしています
--> トランザクションの確認を実行しています。
---> パッケージ php74.x86_64 0:1.0-3.el7.remi を インストール
--> 依存性の処理をしています: php74-runtime(x86-64) = 1.0-3.el7.remi のパッケージ: php74-1.0-3.el7.remi.x86_64
--> 依存性の処理をしています: php74-runtime のパッケージ: php74-1.0-3.el7.remi.x86_64
--> 依存性の処理をしています: php74-php-common(x86-64) のパッケージ: php74-1.0-3.el7.remi.x86_64
--> 依存性の処理をしています: php74-php-cli(x86-64) のパッケージ: php74-1.0-3.el7.remi.x86_64
---> パッケージ php74-php-fpm.x86_64 0:7.4.26-1.el7.remi を インストール
--> トランザクションの確認を実行しています。
---> パッケージ php74-php-cli.x86_64 0:7.4.26-1.el7.remi を インストール
---> パッケージ php74-php-common.x86_64 0:7.4.26-1.el7.remi を インストール
--> 依存性の処理をしています: php74-php-json(x86-64) = 7.4.26-1.el7.remi のパッケージ: php74-php-common-7.4.26-1.el7.remi.x86_64
---> パッケージ php74-runtime.x86_64 0:1.0-3.el7.remi を インストール
--> 依存性の処理をしています: /usr/sbin/semanage のパッケージ: php74-runtime-1.0-3.el7.remi.x86_64
--> 依存性の処理をしています: environment-modules のパッケージ: php74-runtime-1.0-3.el7.remi.x86_64
--> 依存性の処理をしています: scl-utils のパッケージ: php74-runtime-1.0-3.el7.remi.x86_64
--> トランザクションの確認を実行しています。
---> パッケージ environment-modules.x86_64 0:3.2.10-10.el7 を インストール
--> 依存性の処理をしています: libtcl8.5.so()(64bit) のパッケージ: environment-modules-3.2.10-10.el7.x86_64
--> 依存性の処理をしています: libX11.so.6()(64bit) のパッケージ: environment-modules-3.2.10-10.el7.x86_64
---> パッケージ php74-php-json.x86_64 0:7.4.26-1.el7.remi を インストール
---> パッケージ policycoreutils-python.x86_64 0:2.5-34.el7 を インストール
--> 依存性の処理をしています: setools-libs >= 3.3.8-4 のパッケージ: policycoreutils-python-2.5-34.el7.x86_64
--> 依存性の処理をしています: libsemanage-python >= 2.5-14 のパッケージ: policycoreutils-python-2.5-34.el7.x86_64
--> 依存性の処理をしています: audit-libs-python >= 2.1.3-4 のパッケージ: policycoreutils-python-2.5-34.el7.x86_64
--> 依存性の処理をしています: python-IPy のパッケージ: policycoreutils-python-2.5-34.el7.x86_64
--> 依存性の処理をしています: libqpol.so.1(VERS_1.4)(64bit) のパッケージ: policycoreutils-python-2.5-34.el7.x86_64
--> 依存性の処理をしています: libqpol.so.1(VERS_1.2)(64bit) のパッケージ: policycoreutils-python-2.5-34.el7.x86_64
--> 依存性の処理をしています: libcgroup のパッケージ: policycoreutils-python-2.5-34.el7.x86_64
--> 依存性の処理をしています: libapol.so.4(VERS_4.0)(64bit) のパッケージ: policycoreutils-python-2.5-34.el7.x86_64
--> 依存性の処理をしています: checkpolicy のパッケージ: policycoreutils-python-2.5-34.el7.x86_64
--> 依存性の処理をしています: libqpol.so.1()(64bit) のパッケージ: policycoreutils-python-2.5-34.el7.x86_64
--> 依存性の処理をしています: libapol.so.4()(64bit) のパッケージ: policycoreutils-python-2.5-34.el7.x86_64
---> パッケージ scl-utils.x86_64 0:20130529-19.el7 を インストール
--> トランザクションの確認を実行しています。
---> パッケージ audit-libs-python.x86_64 0:2.8.5-4.el7 を インストール
---> パッケージ checkpolicy.x86_64 0:2.5-8.el7 を インストール
---> パッケージ libX11.x86_64 0:1.6.7-4.el7_9 を インストール
--> 依存性の処理をしています: libX11-common >= 1.6.7-4.el7_9 のパッケージ: libX11-1.6.7-4.el7_9.x86_64
--> 依存性の処理をしています: libxcb.so.1()(64bit) のパッケージ: libX11-1.6.7-4.el7_9.x86_64
---> パッケージ libcgroup.x86_64 0:0.41-21.el7 を インストール
---> パッケージ libsemanage-python.x86_64 0:2.5-14.el7 を インストール
---> パッケージ python-IPy.noarch 0:0.75-6.el7 を インストール
---> パッケージ setools-libs.x86_64 0:3.3.8-4.el7 を インストール
---> パッケージ tcl.x86_64 1:8.5.13-8.el7 を インストール
--> トランザクションの確認を実行しています。
---> パッケージ libX11-common.noarch 0:1.6.7-4.el7_9 を インストール
---> パッケージ libxcb.x86_64 0:1.13-1.el7 を インストール
--> 依存性の処理をしています: libXau.so.6()(64bit) のパッケージ: libxcb-1.13-1.el7.x86_64
--> トランザクションの確認を実行しています。
---> パッケージ libXau.x86_64 0:1.0.8-2.1.el7 を インストール
--> 依存性解決を終了しました。

依存性を解決しました

===================================================================================================================================================================================================================
 Package                                                    アーキテクチャー                           バージョン                                              リポジトリー                                   容量
===================================================================================================================================================================================================================
インストール中:
 php74                                                      x86_64                                     1.0-3.el7.remi                                          remi-safe                                     2.6 k
 php74-php-fpm                                              x86_64                                     7.4.26-1.el7.remi                                       remi-safe                                     1.8 M
依存性関連でのインストールをします:
 audit-libs-python                                          x86_64                                     2.8.5-4.el7                                             base                                           76 k
 checkpolicy                                                x86_64                                     2.5-8.el7                                               base                                          295 k
 environment-modules                                        x86_64                                     3.2.10-10.el7                                           base                                          107 k
 libX11                                                     x86_64                                     1.6.7-4.el7_9                                           updates                                       607 k
 libX11-common                                              noarch                                     1.6.7-4.el7_9                                           updates                                       164 k
 libXau                                                     x86_64                                     1.0.8-2.1.el7                                           base                                           29 k
 libcgroup                                                  x86_64                                     0.41-21.el7                                             base                                           66 k
 libsemanage-python                                         x86_64                                     2.5-14.el7                                              base                                          113 k
 libxcb                                                     x86_64                                     1.13-1.el7                                              base                                          214 k
 php74-php-cli                                              x86_64                                     7.4.26-1.el7.remi                                       remi-safe                                     3.5 M
 php74-php-common                                           x86_64                                     7.4.26-1.el7.remi                                       remi-safe                                     697 k
 php74-php-json                                             x86_64                                     7.4.26-1.el7.remi                                       remi-safe                                      77 k
 php74-runtime                                              x86_64                                     1.0-3.el7.remi                                          remi-safe                                     1.1 M
 policycoreutils-python                                     x86_64                                     2.5-34.el7                                              base                                          457 k
 python-IPy                                                 noarch                                     0.75-6.el7                                              base                                           32 k
 scl-utils                                                  x86_64                                     20130529-19.el7                                         base                                           24 k
 setools-libs                                               x86_64                                     3.3.8-4.el7                                             base                                          620 k
 tcl                                                        x86_64                                     1:8.5.13-8.el7                                          base                                          1.9 M

トランザクションの要約
===================================================================================================================================================================================================================
インストール  2 パッケージ (+18 個の依存関係のパッケージ)

総ダウンロード容量: 12 M
インストール容量: 39 M
Is this ok [y/d/N]: y
Downloading packages:
(1/20): audit-libs-python-2.8.5-4.el7.x86_64.rpm                                                                                                                                            |  76 kB  00:00:00
(2/20): libX11-1.6.7-4.el7_9.x86_64.rpm                                                                                                                                                     | 607 kB  00:00:00
(3/20): environment-modules-3.2.10-10.el7.x86_64.rpm                                                                                                                                        | 107 kB  00:00:00
(4/20): libX11-common-1.6.7-4.el7_9.noarch.rpm                                                                                                                                              | 164 kB  00:00:00
(5/20): libXau-1.0.8-2.1.el7.x86_64.rpm                                                                                                                                                     |  29 kB  00:00:00
(6/20): libcgroup-0.41-21.el7.x86_64.rpm                                                                                                                                                    |  66 kB  00:00:00
(7/20): checkpolicy-2.5-8.el7.x86_64.rpm                                                                                                                                                    | 295 kB  00:00:00
(8/20): libsemanage-python-2.5-14.el7.x86_64.rpm                                                                                                                                            | 113 kB  00:00:00
(9/20): libxcb-1.13-1.el7.x86_64.rpm                                                                                                                                                        | 214 kB  00:00:00
warning: /var/cache/yum/x86_64/7/remi-safe/packages/php74-1.0-3.el7.remi.x86_64.rpm: Header V4 DSA/SHA1 Signature, key ID 00f97f56: NOKEY
php74-1.0-3.el7.remi.x86_64.rpm の公開鍵がインストールされていません
(10/20): php74-1.0-3.el7.remi.x86_64.rpm                                                                                                                                                    | 2.6 kB  00:00:00
(11/20): php74-php-common-7.4.26-1.el7.remi.x86_64.rpm                                                                                                                                      | 697 kB  00:00:00
(12/20): php74-php-cli-7.4.26-1.el7.remi.x86_64.rpm                                                                                                                                         | 3.5 MB  00:00:01
(13/20): php74-php-json-7.4.26-1.el7.remi.x86_64.rpm                                                                                                                                        |  77 kB  00:00:00
(14/20): php74-php-fpm-7.4.26-1.el7.remi.x86_64.rpm                                                                                                                                         | 1.8 MB  00:00:00
(15/20): php74-runtime-1.0-3.el7.remi.x86_64.rpm                                                                                                                                            | 1.1 MB  00:00:00
(16/20): policycoreutils-python-2.5-34.el7.x86_64.rpm                                                                                                                                       | 457 kB  00:00:00
(17/20): python-IPy-0.75-6.el7.noarch.rpm                                                                                                                                                   |  32 kB  00:00:00
(18/20): scl-utils-20130529-19.el7.x86_64.rpm                                                                                                                                               |  24 kB  00:00:00
(19/20): setools-libs-3.3.8-4.el7.x86_64.rpm                                                                                                                                                | 620 kB  00:00:00
(20/20): tcl-8.5.13-8.el7.x86_64.rpm                                                                                                                                                        | 1.9 MB  00:00:00
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
合計                                                                                                                                                                               3.1 MB/s |  12 MB  00:00:03
file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi から鍵を取得中です。
Importing GPG key 0x00F97F56:
 Userid     : "Remi Collet <RPMS@FamilleCollet.com>"
 Fingerprint: 1ee0 4cce 88a4 ae4a a29a 5df5 004e 6f47 00f9 7f56
 Package    : remi-release-7.9-2.el7.remi.noarch (@/remi-release-7)
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-remi
上記の処理を行います。よろしいでしょうか？ [y/N]y
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  インストール中          : setools-libs-3.3.8-4.el7.x86_64                                                                                                                                                   1/20
  インストール中          : libX11-common-1.6.7-4.el7_9.noarch                                                                                                                                                2/20
  インストール中          : libcgroup-0.41-21.el7.x86_64                                                                                                                                                      3/20
  インストール中          : audit-libs-python-2.8.5-4.el7.x86_64                                                                                                                                              4/20
  インストール中          : python-IPy-0.75-6.el7.noarch                                                                                                                                                      5/20
  インストール中          : libsemanage-python-2.5-14.el7.x86_64                                                                                                                                              6/20
  インストール中          : libXau-1.0.8-2.1.el7.x86_64                                                                                                                                                       7/20
  インストール中          : libxcb-1.13-1.el7.x86_64                                                                                                                                                          8/20
  インストール中          : libX11-1.6.7-4.el7_9.x86_64                                                                                                                                                       9/20
  インストール中          : scl-utils-20130529-19.el7.x86_64                                                                                                                                                 10/20
  インストール中          : checkpolicy-2.5-8.el7.x86_64                                                                                                                                                     11/20
  インストール中          : policycoreutils-python-2.5-34.el7.x86_64                                                                                                                                         12/20
  インストール中          : 1:tcl-8.5.13-8.el7.x86_64                                                                                                                                                        13/20
  インストール中          : environment-modules-3.2.10-10.el7.x86_64                                                                                                                                         14/20
  インストール中          : php74-runtime-1.0-3.el7.remi.x86_64                                                                                                                                              15/20
  インストール中          : php74-php-json-7.4.26-1.el7.remi.x86_64                                                                                                                                          16/20
  インストール中          : php74-php-common-7.4.26-1.el7.remi.x86_64                                                                                                                                        17/20
  インストール中          : php74-php-cli-7.4.26-1.el7.remi.x86_64                                                                                                                                           18/20
  インストール中          : php74-1.0-3.el7.remi.x86_64                                                                                                                                                      19/20
  インストール中          : php74-php-fpm-7.4.26-1.el7.remi.x86_64                                                                                                                                           20/20
  検証中                  : 1:tcl-8.5.13-8.el7.x86_64                                                                                                                                                         1/20
  検証中                  : checkpolicy-2.5-8.el7.x86_64                                                                                                                                                      2/20
  検証中                  : scl-utils-20130529-19.el7.x86_64                                                                                                                                                  3/20
  検証中                  : libXau-1.0.8-2.1.el7.x86_64                                                                                                                                                       4/20
  検証中                  : libX11-1.6.7-4.el7_9.x86_64                                                                                                                                                       5/20
  検証中                  : libsemanage-python-2.5-14.el7.x86_64                                                                                                                                              6/20
  検証中                  : php74-php-common-7.4.26-1.el7.remi.x86_64                                                                                                                                         7/20
  検証中                  : php74-1.0-3.el7.remi.x86_64                                                                                                                                                       8/20
  検証中                  : php74-runtime-1.0-3.el7.remi.x86_64                                                                                                                                               9/20
  検証中                  : php74-php-fpm-7.4.26-1.el7.remi.x86_64                                                                                                                                           10/20
  検証中                  : python-IPy-0.75-6.el7.noarch                                                                                                                                                     11/20
  検証中                  : php74-php-cli-7.4.26-1.el7.remi.x86_64                                                                                                                                           12/20
  検証中                  : php74-php-json-7.4.26-1.el7.remi.x86_64                                                                                                                                          13/20
  検証中                  : environment-modules-3.2.10-10.el7.x86_64                                                                                                                                         14/20
  検証中                  : libxcb-1.13-1.el7.x86_64                                                                                                                                                         15/20
  検証中                  : policycoreutils-python-2.5-34.el7.x86_64                                                                                                                                         16/20
  検証中                  : audit-libs-python-2.8.5-4.el7.x86_64                                                                                                                                             17/20
  検証中                  : libcgroup-0.41-21.el7.x86_64                                                                                                                                                     18/20
  検証中                  : libX11-common-1.6.7-4.el7_9.noarch                                                                                                                                               19/20
  検証中                  : setools-libs-3.3.8-4.el7.x86_64                                                                                                                                                  20/20

インストール:
  php74.x86_64 0:1.0-3.el7.remi                                                                      php74-php-fpm.x86_64 0:7.4.26-1.el7.remi

依存性関連をインストールしました:
  audit-libs-python.x86_64 0:2.8.5-4.el7           checkpolicy.x86_64 0:2.5-8.el7                       environment-modules.x86_64 0:3.2.10-10.el7            libX11.x86_64 0:1.6.7-4.el7_9
  libX11-common.noarch 0:1.6.7-4.el7_9             libXau.x86_64 0:1.0.8-2.1.el7                        libcgroup.x86_64 0:0.41-21.el7                        libsemanage-python.x86_64 0:2.5-14.el7
  libxcb.x86_64 0:1.13-1.el7                       php74-php-cli.x86_64 0:7.4.26-1.el7.remi             php74-php-common.x86_64 0:7.4.26-1.el7.remi           php74-php-json.x86_64 0:7.4.26-1.el7.remi
  php74-runtime.x86_64 0:1.0-3.el7.remi            policycoreutils-python.x86_64 0:2.5-34.el7           python-IPy.noarch 0:0.75-6.el7                        scl-utils.x86_64 0:20130529-19.el7
  setools-libs.x86_64 0:3.3.8-4.el7                tcl.x86_64 1:8.5.13-8.el7

完了しました!

[suzuki@suzuki-t ~]$ php74 -v
PHP 7.4.26 (cli) (built: Nov 16 2021 15:31:30) ( NTS )
Copyright (c) The PHP Group
Zend Engine v3.4.0, Copyright (c) Zend Technologies

[suzuki@suzuki-t ~]$ yum list installed | grep php74
php74.x86_64                         1.0-3.el7.remi                 @remi-safe
php74-php-cli.x86_64                 7.4.26-1.el7.remi              @remi-safe
php74-php-common.x86_64              7.4.26-1.el7.remi              @remi-safe
php74-php-fpm.x86_64                 7.4.26-1.el7.remi              @remi-safe
php74-php-json.x86_64                7.4.26-1.el7.remi              @remi-safe
php74-runtime.x86_64                 1.0-3.el7.remi                 @remi-safe

#php74コマンドをphpに変更し使う
[suzuki@suzuki-t ~]$ alias php="php74"
[suzuki@suzuki-t ~]$ php -v
PHP 7.4.26 (cli) (built: Nov 16 2021 15:31:30) ( NTS )
Copyright (c) The PHP Group
Zend Engine v3.4.0, Copyright (c) Zend Technologies

```

## nginxの設定
```
#8080portを解放しておく
iptables -I INPUT 5 -p tcp --dport 8080 -j ACCEPT

#表示するファイルを作成しておく
[suzuki@suzuki-t ~]$ sudo mkdir -p /var/www/html
[suzuki@suzuki-t ~]$ ls -l /var/www/html/
合計 0
#htmlの作成
sudo sh -c 'echo "<html><p>Hello world</p></html>" >> /var/www/html/index.html'

#権限をnginxに
sudo chown -R nginx:adm /var/www/html
```
```
/etc/nginx/nginx.conf

#最大同時接続数を設定する
#サーバーのcpuコア数
grep processor /proc/cpuinfo | wc -l
2

#上記コマンドで確認した数値を設定
worker_processes  2;

#１つのワーカープロセスが同時に処理できる最大接続数を設定
ulimit -n
1024

#上記コマンドで確認した値を入れる
events {
    worker_connections  1024;
}

# MIMEタイプと拡張子関連付け定義ファイルを読み込む
include /etc/nginx/mime.types;

# 拡張子関連づけ定義を使っても解決できなかった拡張子に対して、
# ファイルの種類がわからないと言うMIMEを付与する
default_type application/octet-stream;
```
