### TCP
- 安全性の高いプロトコルでデータの送信後にデータがきちんと届いたのかを確認する
- 確認をとる分遅い

- TCPコネクションについて
  - 通信の前にコネクションと呼ばれる通信路をつくる[コネクション確立]
    - コネクションの確立は、図1に示すように3回のメッセージのやり取りで行なわれる。これを「スリーウェイハンドシェイク」または「スリーメッセージハンドシェイク」と呼ぶ。メッセージの交換を3回行なうのは、お互いの順序番号の初期値を確認するために必要かつ十分な回数だから
  - データ転送が終わったあとで論理的な通信路を抹消する[コネクション解放]

### UDP
- データが届いたのか確認せず、送るデータがあれば次々と送る
- 届いたのかの確認をしない分早い

### TLS
- sslがバージョンアップされる過程で設計が見直されて作られたプロトコルの1つ
- 情報をやり取りする「クライアント（WEBサイト）」と「サーバー」がある
- セキュアな鍵付きの箱がある
- 箱の鍵は「クライアント（WEBサイト）」と「サーバー」だけが持っている
- 情報は鍵つきの箱にいれて（暗号化される）やり取りをする
- 鍵を持っている者だけが情報を取り出し、暗号を解くことができる

- TLSハンドシェイク
  - SSL/TLS では暗号化通信を開始する前に、SSL/TLS ハンドシェイクと呼ばれるやりとりを行い、暗号化通信を行うにあたって必要な情報を交換し、暗号化通信を確立します
  - クライアントとサーバー間で暗号化に使用する各プロトコルの選定や共通鍵の生成、また証明書を検証して信頼できる相手なのかの検証を行います

### オーバーヘッド
- 何かを処理するとき、システムやプロトコルの処理の負荷。サーバーやネットワーク機器などのハードウェアの処理能力や、OSなどのシステムソフトウェアの性能など、個々の性能によって、システム全体にかかる負荷に対して用いられる。通信の場合、実際にデータを転送する時間に加えて、相手先の受信確認や再送信などの時間がかかる。この余分な作業をオーバーヘッドという

### http/1とhttp/2の違い




# varnishの設定
```
基本起動
sudo /usr/local/varnish/sbin/varnishd -a :80 -b 192.168.56.3:8080
```

### 443portはどうするのか？
443portは通常通りhttps用にlistenし、ssl認証完了後にプロキシでvarnishを経由して80portに

[プロキシ](https://httpd.apache.org/docs/2.4/en/mod/mod_proxy.html)


```
[suzuki@suzuki-t ~]$ sudo vi /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-ssl.conf
#下記３行を追加
ProxyPreserveHost On
ProxyPass "/" "http://192.168.56.3:80/"
ProxyPassReverse "/" "http://192.168.56.3:80/"

#レスポンスヘッダー
Age: 0
Cache-Control: no-cache, must-revalidate, max-age=0
Connection: Keep-Alive
Content-Type: text/html; charset=UTF-8
Date: Wed, 27 Oct 2021 09:09:22 GMT
Expires: Wed, 11 Jan 1984 05:00:00 GMT
Keep-Alive: timeout=5, max=100
Link: <https://suzuki-t.com/wordpress/index.php?rest_route=/>; rel="https://api.w.org/"
Server: Apache/2.4.48 (Unix) OpenSSL/1.0.2k-fips PHP/7.4.23
Transfer-Encoding: chunked
Via: 1.1 varnish (Varnish/7.0)
X-Powered-By: PHP/7.4.23
X-Varnish: 131522

#上記のようにバーニッシュを経由するようになったが、CSSやjavascriptが読み込まれない
```
