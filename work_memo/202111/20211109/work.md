## varnish用語
[全体](https://varnish-cache.org/)
- hit
  - キャッシュから配信するオブジェクト
- miss
  - クライアントに提供する前に、バックエンドからフェッチするオブジェクト。オブジェクトは、キャッシュに入れられる場合と入れられない場合がある
- pass
  - 現在のリクエストがキャッシュを使用せず、そのレスポンスをキャッシュに入れないようにします。
- pipe
  - Varnish just moves the bytes between client and backend, it does not try to understand what they mean
- hash
  - hashのキーはリクエストのURLとドメイン/IPアドレス
  - return(hash)を呼ぶとvcl_hashが呼び出され、vcl_hshの最後にreturn(lookup)が呼び出されている
- [vcl参考](https://blog.kasei-san.com/entry/2019/01/24/000222?utm_source=feed)

- varnishhist
  - 共有メモリログを読み取り、処理ごとの最後のN個の要求の分布を示す継続的に更新されるヒストグラムを表示
  - ヒットはパイプ文字（|）でマークされ、ミスはハッシュ文字（＃）でマークされる
  - X軸はカーネルとvarnishの対話、応答時間、1e1 = 10秒,1e0 = 1秒,1e-1 = 0.1秒または100ミリ秒（ミリ秒）等
- varnishlog
  - ログをネイティブ形式で表示するプログラム。
- varnishncsa
  - ログを「NCSA」形式で表示するプログラム。
- varnishstat
  - 実行中のvarnishdから統計を表示する
  - -1で記録の一覧を表示
  - -1を付けずに実行すればページを開く度に更新される
  - hit数や応答時間等表示する
- varnishtest
  - varnishdの動作をテストするプログラム、スクリプトを元に実行される
- varnishtop
  - リクエストやレスポンスの内容をリアルタイムで表示する
- varnishadm
  - VCLプログラムのロード/使用/破棄,リアルタイムで設定の反映が出来る
    - vcl.loadでファイルをロードして管理
    - vcl.useで現在使用するvclファイルを設定
  - キャッシュコンテンツを禁止する(banコマンド、正規表現を用いる)
  - 200と201はOK,それ以外は何らかのエラー

### ネイティブ形式
- ソフトウェア独自の保存形式

### NCSA形式
- サーバー側ログの１つ
-  ASCII テキストベース

## cliで設定ファイルを反映する
```
[suzuki@suzuki-t ~]$ sudo vi /usr/local/varnish/test.vcl
vcl 4.0;

backend default {
  .host = "192.168.56.3";
  .port = "8080";
}

sub vcl_recv {
 if(req.url ~ "wordpress") {
   return (pass);
 }else{
   return (hash);
 }
}


[suzuki@suzuki-t ~]$ sudo /usr/local/varnish/bin/varnishadm

vcl.load default /usr/local/varnish/default.vcl
200

vcl.list
200
active      auto    warm         0    boot
available   auto    warm         0    default

vcl.load test /usr/local/varnish/test.vcl
200

vcl.load
varnish> vcl.list
200
active      auto    warm         0    boot
available   auto    warm         0    default
available   auto    warm         0    test

vcl.use test
200
VCL 'test' now active
vcl.use tlist
[suzuki@suzuki-t ~]$ sudo /usr/local/varnish/bin/varnishadm
200
-----------------------------
Varnish Cache CLI 1.0
-----------------------------
Linux,3.10.0-1160.42.2.el7.x86_64,x86_64,-jnone,-smalloc,-sdefault,-hcritbit
varnish-7.0.0 revision 454733b82a3279a1603516b4f0a07f8bad4bcd55

Type 'help' for command list.
Type 'quit' to close CLI session.

vcl.list
200
available   auto    warm         0    boot
available   auto    warm         0    default
active      auto    warm         0    test


#反映後(12時59分以降)
[09/Nov/2021:11:47:15 +0900] GET suzuki-t.com /wordpress/ 200 miss
[09/Nov/2021:11:47:15 +0900] GET suzuki-t.com /wordpress/wp-includes/css/dist/block-library/style.min.css 200 hit
[09/Nov/2021:11:47:15 +0900] GET suzuki-t.com /wordpress/wp-content/themes/twentytwentyone/style.css 200 hit
[09/Nov/2021:11:47:15 +0900] GET suzuki-t.com /wordpress/wp-includes/js/comment-reply.min.js 200 miss
[09/Nov/2021:11:47:15 +0900] GET suzuki-t.com /wordpress/wp-includes/js/wp-emoji-release.min.js 200 hit
[09/Nov/2021:11:47:15 +0900] GET suzuki-t.com /wordpress/wp-content/themes/twentytwentyone/assets/css/print.css 200 hit
[09/Nov/2021:11:48:39 +0900] GET suzuki-t.com /wordpress/ 200 hit
[09/Nov/2021:11:48:39 +0900] GET suzuki-t.com /wordpress/wp-includes/css/dist/block-library/style.min.css 200 hit
[09/Nov/2021:11:48:39 +0900] GET suzuki-t.com /wordpress/wp-content/themes/twentytwentyone/style.css 200 hit
[09/Nov/2021:11:48:39 +0900] GET suzuki-t.com /wordpress/wp-includes/js/wp-emoji-release.min.js 200 hit
[09/Nov/2021:11:48:39 +0900] GET suzuki-t.com /wordpress/wp-content/themes/twentytwentyone/assets/css/print.css 200 hit
[09/Nov/2021:12:43:55 +0900] GET 192.168.56.3 / 200 miss
[09/Nov/2021:12:59:08 +0900] POST suzuki-t.com /wordpress/wp-cron.php 200 pass
[09/Nov/2021:12:59:07 +0900] GET suzuki-t.com /wordpress/ 200 pass
[09/Nov/2021:12:59:09 +0900] GET suzuki-t.com /wordpress/wp-includes/css/dist/block-library/style.min.css 200 pass
[09/Nov/2021:12:59:09 +0900] GET suzuki-t.com /wordpress/wp-content/themes/twentytwentyone/assets/js/responsive-embeds.js 200 pass
[09/Nov/2021:12:59:09 +0900] GET suzuki-t.com /wordpress/wp-content/themes/twentytwentyone/style.css 200 pass
[09/Nov/2021:12:59:09 +0900] GET suzuki-t.com /wordpress/wp-includes/js/wp-embed.min.js 200 pass
[09/Nov/2021:12:59:09 +0900] GET suzuki-t.com /wordpress/wp-includes/js/wp-emoji-release.min.js 200 pass
[09/Nov/2021:12:59:09 +0900] GET suzuki-t.com /wordpress/wp-content/themes/twentytwentyone/assets/css/print.css 200 pass
[09/Nov/2021:12:59:19 +0900] GET suzuki-t.com /wordpress/ 200 pass
[09/Nov/2021:12:59:19 +0900] GET suzuki-t.com /wordpress/wp-includes/js/wp-emoji-release.min.js 200 pass
[09/Nov/2021:12:59:23 +0900] GET suzuki-t.com /wordpress/ 200 pass
[09/Nov/2021:12:59:27 +0900] GET suzuki-t.com /wordpress/ 200 pass
[09/Nov/2021:12:59:28 +0900] GET suzuki-t.com /wordpress/wp-includes/js/comment-reply.min.js 200 pass
[09/Nov/2021:12:59:28 +0900] GET suzuki-t.com /wordpress/wp-includes/js/wp-emoji-release.min.js 200 pass
[09/Nov/2021:12:59:31 +0900] GET suzuki-t.com /wordpress/ 200 pass

```

### varnish設定手順まとめ
```
#varnish###################################################################
cd /usr/local/src

curl -OL https://varnish-cache.org/_downloads/varnish-7.0.0.tgz

tar -xvf varnish-7.0.0.tgz

cd varnish-7.0.0

yum install -y autoconf automake jemalloc-devel libedit-devel libtool libunwind-devel ncurses-devel pcre2-devel python3-sphinx python36-docutils.noarch python3-devel

./configure --prefix=/usr/local/varnish

make

make install

ldconfig

####################################

#varnish用にapacheの設定
patch /usr/local/httpd/httpd-2.4.48/conf/httpd.conf << EOF
52c52
< Listen 80
---
> Listen 8080
117c117
< #LoadModule proxy_module modules/mod_proxy.so
---
> LoadModule proxy_module modules/mod_proxy.so
120c120
< #LoadModule proxy_http_module modules/mod_proxy_http.so
---
> LoadModule proxy_http_module modules/mod_proxy_http.so
155d154
< LoadModule php7_module        modules/libphp7.so
462c461
< #Include conf/extra/httpd-mpm.conf
---
> Include conf/extra/httpd-mpm.conf
EOF

#virtualhostの設定
#バックアップ
cp /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf_`date +"%Y%m%d%I%M%S"`
#ファイルを空に
echo -n > /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf
#ファイルに設定を入れる
patch /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf << EOF
0a1,63
> # Virtual Hosts
> #
> # Required modules: mod_log_config
> #
> # If you want to maintain multiple domains/hostnames on your
> # machine you can setup VirtualHost containers for them. Most configurations
> # use only name-based virtual hosts so the server doesn't need to worry about
> # IP addresses. This is indicated by the asterisks in the directives below.
> #
> # Please see the documentation at
> # <URL:http://httpd.apache.org/docs/2.4/vhosts/>
> # for further details before you try to setup virtual hosts.
> #
> # You may use the command line option '-S' to verify your virtual host
> # configuration.
> #
> #
> # VirtualHost example:
> # Almost any Apache directive may go into a VirtualHost container.
> # The first VirtualHost section is used for all requests that do not
> # match a ServerName or ServerAlias in any <VirtualHost> block.
> #
> <VirtualHost 192.168.56.3:8080>
>     SetEnvIf X-Forwarded-Proto https HTTPS=on
>     DocumentRoot "/var/www/html"
>     ServerName suzuki-t.com
>     RewriteEngine on
>     RewriteCond %{HTTPS} off
>     RewriteRule https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]
>       <Directory "/var/www/html/">
>               Require all granted
>               <FilesMatch \.php$>
>                       SetHandler application/x-httpd-php
>               </FilesMatch>
>       </Directory>
>       <Directory "/var/www/html/wordpress/wp-admin">
>                 AuthType Basic
>                 AuthName "auth"
>                 AuthUserFile /usr/local/httpd/httpd-2.4.48/htpasswd
>               Require valid-user
>       </Directory>
> </VirtualHost>
> #
> <VirtualHost 192.168.56.3:8080>
>     SetEnvIf X-Forwarded-Proto https HTTPS=on
>     DocumentRoot "/var/www/html2"
>     ServerName suzuki-t.net
>     RewriteEngine on
>     RewriteCond %{HTTPS} off
>     RewriteRule https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]
>       <Directory "/var/www/html2/">
>               Require all granted
>               <FilesMatch \.php$>
>                       SetHandler application/x-httpd-php
>               </FilesMatch>
>       </Directory>
>       <Directory "/var/www/html2/wordpress/wp-admin">
>              AuthType Digest
>                AuthName "auth"
>                 AuthUserFile /usr/local/httpd/httpd-2.4.48/htdigestpasswd
>                 Require valid-user
>         </Directory>
> </VirtualHost>
EOF



#virtualhostの設定
#バックアップ
cp /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-ssl.conf /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-ssl.conf_`date +"%Y%m%d%I%M%S"`
#ファイルを空に
echo -n > /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-ssl.conf
#ファイルに設定を入れる
patch /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-ssl.conf << EOF
0a1,85
> Listen 443
> #
> SSLCipherSuite HIGH:MEDIUM:!MD5:!RC4:!3DES
> SSLProxyCipherSuite HIGH:MEDIUM:!MD5:!RC4:!3DES
> #
> SSLHonorCipherOrder on
> #
> SSLProtocol all -SSLv3
> SSLProxyProtocol all -SSLv3
> #
> SSLPassPhraseDialog  builtin
> #
> SSLSessionCache        "shmcb:/usr/local/httpd/httpd-2.4.48/logs/ssl_scache(512000)"
> SSLSessionCacheTimeout  300
> #
> <VirtualHost 192.168.56.3:443>
> DocumentRoot "/var/www/html"
> ServerName suzuki-t.com
> ServerAdmin you@example.com
> ErrorLog "/usr/local/httpd/httpd-2.4.48/logs/error_log"
> TransferLog "/usr/local/httpd/httpd-2.4.48/logs/access_log"
> #
> #
> #<Directory "/var/www/html/">
> #    Require all granted
> #    <FilesMatch \.php$>
> #        SetHandler application/x-httpd-php
> #    </FilesMatch>
> #</Directory>
> #<Directory "/var/www/html/wordpress/wp-admin">
> #    AuthType Basic
> #    AuthName "auth"
> #    AuthUserFile /usr/local/httpd/httpd-2.4.48/htpasswd
> #    Require valid-user
> #</Directory>
> #
> SSLEngine on
> SSLCertificateFile "/usr/local/httpd/httpd-2.4.48/conf/server.crt"
> SSLCertificateKeyFile "/usr/local/httpd/httpd-2.4.48/conf/server.key"
> #
> RequestHeader set X-Forwarded-Proto "https"
> #
> ProxyPass "/" "http://suzuki-t.com:80/"
> ProxyPassReverse "/" "http://suzuki-t.com:80/"
> #
> <FilesMatch "\.(cgi|shtml|phtml|php)$">
>     SSLOptions +StdEnvVars
> </FilesMatch>
> <Directory "/usr/local/httpd/httpd-2.4.48/cgi-bin">
>     SSLOptions +StdEnvVars
> </Directory>
> #
> BrowserMatch "MSIE [2-5]" \
>          nokeepalive ssl-unclean-shutdown \
>          downgrade-1.0 force-response-1.0
> #
> CustomLog "/usr/local/httpd/httpd-2.4.48/logs/ssl_request_log" \
>           "%t %h %{SSL_PROTOCOL}x %{SSL_CIPHER}x \"%r\" %b"
> </VirtualHost>
> <VirtualHost 192.168.56.3:443>
> DocumentRoot "/var/www/html2"
> ServerName suzuki-t.net
> ServerAdmin you@example.com
> ErrorLog "/usr/local/httpd/httpd-2.4.48/logs/error_log"
> TransferLog "/usr/local/httpd/httpd-2.4.48/logs/access_log"
> #
> #<Directory "/var/www/html2/">
> #   Require all granted
> #   <FilesMatch \.php$>
> #      SetHandler application/x-httpd-php
> #   </FilesMatch>
> #</Directory>
> #<Directory "/var/www/html2/wordpress/wp-admin">
> #   AuthType Digest
> #   AuthName "auth"
> #   AuthUserFile /usr/local/httpd/httpd-2.4.48/htdigestpasswd
> #   Require valid-user
> #</Directory>
> #
> SSLEngine on
> SSLCertificateFile "/usr/local/httpd/httpd-2.4.48/conf/server2.crt"
> SSLCertificateKeyFile "/usr/local/httpd/httpd-2.4.48/conf/server2.key"
> #
> RequestHeader set X-Forwarded-Proto "https"
> #
> ProxyPass "/" "http://suzuki-t.net:80/"
> ProxyPassReverse "/" "http://suzuki-t.net:80/"
> </VirtualHost>
EOF


#apache再起動
systemctl restart httpd

#varnishの設定############################################################################################

#設定ファイル
touch /usr/local/varnish/default.vcl

patch /usr/local/varnish/default.vcl << EOF
0a1,14
> vcl 4.0;
> #
> backend default {
>   .host = "192.168.56.3";
>   .port = "8080";
> }
> #
> sub vcl_recv {
>  if(req.url ~ "wp-admin|wp-login") {
>    return (pass);
>  }else{
>    return (hash);
>  }
> }
EOF

#varnishをsystemctlで管理する設定ファイル
touch /usr/lib/systemd/system/varnish.service

patch /usr/lib/systemd/system/varnish.service << EOF
0a1,13
> [Unit]
> Description=Web Application Accelerator
> After=network.target
> #
> [Service]
> Type=forking
> PIDFile=/usr/local/varnish/varnish.pid
> PrivateTmp=true
> ExecStart=/usr/local/varnish/sbin/varnishd -P /usr/local/varnish/varnish.pid -f /usr/local/varnish/default.vcl -a :80 -s malloc,256M
> ExecReload=/usr/local/varnish/bin/varnish-vcl-reload
> #
> [Install]
> WantedBy=multi-user.target
EOF

#varnishncsa(ロギングプログラム)をsystemctlで管理する設定ファイル
touch /usr/lib/systemd/system/varnishncsa.service

patch /usr/lib/systemd/system/varnishncsa.service << EOF
0a1,10
> [Unit]
> Description=Varnish HTTP accelerator NCSA daemon
> After=varnish.service
> #
> [Service]
> Type=forking
> ExecStart=/usr/local/varnish/bin/varnishncsa -F '%%t %%m %%{Host}i %%U %%s %%{Varnish:handling}x' -w /usr/local/varnish/varnishncsa.log -P /usr/local/varnish/varnishncsa.pid -a -D
> #
> [Install]
> WantedBy=multi-user.target
EOF

#設定ファイルの反映
systemctl daemon-reload

#varnishの起動
systemctl start varnish.service

#自動起動設定
systemctl enable varnish.service

#varnishncsaの起動
systemctl start varnishncsa.service

#自動起動設定
systemctl enable varnishncsa.service
#############################################################################################################################

```

### dateコマンドでファイル名に日付を付ける
cp a.txt a.txt_`date +"%Y%m%d%I%M%S"`




## yumパッケージで環境の構築を行う
### 変更点
- ビルドしていたものをyumパッケージを使うようにする
- apache → nginx
- mod-php → php-fpm

### nginx
- webサーバー
- イベントループ方式（シングルスレッドでループ処理をまわし、キューに溜まったイベントを処理していく処理方式）
- 大量のリクエストを処理出来る
- apacheだと1万リクエストを超えた辺りから処理が重たくなる

### php-fpm
- FastCGI Process Manager (FPM)
- Webサーバとは別のプロセスで実行される
- 別個のプロセスとして動かすぶん、実行する度にメモリのロードが必要となり、動作速度がモジュール版に比べて遅くなる

### CGI
- Webサーバ上に置いてある（クライアントからの要求に応じて動く）プログラムを動かすための仕組み
- FastCGI
  - 一度起動したプログラムは一定期間、メモリ上に展開しておくことにした仕組み
  - プログラムの開始と終了にかかる手間を減らし、動きを速くしたりWebサーバの負荷を軽減することができる
