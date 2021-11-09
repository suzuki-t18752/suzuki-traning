mysqlテーブルの構造を確認する
DESC テーブル名;

## varnish設定
- ssl化
[参考1](https://stackoverflow.com/questions/53547833/varnish-wordpress-ssl-apache)
[参考2](https://stackoverflow.com/questions/51998779/wordpress-varnish-apache-ssl)
```
下記をそれぞれ追記
#virtualhost8080
SetEnvIf X-Forwarded-Proto https HTTPS=on

#virtualhost443
RequestHeader set X-Forwarded-Proto "https"
```

- SetEnvIf
  - [参考](https://www.javadrive.jp/apache/ini/index16.html)
  - リクエストに含まれる属性によって環境変数を設定することが出来る

- X-Forwarded-Proto
  - プロトコル (HTTP または HTTPS) を識別することができる
  - RequestHeader set X-Forwarded-Proto "https"でプロトコルの指定が出来る
  - ロードバランサーやプロキシを使う際に
