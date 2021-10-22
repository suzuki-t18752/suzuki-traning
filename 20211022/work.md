## URLのバリデーション
```
#指定の文字列2つがあれば
^(?=.*docs.google.com)(?=.*spreadsheets).*$

#参考
http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)?
https?://[\w!?/+\-_~;.,*&@#$%()'[\]]+
https?|ftp)(:\/\/[\w\/:%#\$&\?\(\)~\.=\+\-]+
http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)?

## 基本URL
^(http)s?://([\w-]+\.)+\w+
```

- スプレッドシート専用
```
^(http)s?://docs.google.com/spreadsheets/
```

# URLを正規表現でバリデーションしない！！！！！！！！！！

- modelに下記を入れるとエラーが発生する
```
validates :config_sheet_url, format: { with: ^(http)s?://docs.google.com/spreadsheets/ }, length: { maximum: 300 }, allow_blank: true
↓
or, unexpected '^' (SyntaxError)
...ig_sheet_url, format: { with: ^(http)s?://docs.google.com/sp...
...                              ^
/home/suzuki/name/app/models/name.rb:93: syntax error, unexpected tLABEL, expecting end
...url, format: { with: ^(http)s?://docs.google.com/spreadsheet...
...                            ^~~
/home/suzuki/name/app/models/name.rb:93: unknown regexp options - dc
/home/suzuki/name/app/models/name.rb:93: syntax error, unexpected '}'
...docs.google.com/spreadsheets/ }, length: { maximum: 300 }, a...
...                              ^
/home/suzuki/name/app/models/name.rb:93: syntax error, unexpected ',', expecting end
...s/ }, length: { maximum: 300 }, allow_blank: true

↓
rubyの正規表現はスラッシュをエスケープする必要がある
validates :config_sheet_url, format: { with: /^(http)s?:\/\/docs.google.com\/spreadsheets\// }, length: { maximum: 300 }, allow_blank: true

↓
rubyでの正規表現で文字列の開始位置は\Aを使う
validates :config_sheet_url, format: { with: /\A(http)s?:\/\/docs.google.com\/spreadsheets\// }, length: { maximum: 300 }, allow_blank: true

↓
rubocopによる警告
rubocop app/models/name.rb
Inspecting 1 file
C

Offenses:

app/models/name.rb:93:48: C: Style/RegexpLiteral: Use %r around regular expression.
  validates :config_sheet_url, format: { with: /\A(http)s?:\/\/docs.google.com\/spreadsheets\// }, length: { maximum: 300 }, allow_blank: true

↓
//での囲みから%r{}での囲みに変更
validates :config_sheet_url, format: { with: %r{\A(http)s?:\/\/docs.google.com\/spreadsheets\/} }, length: { maximum: 300 }, allow_blank: true

```
# URL、電話番号、住所等は正規表現では難しいのでライブラリを使うようにしよう！！！！！！

# varnishの設定
```
基本起動
sudo /usr/local/varnish/sbin/varnishd -a :80 -b 192.168.56.3:8080
```
### systemdにて管理
```
[suzuki@suzuki-t ~]$ sudo vi /usr/lib/systemd/system/varnish.service
#下記を入れる
[Unit]
Description=Web Application Accelerator
After=network.target

[Service]
Type=forking
PIDFile=/usr/local/varnish/varnish.pid
PrivateTmp=true
EnvironmentFile=/usr/local/varnish/varnish.params
ExecStart=/usr/local/varnish/sbin/varnishd -P /usr/local/varnish/varnish.pid -a :80 -b 192.168.56.3:8080 -u root -g root -s malloc,256M
ExecReload=/usr/local/varnish/bin/varnish-vcl-reload

[Install]
WantedBy=multi-user.target

#設定の読み込み
[suzuki@suzuki-t ~]$ systemctl daemon-reload

#バーニッシュを起動
[suzuki@suzuki-t ~]$ systemctl start varnish.service

#自動起動設定
[suzuki@suzuki-t ~]$ systemctl enable varnish.service

#確認
[suzuki@suzuki-t ~]$ systemctl status varnish.service
● varnish.service - Web Application Accelerator
   Loaded: loaded (/usr/lib/systemd/system/varnish.service; enabled; vendor preset: disabled)
   Active: active (running) since 金 2021-10-22 16:40:06 JST; 6min ago
 Main PID: 4596 (varnishd)
   CGroup: /system.slice/varnish.service
           ├─4596 /usr/local/varnish/sbin/varnishd -P /usr/local/varnish/varnish.pid -a :80 -b 192.168.56.3:8080 -s malloc,256M
           └─4607 /usr/local/varnish/sbin/varnishd -P /usr/local/varnish/varnish.pid -a :80 -b 192.168.56.3:8080 -s malloc,256M

10月 22 16:40:05 suzuki-t systemd[1]: Starting Web Application Accelerator...
10月 22 16:40:06 suzuki-t varnishd[4596]: Version: varnish-7.0.0 revision 454733b82a3279a1603516b4f0a07f8bad4bcd55
10月 22 16:40:06 suzuki-t varnishd[4596]: Platform: Linux,3.10.0-1160.42.2.el7.x86_64,x86_64,-jnone,-smalloc,-sdefault,-hcritbit
10月 22 16:40:06 suzuki-t varnishd[4596]: Child (4607) Started
10月 22 16:40:06 suzuki-t varnishd[4596]: Child (4607) said Child starts
10月 22 16:40:06 suzuki-t systemd[1]: Started Web Application Accelerator.

[suzuki@suzuki-t ~]$ ps auxww | grep varnish
root      4596  0.0  0.1  32224  5580 ?        SLs  16:40   0:00 /usr/local/varnish/sbin/varnishd -P /usr/local/varnish/varnish.pid -a :80 -b 192.168.56.3:8080 -s malloc,256M
root      4607  0.3  3.0 284976 117912 ?       SLl  16:40   0:01 /usr/local/varnish/sbin/varnishd -P /usr/local/varnish/varnish.pid -a :80 -b 192.168.56.3:8080 -s malloc,256M
suzuki    4902  0.0  0.0 112824   976 pts/0    R+   16:46   0:00 grep --color=auto varnish
```

### 443portはどうするのか？
443portは通常通りhttps用にlistenし、ssl認証完了後にプロキシでvarnishを経由して80portに

[プロキシ](https://httpd.apache.org/docs/2.4/en/mod/mod_proxy.html)

[suzuki@suzuki-t ~]$ sudo vi /usr/local/httpd/httpd-2.4.48/conf/extra/httpd-ssl.conf
