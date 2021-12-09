- DBの保存
  - レプリケーション
    - ハードウェアを含め同じシステム環境が2セット（稼働系と待機系）用意された環境において リアルタイムにデータ複製する
    - リアルタイムで待機系もデータの更新されてしまう為、間違って削除したりしても戻せない為、バックアップは同時に行う必要がある
    - リアルタイムで同じデータを共有しているので障害からの復旧は早い
  - ダンプファイル
    - データをそのままの形で出力したもの
  - [スナップショット](https://www.forcemedia.co.jp/blog/snapshot-1)
    - その時点の状態を、そのまま丸ごと保存したもの
    - あくまでもある時点のイメージが同一ストレージ内に保存されているだけなのでディスク故障が発生した場合は、データを復旧することはできない


## [SElinux](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/6/html/security-enhanced_linux/index)
- SELinuxを利用すると細かいアクセス制御が可能になる。例えば、サービス毎に最小限の権限を与え管理することなどが可能になる
- 設定の確認 sestatusコマンド
  - enforcing SELinux有効でありアクセス制御が有効となる
  - permissive アクセス制御は無効だが警告メッセージを表示する
  - disabled SELinux無効
- /etc/sysconfig/selinux 設定ファイル
- 設定変更
  - setenforceコマンド
  - enforcingとpermissiveの変更が出来る
    - 「setenforce 1」がenforcing
    - 「setenforce 0」がpermissive
  - 設定ファイルを変更してもこの処理をしないと反映されない


## alias
```
[suzuki@suzuki-t ~]$ alias php='php74'
[suzuki@suzuki-t ~]$ php -v
PHP 7.4.26 (cli) (built: Nov 16 2021 15:31:30) ( NTS )
Copyright (c) The PHP Group
Zend Engine v3.4.0, Copyright (c) Zend Technologies

[suzuki@suzuki-t ~]$ sudo vi /etc/bashrc
alias php='php74'
```

## bash起動時の設定
- /etc/bashrc　全ユーザー
- 画面上からbashを起動したときに読み込まれるのが「.bashrc」
  - 各ユーザーのhomeディレクトリにあり、各ユーザーごとの設定が出来る
- ログインシェルがbashでログインしたときに読み込まれるのが「.bash_profile」
- ログインシェルがbashでログインしたときに「.bashrc」は読み込まれないが「.bash_profile」の中で読み込むように指定されている場合は「.bashrc」も読み込まれる


## phpの設定
```
[suzuki@suzuki-t ~]$ sudo vi /etc/opt/remi/php74/php.ini
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
```

## php-fpm
- [設定](https://www.php.net/manual/ja/install.fpm.configuration.php)
```
[suzuki@suzuki-t ~]$ systemctl status php74-php-fpm

```
- systemctlでの管理ファイル
  - /usr/lib/systemd/system/php74-php-fpm.service
  - デフォルトで問題なし
- 全体の設定(プールごとの設定はここで読み込む)
  - /etc/opt/remi/php74/php-fpm.conf
- プールごとの設定
  - /etc/opt/remi/php74/php-fpm.d/www.conf

- [参考](https://qiita.com/kotarella1110/items/634f6fafeb33ae0f51dc)

- nginxとの連携
  - /etc/opt/remi/php74/php-fpm.d/www.conf
    - listen = 192.168.56.3:8080
  - /etc/nginx/nginx.conf

```
user  nginx;
worker_processes  auto;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

   server {
       listen      192.168.56.3:80;
       server_name suzuki-t.com;

       access_log  /var/log/nginx/access.log  main;
       error_log  /var/log/nginx/error.log notice;

       location / {
           allow all;
           root   /var/www/html;
           index  index.html index.php;
       }

       location ~ \.php$ {
            root /var/www/html;
            fastcgi_pass  192.168.56.3:8080;
            fastcgi_index  index.php;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include       fastcgi_params;
        }

   }


    keepalive_timeout  65;
}
```
