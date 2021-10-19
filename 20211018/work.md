http://localhost:3000/
ページが開けない

ERR_CONNECTION_REFUSED

PCを再起動したら開けた

### rubocop
[参考](https://github.com/rubocop/rubocop-rails)


```
rubocop ~~~~~~~.rb
Inspecting 1 file
C

Offenses:

~~~~~~~.rb.rb:228:25: C: Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
      let(:start_end) { "17:00_19:00" }
                        ^^^^^^^^^^^^^
~~~~~~~.rb.rb:245:25: C: Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
      let(:start_end) { "17:00_19:00" }
                        ^^^^^^^^^^^^^
~~~~~~~.rb:252:13: C: Style/TrailingCommaInHashLiteral: Put a comma after the last item of a multiline hash.
            start_end: start_end
            ^^^^^^^^^^^^^^^^^^^^
~~~~~~~.rb.rb:269:1: C: Layout/TrailingWhitespace: Trailing whitespace detected.
~~~~~~~.rb.rb:276:13: C: Style/TrailingCommaInHashLiteral: Put a comma after the last item of a multiline hash.
            start_end: start_end
            ^^^^^^^^^^^^^^^^^^^^
~~~~~~~.rb:300:13: C: Style/TrailingCommaInHashLiteral: Put a comma after the last item of a multiline hash.
            start_end: start_end
            ^^^^^^^^^^^^^^^^^^^^

1 file inspected, 6 offenses detected

↓
#ダブルクォーテーションをシングルクォーテーションに修正
#配列内の最後の項目にもコンマを付ける
↓

rubocop ~~~~~~~.rb
Inspecting 1 file
.

1 file inspected, no offenses detected
```


```
rubocop ~~~~~~~.rb
Inspecting 1 file
C

Offenses:

~~~~~~~~.rb:132:12: C: Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
      fail("更新対象を選択してください") if params[ ].blank?
           ^^^^^^^^^^^^^^^
~~~~~~~~.rb:133:1: C: Layout/TrailingWhitespace: Trailing whitespace detected.

1 file inspected, 2 offenses detected

↓
#ダブルクォーテーションをシングルクォーテーションに修正
#何もない行にスペースが入っているのでスペースを削除
↓
rubocop ~~~~~~~.rb
Inspecting 1 file
.

1 file inspected, no offenses detected
```

### マークダウンチェックボックス
- [x] aaaaaaa


### inputタグのnameについて
<input value=1 name="~~~~~[]"><input value=2 name="~~~~~[]">とした場合に

1. ~~~~~ = [1,2]
2. ~~~~~ = 1
3. ~~~~~ = 2
とアプリケーション側で解釈するものがあるのでどのように解釈しているか確認する
reqestの確認も忘れずに

### 安全なwebサイトの作り方
何度も読んでおく
[安全なwebサイトの作り方](https://www.ipa.go.jp/security/vuln/websecurity.html)

### フォーム入力後の処理時のエラーに画面を元のフォームに戻す場合
フォームをクライアントが入力した状態でフォームに戻してあげるとどこが間違っていたのかクライアントに認識させることができて優しい

### insert on duplicate key update
- ユニークキーや主キーで判別する
- キーが一致する場合はupdate
- キーが一致しない場合insert
- 複数ユニークキーがある場合、or条件(どれか1つのキーが一致している)で判別する
- 複合キーの場合は、and条件(複数のキーが全て一致しているか)で判別する

```
mysql> select * from hoge3;
+-----+-----+--------+-------+
| id1 | id2 | name1  | name2 |
+-----+-----+--------+-------+
|   1 |   1 | yamada | taro  |
|   2 |   2 | suzuki | jiro  |
+-----+-----+--------+-------+
2 rows in set (0.00 sec)

mysql> INSERT INTO hoge3 (id1, id2, name1, name2) VALUES (1, 1, 'yamada', 'taro') ON DUPLICATE KEY UPDATE name1 = 'sato';
Query OK, 2 rows affected (0.04 sec)

mysql> select * from hoge3;
+-----+-----+--------+-------+
| id1 | id2 | name1  | name2 |
+-----+-----+--------+-------+
|   1 |   1 | sato   | taro  |
|   2 |   2 | suzuki | jiro  |
+-----+-----+--------+-------+
2 rows in set (0.00 sec)

mysql> INSERT INTO hoge3 (id1, id2, name1, name2) VALUES (1, 2, 'yamada', 'taro') ON DUPLICATE KEY UPDATE name1 = 'sato';
Query OK, 0 rows affected (0.00 sec)

mysql> select * from hoge3;
+-----+-----+--------+-------+
| id1 | id2 | name1  | name2 |
+-----+-----+--------+-------+
|   1 |   1 | sato   | taro  |
|   2 |   2 | suzuki | jiro  |
+-----+-----+--------+-------+
2 rows in set (0.00 sec)

mysql> INSERT INTO hoge3 (id1, id2, name1, name2) VALUES (2, 2, 'yamada', 'taro') ON DUPLICATE KEY UPDATE name1 = 'sato';
Query OK, 2 rows affected (0.04 sec)

mysql> select * from hoge3;
+-----+-----+-------+-------+
| id1 | id2 | name1 | name2 |
+-----+-----+-------+-------+
|   1 |   1 | sato  | taro  |
|   2 |   2 | sato  | jiro  |
+-----+-----+-------+-------+
2 rows in set (0.00 sec)

mysql> INSERT INTO hoge3 (id1, id2, name1, name2) VALUES (2, 2, 'yamada', 'taro') ON DUPLICATE KEY UPDATE name1 = 'sato';
Query OK, 0 rows affected (0.00 sec)

mysql> select * from hoge3;
+-----+-----+-------+-------+
| id1 | id2 | name1 | name2 |
+-----+-----+-------+-------+
|   1 |   1 | sato  | taro  |
|   2 |   2 | sato  | jiro  |
+-----+-----+-------+-------+
2 rows in set (0.00 sec)

mysql> INSERT INTO hoge3 (id1, id2, name1, name2) VALUES (3, 2, 'yamada', 'taro') ON DUPLICATE KEY UPDATE name1 = 'sato';
Query OK, 0 rows affected (0.04 sec)

mysql> select * from hoge3;
+-----+-----+-------+-------+
| id1 | id2 | name1 | name2 |
+-----+-----+-------+-------+
|   1 |   1 | sato  | taro  |
|   2 |   2 | sato  | jiro  |
+-----+-----+-------+-------+
2 rows in set (0.00 sec)

mysql> INSERT INTO hoge3 (id1, id2, name1, name2) VALUES (3, 3, 'yamada', 'taro') ON DUPLICATE KEY UPDATE name1 = 'sato';
Query OK, 1 row affected (0.05 sec)

mysql> select * from hoge3;
+-----+-----+--------+-------+
| id1 | id2 | name1  | name2 |
+-----+-----+--------+-------+
|   1 |   1 | sato   | taro  |
|   2 |   2 | sato   | jiro  |
|   3 |   3 | yamada | taro  |
+-----+-----+--------+-------+
3 rows in set (0.00 sec)

```


```
CREATE TABLE `hoge4`(
  `id1` bigint(20) NOT NULL,
  `id2` bigint(20) NOT NULL,
  `name1` varchar(255) NOT NULL,
  `name2` varchar(255) NOT NULL,
  UNIQUE (`id1`, `id2`)
);

mysql> select * from hoge4;
+-----+-----+-------+-------+
| id1 | id2 | name1 | name2 |
+-----+-----+-------+-------+
|   1 |   1 | sato  | taro  |
|   1 |   2 | sato  | jiro  |
|   2 |   1 | sato  | taro  |
|   2 |   2 | sato  | jiro  |
+-----+-----+-------+-------+
4 rows in set (0.00 sec)

mysql> INSERT INTO hoge4 (id1, id2, name1, name2) VALUES
    ->     (1, 1, 'yamada', 'taro')
    ->     , (1, 3, 'yamada', 'jiro')
    ->     , (2, 1, 'suzuki', 'taro')
    ->     , (2, 2, 'suzuki', 'jiro')
    ->     ON DUPLICATE KEY UPDATE name1 = 'sato';
Query OK, 1 row affected (0.04 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> select * from hoge4;
+-----+-----+--------+-------+
| id1 | id2 | name1  | name2 |
+-----+-----+--------+-------+
|   1 |   1 | sato   | taro  |
|   1 |   2 | sato   | jiro  |
|   1 |   3 | yamada | jiro  |
|   2 |   1 | sato   | taro  |
|   2 |   2 | sato   | jiro  |
+-----+-----+--------+-------+
5 rows in set (0.00 sec)

mysql> INSERT INTO hoge4 (id1, id2, name1, name2) VALUES (1, 1, 'yamada', 'taro') ON DUPLICATE KEY UPDATE name1 = 'hoge';
Query OK, 2 rows affected (0.04 sec)

mysql> select * from hoge4;
+-----+-----+--------+-------+
| id1 | id2 | name1  | name2 |
+-----+-----+--------+-------+
|   1 |   1 | hoge   | taro  |
|   1 |   2 | sato   | jiro  |
|   1 |   3 | yamada | jiro  |
|   2 |   1 | sato   | taro  |
|   2 |   2 | sato   | jiro  |
+-----+-----+--------+-------+
5 rows in set (0.00 sec)

mysql> INSERT INTO hoge4 (id1, id2, name1, name2) VALUES (3, 1, 'yamada', 'taro') ON DUPLICATE KEY UPDATE name1 = 'hoge';
Query OK, 1 row affected (0.05 sec)

mysql> select * from hoge4;
+-----+-----+--------+-------+
| id1 | id2 | name1  | name2 |
+-----+-----+--------+-------+
|   1 |   1 | hoge   | taro  |
|   1 |   2 | sato   | jiro  |
|   1 |   3 | yamada | jiro  |
|   2 |   1 | sato   | taro  |
|   2 |   2 | sato   | jiro  |
|   3 |   1 | yamada | taro  |
+-----+-----+--------+-------+
6 rows in set (0.00 sec)

mysql> INSERT INTO hoge4 (id1, id2, name1, name2) VALUES (2, 1, 'yamada', 'taro') ON DUPLICATE KEY UPDATE name1 = 'hoge';
Query OK, 2 rows affected (0.04 sec)

mysql> select * from hoge4;
+-----+-----+--------+-------+
| id1 | id2 | name1  | name2 |
+-----+-----+--------+-------+
|   1 |   1 | hoge   | taro  |
|   1 |   2 | sato   | jiro  |
|   1 |   3 | yamada | jiro  |
|   2 |   1 | hoge   | taro  |
|   2 |   2 | sato   | jiro  |
|   3 |   1 | yamada | taro  |
+-----+-----+--------+-------+
6 rows in set (0.00 sec)

```

## varnishの設定
## 設定
https://cloudo3.com/ja/%E3%82%AF%E3%83%A9%E3%82%A6%E3%83%88%E3%82%99%E3%82%B3%E3%83%B3%E3%83%92%E3%82%9A%E3%83%A5%E3%83%BC%E3%83%86%E3%82%A3%E3%83%B3%E3%82%AF%E3%82%99/centos-7%E3%81%A6%E3%82%99apache%E3%81%AEvarnish-cache-5-0%E3%83%95%E3%82%9A%E3%83%AD%E3%82%AD%E3%82%B7%E3%82%92%E8%A8%AD%E5%AE%9A%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95/2157
```
#apacheの停止
[suzuki@suzuki-t varnish-7.0.0]$ sudo /usr/local/httpd/httpd-2.4.48/bin/apachectl stop

#apacheの設定変更
[suzuki@suzuki-t varnish-7.0.0]$ sudo vi /usr/local/httpd/httpd-2.4.48/conf/httpd.conf

Listen 80 -> Listen 8080

<VirtualHost 192.168.56.3:80> → <VirtualHost 192.168.56.3:8080>

#8080portにてapache起動
[suzuki@suzuki-t varnish-7.0.0]$ sudo /usr/local/httpd/httpd-2.4.48/bin/apachectl start

#varnish起動
[suzuki@suzuki-t varnish-7.0.0]$ sudo /usr/local/varnish/sbin/varnishd -a :80 -b 192.168.56.3:8080

#確認
[suzuki@suzuki-t ~]$ curl -I http://suzuki-t.com/wordpress
HTTP/1.1 301 Moved Permanently
Date: Mon, 18 Oct 2021 09:16:52 GMT
Server: Apache/2.4.48 (Unix) OpenSSL/1.0.2k-fips PHP/7.4.23
Location: http://suzuki-t.com/wordpress/
Content-Length: 238
Content-Type: text/html; charset=iso-8859-1
X-Varnish: 262146
Age: 0
Via: 1.1 varnish (Varnish/7.0)
Connection: keep-alive
