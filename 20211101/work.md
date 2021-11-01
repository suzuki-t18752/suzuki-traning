### Unicorn
- railsで使うwebサーバー、[rack](https://rubygems.org/gems/rack)アプリケーション用サーバー
  - Rackとは、WebサーバーとRubyで作られたWebフレームワークを繋ぐためのAPIを提供するアプリケーションサーバー
  - WebサーバーとWebフレームワーク（Ruby on Rails/Sinatra）が、互いを意識することなく柔軟に通信できるようにしているのがRack
- UnicornなどのRack専用のWebサーバーはブロッキングI/Oモデル1で実行されているため、クライアントからのリクエストを非同期で処理することができません。通信状態が不安定なクライアントがUnicornのプロセスを占有している場合、その間は他のクライアントからのリクエストを処理することができなくなってしまいます
- UnicornなどのRack専用のWebサーバーの弱点を補うのがNginxです。Nginxは低速クライアントをバッファリングします。NginxとUnicornの間の接続は非常に高速なため、Unicornが低速なクライアントのリクエストを受信することがなくなります
- UnicornとNginxは互いの弱点を補間する関係にあるので、どちらのWebサーバーも必要

### [Capistrano(gem)](https://capistranorb.com/documentation)
- アプリのデプロイ作業を自動化するツール


## varnish確認
```
#https(443port)レスポンスヘッダー
Age: 0
Connection: Keep-Alive
Content-Type: text/html; charset=UTF-8
Date: Mon, 01 Nov 2021 01:06:32 GMT
Keep-Alive: timeout=5, max=100
Link: <https://suzuki-t.com/wordpress/index.php?rest_route=/>; rel="https://api.w.org/"
Server: Apache/2.4.48 (Unix) OpenSSL/1.0.2k-fips PHP/7.4.23
Transfer-Encoding: chunked
Via: 1.1 varnish (Varnish/7.0)
X-Powered-By: PHP/7.4.23
X-Varnish: 32791

#http(80port)レスポンスヘッダー
Accept-Ranges: bytes
Age: 0
Connection: keep-alive
Content-Type: text/html; charset=UTF-8
Date: Mon, 01 Nov 2021 01:07:36 GMT
Link: <https://suzuki-t.com/wordpress/index.php?rest_route=/>; rel="https://api.w.org/"
Server: Apache/2.4.48 (Unix) OpenSSL/1.0.2k-fips PHP/7.4.23
Transfer-Encoding: chunked
Via: 1.1 varnish (Varnish/7.0)
X-Powered-By: PHP/7.4.23
X-Varnish: 25
```
- varnishstatコマンド

### 指定のページを除外する
[参考](https://cloudpack.media/1183)

```
vi /usr/local/varnish/default.vcl

sub vcl_recv {
 if(req.request == "GET") {
   return (lookup);
 }
 return (pass);
}
```

/wordpress/wp-admin
/wordpress/wp-login.php
リクエスト URL: https://suzuki-t.com/wordpress/wp-login.php
リクエスト URL: https://suzuki-t.com/wordpress/wp-admin/




```
#100クライアントで10000回アクセス
#varnish導入前
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


Transactions    有効リクエスト数
Availability    Successful transactions / (Successful transactions + Failed transactions)
Elapsed time    全てのリクエスト送信までに経過した秒数
Data transferred        データ転送量
Response time   1リクエスト辺りの平均レスポンスタイム
Transaction rate        秒間リクエスト数
Throughput      秒間処理データ量
Concurrency     平均同時接続数
Successful transactions 成功リクエスト数
Failed transactions     失敗リクエスト数
Longest transaction     1リクエスト辺りにかかった最大秒数
Shortest transaction    1リクエスト辺りにかかった最小秒数


#varnish導入後
Lifting the server siege...
Transactions:                 169325 hits
Availability:                 100.00 %
Elapsed time:                3645.01 secs
Data transferred:            5382.87 MB
Response time:                  2.15 secs
Transaction rate:              46.45 trans/sec
Throughput:                     1.48 MB/sec
Concurrency:                   99.80
Successful transactions:      169265
Failed transactions:               0
Longest transaction:           18.79
Shortest transaction:           0.35

```
