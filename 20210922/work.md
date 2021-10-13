20210921までの作業をして実際にhttps://suzuki-t.comを開いてもERR_SSL_PROTOCOL_ERRORが表示されてページが開かない

/usr/local/httpd/httpd-2.4.48/conf/extra/httpd-ssl.confの変更が必要？

サーバーネームを変更
↓
ng
↓
バーチャルホストの設定っぽいので<VirtualHost _default_:443>を<VirtualHost 192.168.56.2:443>に変更
↓
ng
↓
virtualhostの443port用の設定を持ってくることに
↓
ok
```
[suzuki@localhost wordpress]$ sudo vi /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-ssl.conf
[suzuki@localhost wordpress]$ diff /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-ssl.conf /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-ssl.conf.bak_20210917
121c121
< <VirtualHost 192.168.56.2:443>
---
> <VirtualHost _default_:443>
124,125c124,125
< DocumentRoot "/var/www/html/"
< ServerName suzuki-t.com
---
> DocumentRoot "/usr/local/httpd/httpd-2.4.48/htdocs"
> ServerName www.example.com:443
129,135d128
< <Directory "/var/www/html/">
<     Require all granted
<     <FilesMatch \.php$>
<          SetHandler application/x-httpd-php
<     </FilesMatch>
< </Directory>
<


[suzuki@localhost wordpress]$ sudo vi /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf
[suzuki@localhost wordpress]$ diff /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf.org
23,37c23,29
<
<
< <VirtualHost 192.168.56.2:80>
<   DocumentRoot "/var/www/html"
<   ServerName suzuki-t.com
<   RewriteEngine on
<   RewriteCond %{HTTPS} off
<   RewriteRule https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]
<
<     <Directory "/var/www/html">
<          Require all granted
<        <FilesMatch \.php$>
<              SetHandler application/x-httpd-php
<          </FilesMatch>
<     </Directory>
---
> <VirtualHost *:80>
>     ServerAdmin webmaster@dummy-host.example.com
>     DocumentRoot "/usr/local/httpd/httpd-2.4.48/docs/dummy-host.example.com"
>     ServerName dummy-host.example.com
>     ServerAlias www.dummy-host.example.com
>     ErrorLog "logs/dummy-host.example.com-error_log"
>     CustomLog "logs/dummy-host.example.com-access_log" common
40,54c32,37
< #<VirtualHost 192.168.56.2:443>
< #  DocumentRoot "/var/www/html443"
< #  ServerName suzuki-t.com
< #    <Directory "/var/www/html443">
< #         Require all granted
< #    </Directory>
< #</VirtualHost>
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
```

# httpでの通信をhttpsになるよう設定する
```
[suzuki@localhost wordpress]$ sudo vi /usr/local/httpd/httpd-2.4.48/conf/httpd.conf

#下記3行の追加

RewriteEngine on　　urlの書き換えを行う
RewriteCond %{HTTPS} off　httpsじゃなかった場合(condが条件)
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]



Invalid command 'RewriteEngine', perhaps misspelled or defined by a module not included in the server configuration

コメントアウトを外す
LoadModule rewrite_module modules/mod_rewrite.so

ok

virtualhost単位で設定することにする

ok

[suzuki@localhost wordpress]$ diff /usr/local/httpd/httpd-2.4.48/conf/httpd.conf /usr/local/httpd/httpd-2.4.48/conf/httpd.conf.org
88c88
< LoadModule socache_shmcb_module modules/mod_socache_shmcb.so
---
> #LoadModule socache_shmcb_module modules/mod_socache_shmcb.so
134c134
< LoadModule ssl_module modules/mod_ssl.so
---
> #LoadModule ssl_module modules/mod_ssl.so
153,154c153
< LoadModule rewrite_module modules/mod_rewrite.so
< LoadModule php7_module        modules/libphp7.so
---
> #LoadModule rewrite_module modules/mod_rewrite.so
254c253
<     DirectoryIndex index.html index.php
---
>     DirectoryIndex index.html
479c478
< Include conf/extra/httpd-vhosts.conf
---
> #Include conf/extra/httpd-vhosts.conf
496c495
< Include conf/extra/httpd-ssl.conf
---
> #Include conf/extra/httpd-ssl.conf
505a505
>
```