### 443portはどうするのか？
443portは通常通りhttps用にlistenし、ssl認証完了後にプロキシでvarnishを経由して80portに

[プロキシ](https://httpd.apache.org/docs/2.4/en/mod/mod_proxy.html)
[参考](https://medium.com/@sivaschenko/apache-ssl-termination-https-varnish-cache-3940840531ad)

```
[suzuki@suzuki-t ~]$ sudo vi /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-ssl.conf
#下記３行を追加
ProxyPreserveHost On
ProxyPass "/" "http://192.168.56.3:80/"
ProxyPassReverse "/" "http://192.168.56.3:80/"

[suzuki@suzuki-t ~]$ sudo vi /usr/local/httpd/httpd-2.4.48/conf/httpd.conf
#下記2行のコメントアウトを外す
LoadModule proxy_module modules/mod_proxy.so
LoadModule proxy_http_module modules/mod_proxy_http.so

[suzuki@suzuki-t ~]$ systemctl restart httpd.service


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

（インデックス）:13 Mixed Content: The page at 'https://suzuki-t.com/wordpress/' was loaded over HTTPS, but requested an insecure script 'http://suzuki-t.com/wordpress/wp-includes/js/wp-emoji-release.min.js?ver=5.8.1'. This request has been blocked; the content must be served over HTTPS.

↓
ProxyPass "/" "http://192.168.56.3:80/" →　ProxyPass "/" "https://192.168.56.3:80/"

GET https://suzuki-t.com/wordpress/ 500 (Internal Server Error)
↓
ProxyPassReverse "/" "http://192.168.56.3:80/"　→ ProxyPassReverse "/" "https://192.168.56.3:80/"

GET https://suzuki-t.com/wordpress/ 500 (Internal Server Error)
↓
#変更したプロキシパスを戻す
↓
[suzuki@suzuki-t ~]$ sudo vi /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-ssl.conf
#下記を追記
Header edit Location ^http https

特に変化なし
```
