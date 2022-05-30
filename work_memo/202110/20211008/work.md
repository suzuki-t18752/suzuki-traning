## URLのリストを作成し、ベンチマークテストを行う

[参考](https://yomon.hatenablog.com/entry/2017/05/18/180329)

### 方法
abコマンドに -Rのオプションを追加してURLのリストより読み込む

URLのリストはDBよりタグ、カテゴリーの一覧、総投稿数の取得で作成できる。

```
ab -R ./params.txt -c 5 -n 20 https://suzuki-t.com/wordpress/

#下記でリストを作成する
#投稿
?p=1002
#カテゴリー
?cat=3
#タグ
?tag=test1
#投稿者
?author=1
```

- | tail -n +2 
標準出力の上２行を飛ばして表示、sqlの取得結果の枠線とカラム名を削除している

- | awk '{print "https://suzuki-t.com/wordpress/?tag=",$1}'
標準出力の結果の各行前方に文字列を連結する、DBより取得した値をパラメータに入れる処理

-  | sed 's% %%'
標準出力の各行１番前のスペースを削除している

### 投稿の一覧取得
wp_posts.post_type=post
post_type=revisionはある投稿の更新内容を入れている
guidカラムが各URLになっている

/usr/local/mysql5.7/bin/mysql -u root --socket=/usr/local/mysql5.7/data/mysql.sock -e"select guid from wpdb.wp_posts where post_type='post';" -psuzuki0901 | tail -n +2 > url_list.txt

### ユーザーURL
wp_usersテーブルのIDカラム

/usr/local/mysql5.7/bin/mysql -u root --socket=/usr/local/mysql5.7/data/mysql.sock -e"select ID from wpdb.wp_users;" -psuzuki0901 | tail -n +2 | awk '{print "https://suzuki-t.com/wordpress/?author=",$1}' | sed 's% %%' >> url_list.txt

### タグのURL
wp_term_taxonomyテーブルのtaxonomy='post_tag'で絞り込んだ列とwpdb.wp_termsテーブルの一致した列のname
term_idでjoin


/usr/local/mysql5.7/bin/mysql -u root --socket=/usr/local/mysql5.7/data/mysql.sock -e"select t2.name from wpdb.wp_term_taxonomy as t1 inner join wpdb.wp_terms as t2 on t1.term_id = t2.term_id AND t1.taxonomy='post_tag';" -psuzuki0901  | tail -n +2 | awk '{print "https://suzuki-t.com/wordpress/?tag=",$1}' | sed 's% %%' >> url_list.txt

### カテゴリーのURL
wp_term_taxonomyテーブルのtaxonomy='category'で絞り込んだ列のterm_id

/usr/local/mysql5.7/bin/mysql -u root --socket=/usr/local/mysql5.7/data/mysql.sock -e"select term_id from wpdb.wp_term_taxonomy where taxonomy='category';" -psuzuki0901  | tail -n +2 | awk '{print "https://suzuki-t.com/wordpress/?cat=",$1}' | sed 's% %%' >> url_list.txt

### urlリスト　一部
https://suzuki-t.com/wordpress/?p=992
https://suzuki-t.com/wordpress/?p=993
https://suzuki-t.com/wordpress/?p=994
https://suzuki-t.com/wordpress/?p=995
https://suzuki-t.com/wordpress/?p=996
https://suzuki-t.com/wordpress/?p=997
https://suzuki-t.com/wordpress/?p=998
https://suzuki-t.com/wordpress/?p=999
https://suzuki-t.com/wordpress/?p=1000
https://suzuki-t.com/wordpress/?p=1001
https://suzuki-t.com/wordpress/?p=1002
https://suzuki-t.com/wordpress/?p=1003
https://suzuki-t.com/wordpress/?p=1004
https://suzuki-t.com/wordpress/?author=1
https://suzuki-t.com/wordpress/?tag=test1
https://suzuki-t.com/wordpress/?tag=test2
https://suzuki-t.com/wordpress/?tag=test3
https://suzuki-t.com/wordpress/?cat=1
https://suzuki-t.com/wordpress/?cat=2
https://suzuki-t.com/wordpress/?cat=3





## 全てのシェルスクリプトファイルの先頭ににset -ueを入れる
- -e
エラーが起きた時に停止してくれる

- -u
未定義の変数を使おうとした時にエラーとして扱うようにする



## abコマンドではなくSiegeを使いベンチマークテストを行う
### Siegeのインストール
```
[suzuki@suzuki-t ~]$ cd /usr/local/src/

[suzuki@suzuki-t src]$ sudo curl -OL http://download.joedog.org/siege/siege-latest.tar.gz

[suzuki@suzuki-t src]$ sudo tar -xvf siege-latest.tar.gz

[suzuki@suzuki-t src]$ cd siege-4.1.1/

[suzuki@suzuki-t siege-4.1.1]$ sudo ./configure --prefix=/usr/local/siege
--------------------------------------------------------
Configuration is complete

Run the following commands to complete the installation:
  make
  make install

For complete documentation:        http://www.joedog.org
--------------------------------------------------------

[suzuki@suzuki-t siege-4.1.1]$ sudo make

[suzuki@suzuki-t siege-4.1.1]$ sudo make install

[suzuki@suzuki-t siege]$ /usr/local/siege/bin/siege -V
SIEGE 4.1.1

Copyright (C) 2021 by Jeffrey Fulmer, et al.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.

```
### テスト
- --file=/var/www/html/wordpress/url_list.txt URL一覧のファイルを指定
- --concurrent=100 アクセスさせるユーザー数を指定
- -r アクセス回数の指定
```
[suzuki@suzuki-t ~]$ /usr/local/siege/bin/siege --file=/var/www/html/wordpress/url_list.txt --concurrent=100

Lifting the server siege...
Transactions:                  14292 hits
Availability:                  99.91 %
Elapsed time:                 159.38 secs
Data transferred:             446.56 MB
Response time:                  0.92 secs
Transaction rate:              89.67 trans/sec
Throughput:                     2.80 MB/sec
Concurrency:                   82.69
Successful transactions:       14292
Failed transactions:              13
Longest transaction:           35.90
Shortest transaction:           0.00


[suzuki@suzuki-t ~]$ /usr/local/siege/bin/siege --file=/var/www/html/wordpress/url_list.txt -r 1000 -c 1000

================================================================
WARNING: The number of users is capped at 255.  To increase this
         limit, search your .siegerc file for 'limit' and change
         its value. Make sure you read the instructions there...
================================================================
#今の設定だと255までしかユーザー数の設定が出来ない

#siegeの設定ファイルを編集
[suzuki@suzuki-t ~]$ sudo cp /usr/local/siege/etc/siegerc /usr/local/siege/etc/siegerc_bak
[suzuki@suzuki-t ~]$ sudo vi /usr/local/siege/etc/siegerc
[suzuki@suzuki-t ~]$ diff  /usr/local/siege/etc/siegerc /usr/local/siege/etc/siegerc_bak
202c202
< limit = 1000
---
> limit = 255

#ユーザー数の上限を1000に変更

[suzuki@suzuki-t ~]$ /usr/local/siege/bin/siege --file=/var/www/html/wordpress/url_list.txt -r 1000 -c 1000
siege aborted due to excessive socket failure; you
can change the failure threshold in $HOME/.siegerc

Transactions:                   3873 hits
Availability:                  70.52 %
Elapsed time:                 142.52 secs
Data transferred:             126.28 MB
Response time:                 13.44 secs
Transaction rate:              27.18 trans/sec
Throughput:                     0.89 MB/sec
Concurrency:                  365.29
Successful transactions:        3867
Failed transactions:            1619
Longest transaction:          140.99
Shortest transaction:           0.00

#エラーが発生していた
[Fri Oct 08 14:08:06.376261 2021] [mpm_prefork:error] [pid 2029] AH00161: server reached MaxRequestWorkers setting, consider raising the MaxRequestWorkers setting

192.168.56.3 - - [08/Oct/2021:14:08:03 +0900] "GET /wordpress/?p=108 HTTP/1.1" 500 2539
192.168.56.3 - - [08/Oct/2021:14:08:03 +0900] "GET /wordpress/?p=54 HTTP/1.1" 500 2539
192.168.56.3 - - [08/Oct/2021:14:08:03 +0900] "GET /wordpress/?p=382 HTTP/1.1" 500 2539
192.168.56.3 - - [08/Oct/2021:14:08:03 +0900] "GET /wordpress/?p=144 HTTP/1.1" 500 2539
192.168.56.3 - - [08/Oct/2021:14:08:03 +0900] "GET /wordpress/?p=735 HTTP/1.1" 500 2539
192.168.56.3 - - [08/Oct/2021:14:08:03 +0900] "GET /wordpress/?p=934 HTTP/1.1" 500 2539
192.168.56.3 - - [08/Oct/2021:14:08:03 +0900] "GET /wordpress/?p=736 HTTP/1.1" 500 2539
192.168.56.3 - - [08/Oct/2021:14:08:03 +0900] "GET /wordpress/?p=658 HTTP/1.1" 500 2539
192.168.56.3 - - [08/Oct/2021:14:08:03 +0900] "GET /wordpress/?p=120 HTTP/1.1" 500 2539
192.168.56.3 - - [08/Oct/2021:14:08:03 +0900] "GET /wordpress/?p=423 HTTP/1.1" 500 2539
192.168.56.3 - - [08/Oct/2021:14:08:03 +0900] "GET /wordpress/?p=392 HTTP/1.1" 500 2539
192.168.56.3 - - [08/Oct/2021:14:08:03 +0900] "GET /wordpress/?p=745 HTTP/1.1" 500 2539

[suzuki@suzuki-t ~]$ sudo cp /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-mpm.conf /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-mpm.conf.bak

[suzuki@suzuki-t ~]$ diff /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-mpm.conf /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-mpm.conf.bak
32,33c32
<     ServerLimit           1000
<     MaxRequestWorkers     1000
---
>     MaxRequestWorkers      250


[suzuki@suzuki-t ~]$ diff /usr/local/httpd/httpd-2.4.48/conf/httpd.conf /usr/local/httpd/httpd-2.4.48/conf/httpd.conf.bak
462c462
< Include conf/extra/httpd-mpm.conf
---
> #Include conf/extra/httpd-mpm.conf

[suzuki@suzuki-t ~]$ /usr/local/siege/bin/siege --file=/var/www/html/wordpress/url_list.txt -r 1000 -c 1000
[error] Address resolution failed at sock.c:158 with the following error:: Device or resource busy
[error] System error: Device or resource busy
libgcc_s.so.1 must be installed for pthread_cancel to work


#この表示への対処(libgcc_s.so.1 must be installed for pthread_cancel to work　スレッド(プロセスの実行単位)の取り消しを行う機能を使う為にインストールする)
[suzuki@suzuki-t wordpress]$ sudo yum install libgcc_s.so.1


[suzuki@suzuki-t ~]$ /usr/local/siege/bin/siege --file=/var/www/html/wordpress/url_list.txt -r 1000 -c 1000

[error] Failed to make an SSL connection: 5: Connection reset by peer
[error] Failed to make an SSL connection: 5: Connection reset by peer
[error] Failed to make an SSL connection: 5: Connection reset by peer
[error] Failed to make an SSL connection: 5: Connection reset by peer
[error] Failed to make an SSL connection: 5: Connection reset by peer
[error] Failed to make an SSL connection: 5: Connection reset by peer
[error] Address resolution failed at sock.c:158 with the following error:: Device or resource busy
[error] System error: Device or resource busy
[error] Address resolution failed at sock.c:158 with the following error:: Device or resource busy
[error] System error: Device or resource busy
[error] Address resolution failed at sock.c:158 with the following error:: Device or resource busy
[error] System error: Device or resource busy
[error] Address resolution failed at sock.c:158 with the following error:: Device or resource busy
[error] System error: Device or resource busy
[error] Address resolution failed at sock.c:158 with the following error:: Device or resource busy
[error] System error: Device or resource busy


#そもそも設定を変更する前のこの部分でapache側ではなく、siege側がエラーを出しているのでsiege側を確認するべき
siege aborted due to excessive socket failure; you
can change the failure threshold in $HOME/.siegerc

#テスト方法が正しいのかの確認をする

#100クライアントで10000回
[suzuki@suzuki-t ~]$ /usr/local/siege/bin/siege --file=/var/www/html/wordpress/url_list.txt --reps=10000 --concurrent=100
** SIEGE 4.1.1
** Preparing 100 concurrent users for battle.
The server is now under siege...

HTTP/1.1 500     0.45 secs:    2539 bytes ==> GET  /wordpress/?p=630
HTTP/1.1 500     0.64 secs:    2539 bytes ==> GET  /wordpress/?p=587
HTTP/1.1 500     1.31 secs:    2539 bytes ==> GET  /wordpress/?p=861
HTTP/1.1 500     1.25 secs:    2539 bytes ==> GET  /wordpress/?p=281
HTTP/1.1 500     1.22 secs:    2539 bytes ==> GET  /wordpress/?p=542
HTTP/1.1 500     1.33 secs:    2539 bytes ==> GET  /wordpress/?p=80
HTTP/1.1 500     2.23 secs:    2539 bytes ==> GET  /wordpress/?p=313
HTTP/1.1 500     2.26 secs:    2539 bytes ==> GET  /wordpress/?p=484
HTTP/1.1 500     2.28 secs:    2539 bytes ==> GET  /wordpress/?p=930
HTTP/1.1 200    15.98 secs:   20407 bytes ==> GET  /wordpress/?p=282
HTTP/1.1 200     0.26 secs:    1426 bytes ==> GET  /wordpress/wp-includes/js/wp-embed.min.js?ver=5.8.1
HTTP/1.1 200     0.01 secs:    1127 bytes ==> GET  /wordpress/wp-content/themes/twentytwentyone/assets/js/responsive-embeds.js?ver=1.4
HTTP/1.1 200     0.00 secs:    1127 bytes ==> GET  /wordpress/wp-content/themes/twentytwentyone/assets/js/polyfills.js?ver=1.4
HTTP/1.1 200     0.36 secs:    2984 bytes ==> GET  /wordpress/wp-includes/js/comment-reply.min.js?ver=5.8.1
HTTP/1.1 200     0.00 secs:    2897 bytes ==> GET  /wordpress/wp-content/themes/twentytwentyone/assets/css/print.css?ver=1.4
HTTP/1.1 200     0.01 secs:  156153 bytes ==> GET  /wordpress/wp-content/themes/twentytwentyone/style.css?ver=1.4
HTTP/1.1 200    20.30 secs:   20407 bytes ==> GET  /wordpress/?p=361
HTTP/1.1 200     0.00 secs:    1426 bytes ==> GET  /wordpress/wp-includes/js/wp-embed.min.js?ver=5.8.1
HTTP/1.1 200     0.00 secs:    1127 bytes ==> GET  /wordpress/wp-content/themes/twentytwentyone/assets/js/responsive-embeds.js?ver=1.4
HTTP/1.1 200    20.97 secs:   20407 bytes ==> GET  /wordpress/?p=351
HTTP/1.1 200     0.01 secs:    1426 bytes ==> GET  /wordpress/wp-includes/js/wp-embed.min.js?ver=5.8.1
HTTP/1.1 200     0.00 secs:    1127 bytes ==> GET  /wordpress/wp-content/themes/twentytwentyone/assets/js/responsive-embeds.js?ver=1.4
HTTP/1.1 200    20.79 secs:   20388 bytes ==> GET  /wordpress/?p=78
HTTP/1.1 200    17.73 secs:   20407 bytes ==> GET  /wordpress/?p=721
HTTP/1.1 200     0.57 secs:    1127 bytes ==> GET  /wordpress/wp-content/themes/twentytwentyone/assets/js/polyfills.js?ver=1.4

Lifting the server siege...
Transactions:                 457643 hits
Availability:                  99.79 %
Elapsed time:                5138.55 secs
Data transferred:           14560.67 MB
Response time:                  1.02 secs
Transaction rate:              89.06 trans/sec
Throughput:                     2.83 MB/sec
Concurrency:                   91.03
Successful transactions:      457470
Failed transactions:             980
Longest transaction:          111.55
Shortest transaction:           0.00


Transactions	有効リクエスト数
Availability	Successful transactions / (Successful transactions + Failed transactions)
Elapsed time	全てのリクエスト送信までに経過した秒数
Data transferred	データ転送量
Response time	1リクエスト辺りの平均レスポンスタイム
Transaction rate	秒間リクエスト数
Throughput	秒間処理データ量
Concurrency	平均同時接続数
Successful transactions	成功リクエスト数
Failed transactions	失敗リクエスト数
Longest transaction	1リクエスト辺りにかかった最大秒数
Shortest transaction	1リクエスト辺りにかかった最小秒数

```

### 並列
複数人で処理をしている状態

### 並行
1人でいろいろな処理をしている状態