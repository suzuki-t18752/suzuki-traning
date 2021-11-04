### 指定のページを除外する
[varnish設定ファイル書き方](https://gist.github.com/rachelandrew/6a2693d3cd6fb9268756)
[参考](https://reboot.makeall.net/2013/02/15/what-vcl-on-varnish-03/)
[参考](https://kazuhira-r.hatenablog.com/entry/2019/10/05/195319)
[参考](https://qiita.com/AtsushiFukuda/items/e6a57094cfb19e7875a5)

/wordpress/wp-admin
/wordpress/wp-login.php
リクエスト URL: https://suzuki-t.com/wordpress/wp-login.php
リクエスト URL: https://suzuki-t.com/wordpress/wp-admin/

```
#設定ファイルを作成
sudo vi /usr/local/varnish/default.vcl

#下記が内容
vcl 4.0;

backend default {
  .host = "192.168.56.3";
  .port = "8080";
}

sub vcl_recv {

}


#設定ファイルをプロセスに追加
sudo vi /usr/lib/systemd/system/varnish.service

/usr/local/varnish/sbin/varnishd -P /usr/local/varnish/varnish.pid -a :80 -b 192.168.56.3:8080 -s malloc,256M
↓
/usr/local/varnish/sbin/varnishd -P /usr/local/varnish/varnish.pid -f /usr/local/varnish/default.vcl -a :80 -s malloc,256M

#レスポンスヘッダーを確認
Age: 0
Cache-Control: no-cache, must-revalidate, max-age=0
Connection: Keep-Alive
Content-Type: text/html; charset=UTF-8
Date: Thu, 04 Nov 2021 04:53:58 GMT
Expires: Wed, 11 Jan 1984 05:00:00 GMT
Keep-Alive: timeout=5, max=100
Link: <https://suzuki-t.com/wordpress/index.php?rest_route=/>; rel="https://api.w.org/"
Server: Apache/2.4.48 (Unix) OpenSSL/1.0.2k-fips PHP/7.4.23
Transfer-Encoding: chunked
Via: 1.1 varnish (Varnish/7.0)
X-Powered-By: PHP/7.4.23
X-Varnish: 2

#設定ファイルに管理画面をキャッシュしない設定を追加
sudo vi /usr/local/varnish/default.vcl

sub vcl_recv {
 if(req.url ~ "/wp-admin") {
   return (pass);
 }
}
```

### varnishの保存先
- malloc(キャッシュが RAM に収まる限りは高速だが、RAM からあふれるとスワップアウトして非常に遅くなる)
- file(mmap で仮想メモリを割り当て。HDD のような disk I/O が遅いデバイスでは非常に遅い)

## 確認
- varnishstatコマンド
  - 実行中のvarnishdから統計を表示する
  - -1で記録の一覧を表示
  - -1を付けずに実行すればページを開く度に更新される
  -

- [varnishncsaコマンド](https://varnish-cache.org/docs/trunk/reference/varnishncsa.html)
  - ログファイルを作成する
  - -F フォーマット
  - -a append ファイル全体の更新ではなく行の追加に変更する
  - -w 保存先ファイル
  - -D デーモンとして実行
  - %{X}x
    - Varnish:handling リクエストの処理方法を示す「hit」、「miss」、「pass」、「pipe」、または「synth」文字列の1つを表示
  - %U クエリ文字列のないリクエストURL
```
sudo /usr/local/varnish/bin/varnishncsa -F '%U %{Varnish:handling}x' -w /usr/local/varnish/varnishcsa.log -a -D

tail -f /usr/local/varnish/varnishcsa.log
/wordpress/ hit
/wordpress/ hit
/wordpress/ hit
/wordpress/ pass
/wordpress/wp-includes/css/dashicons.min.css pass
/wordpress/wp-includes/css/admin-bar.min.css pass
/wordpress/wp-includes/css/dist/block-library/style.min.css pass
/wordpress/wp-content/themes/twentytwentyone/style.css pass
/wordpress/wp-includes/js/admin-bar.min.js pass
/wordpress/wp-content/themes/twentytwentyone/assets/js/responsive-embeds.js pass
/wordpress/wp-includes/js/wp-emoji-release.min.js pass
/wordpress/wp-includes/js/hoverintent-js.min.js pass
/wordpress/wp-includes/js/wp-embed.min.js pass
/wordpress/wp-content/themes/twentytwentyone/assets/css/print.css pass

```
### siegeでの確認
```
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
```
