git checkout main
git pull origin main
git tag v1.0.0
git push --tags

## varnishの設定
```
[suzuki@suzuki-t ~]$ /usr/local/siege/bin/siege --file=/home/suzuki/url_list.txt --reps=100 --concurrent=100

#100クライアントで100リクエスト行う
#urlリストにwordpressのページ50件
```
```
#導入前
Transactions:                  80000 hits
Availability:                 100.00 %
Elapsed time:                1439.24 secs
Data transferred:            2543.37 MB
Response time:                  1.77 secs
Transaction rate:              55.58 trans/sec
Throughput:                     1.77 MB/sec
Concurrency:                   98.43
Successful transactions:       80000
Failed transactions:               0
Longest transaction:           19.29
Shortest transaction:           0.01


#導入後
Transactions:                  80000 hits
Availability:                 100.00 %
Elapsed time:                 329.00 secs
Data transferred:            2543.37 MB
Response time:                  0.41 secs
Transaction rate:             243.16 trans/sec
Throughput:                     7.73 MB/sec
Concurrency:                   99.67
Successful transactions:       80000
Failed transactions:               0
Longest transaction:            2.09
Shortest transaction:           0.02

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
```

- Elapsed time・Response timeが4分の1、Transaction rateが4倍、Throughputも2分の1になりだいぶ処理が早くなっている

### ログ
-[varnishncsaコマンド](https://varnish-cache.org/docs/trunk/reference/varnishncsa.html)
  - ログファイルを作成する
  - -F フォーマット
  - -a append ファイル全体の更新ではなく行の追加に変更する
  - -w 保存先ファイル
  - -D デーモンとして実行
  - %{X}x
    - Varnish:handling リクエストの処理方法を示す「hit」、「miss」、「pass」、「pipe」、または「synth」文字列の1つを表示
  - %U クエリ文字列のないリクエストURL
```
sudo /usr/local/varnish/bin/varnishncsa -F'%%t %%m %%{Host}i %%U %%s %%{Varnish:handling}x' -w /usr/local/varnish/varnishcsa.log -P /usr/local/varnish/varnishlog.pid -a -D

tail -f /usr/local/varnish/varnishcsa.log
[08/Nov/2021:16:44:17 +0900] GET suzuki-t.com /wordpress/wp-admin/js/updates.min.js 200 pass
[08/Nov/2021:16:44:17 +0900] GET suzuki-t.com /wordpress/wp-admin/js/plugin-install.min.js 200 pass
[08/Nov/2021:16:44:17 +0900] GET suzuki-t.com /wordpress/wp-includes/js/thickbox/thickbox.js 200 pass
[08/Nov/2021:16:44:17 +0900] GET suzuki-t.com /wordpress/wp-admin/js/media-upload.min.js 200 pass
[08/Nov/2021:16:44:17 +0900] GET suzuki-t.com /wordpress/wp-admin/js/svg-painter.js 200 pass
[08/Nov/2021:16:44:17 +0900] GET suzuki-t.com /wordpress/wp-includes/js/shortcode.min.js 200 pass
[08/Nov/2021:16:44:17 +0900] GET suzuki-t.com /wordpress/wp-includes/js/heartbeat.min.js 200 pass
[08/Nov/2021:16:44:17 +0900] GET suzuki-t.com /wordpress/wp-includes/js/wp-auth-check.min.js 200 pass
[08/Nov/2021:16:44:17 +0900] GET suzuki-t.com /wordpress/wp-admin/js/common.min.js 200 pass
[08/Nov/2021:16:44:17 +0900] GET suzuki-t.com /wordpress/wp-admin/load-scripts.php 200 pass
[08/Nov/2021:16:44:17 +0900] GET suzuki-t.com /wordpress/wp-includes/js/underscore.min.js 200 pass
[08/Nov/2021:16:44:17 +0900] GET suzuki-t.com /wordpress/wp-admin/load-scripts.php 200 pass
[08/Nov/2021:16:44:17 +0900] GET suzuki-t.com /wordpress/wp-includes/js/wp-emoji-release.min.js 200 pass
[08/Nov/2021:16:44:17 +0900] GET suzuki-t.com /wordpress/wp-includes/js/thickbox/loadingAnimation.gif 200 pass
[08/Nov/2021:16:44:35 +0900] POST suzuki-t.com /wordpress/wp-admin/admin-ajax.php 200 pass

#systemdで管理
 [suzuki@suzuki-t ~]$ sudo vi /usr/lib/systemd/system/varnishncsa.service

[Unit]
Description=Varnish HTTP accelerator NCSA daemon
After=varnish.service

[Service]
Type=forking
ExecStart=/usr/local/varnish/bin/varnishncsa -F '%%t %%m %%{Host}i %%U %%s %%{Varnish:handling}x' -w /usr/local/varnish/varnishcsa.log -P /usr/local/varnish/varnishlog.pid -a -D

[Install]
WantedBy=multi-user.target

#設定
[suzuki@suzuki-t ~]$ systemctl daemon-reload
[suzuki@suzuki-t ~]$ systemctl start varnishncsa.service
[suzuki@suzuki-t ~]$ systemctl enable varnishncsa.service

[suzuki@suzuki-t ~]$ systemctl status varnishncsa.service
● varnishncsa.service - Varnish HTTP accelerator NCSA daemon
   Loaded: loaded (/usr/lib/systemd/system/varnishncsa.service; enabled; vendor preset: disabled)
   Active: active (running) since 月 2021-11-08 16:43:30 JST; 12min ago
 Main PID: 3066 (varnishncsa)
   CGroup: /system.slice/varnishncsa.service
           └─3066 /usr/local/varnish/bin/varnishncsa -F %t %m %{Host}i %U %s %{Varnish:handling}x -w /usr/local/varnish/varnishcsa.log -P /usr/local/varnish/varnishlog.pid -a -D

11月 08 16:43:30 suzuki-t systemd[1]: Starting Varnish HTTP accelerator NCSA daemon...
11月 08 16:43:30 suzuki-t systemd[1]: Started Varnish HTTP accelerator NCSA daemon.

```

### ブラウザでの確認
- レスポンスヘッダーを確認する
  - X-Varnish
    - 数字が2つある場合はhit(X-Varnish: 107856170 107856168)
    - 1つの場合はmiss(X-Varnish: 107856168)
  - Age
    - キャッシュされたコピーが何秒古いか
    - 0より大きい場合はhit
    - 0の場合はmiss

```
#http
#/wordpress/
Age: 0
Cache-Control: no-cache, must-revalidate, max-age=0
Connection: Keep-Alive
Content-Type: text/html; charset=UTF-8
Date: Mon, 08 Nov 2021 08:42:43 GMT
Expires: Wed, 11 Jan 1984 05:00:00 GMT
Keep-Alive: timeout=5, max=99
Referrer-Policy: strict-origin-when-cross-origin
Server: Apache/2.4.48 (Unix) OpenSSL/1.0.2k-fips PHP/7.4.23
Set-Cookie: wp-settings-1=deleted; expires=Thu, 01-Jan-1970 00:00:01 GMT; Max-Age=0; path=/wordpress/; secure
Set-Cookie: wp-settings-time-1=1636360963; expires=Tue, 08-Nov-2022 08:42:43 GMT; Max-Age=31536000; path=/wordpress/; secure
Transfer-Encoding: chunked
Via: 1.1 varnish (Varnish/7.0)
X-Frame-Options: SAMEORIGIN
X-Powered-By: PHP/7.4.23
X-Varnish: 83

#/wordpress/wp-admin/
Age: 0
Cache-Control: no-cache, must-revalidate, max-age=0
Connection: Keep-Alive
Content-Type: text/html; charset=UTF-8
Date: Mon, 08 Nov 2021 08:44:27 GMT
Expires: Wed, 11 Jan 1984 05:00:00 GMT
Keep-Alive: timeout=5, max=86
Referrer-Policy: strict-origin-when-cross-origin
Server: Apache/2.4.48 (Unix) OpenSSL/1.0.2k-fips PHP/7.4.23
Set-Cookie: wp-settings-1=deleted; expires=Thu, 01-Jan-1970 00:00:01 GMT; Max-Age=0; path=/wordpress/; secure
Set-Cookie: wp-settings-time-1=1636361067; expires=Tue, 08-Nov-2022 08:44:27 GMT; Max-Age=31536000; path=/wordpress/; secure
Transfer-Encoding: chunked
Via: 1.1 varnish (Varnish/7.0)
X-Frame-Options: SAMEORIGIN
X-Powered-By: PHP/7.4.23
X-Varnish: 131125
```

- pass
  - パスモードに切り替えて、現在のリクエストがキャッシュを使用せず、そのレスポンスをキャッシュに入れないようにします。制御は最終的にvcl_passに渡され ます。
