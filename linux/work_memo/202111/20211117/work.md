## VPN(vitual private network)
- 通信の内容をカプセル化(トンネリング)し、傍受しても中身を確認できないようにするもの

## update等でデフォルトのidを使って検索を掛ける際は本番環境との確認を行う
## データベースの更新前に更新する対象が本当に存在するのか、指定しているものが正しい値なのか確認しよう
## 予約語は大文字にしておこう(会社や団体ごとに違うけれど見やすさ重視)
## 予約語の後ろのカッコの前にはスペースを入れよう(IN等)

## mysql now()を使う前に各設定を確認する
1. linux webサーバーのtime_zone設定
2. ntpサーバーとwebサーバーの同期をとっていること
3. mysqlサーバーのtime_zone,default_time_zone設定
4. mysqlクライアントのtime_zone設定
  - mysqlへアクセスするアプリケーション等の時間

- AWSの場合1と2は設定変更できないので3,4を確認しよう

## NTP（Network Time Protocol）
- 時刻情報を同期する為のプロトコル
- stratum
  - 時刻情報の信頼度
  - 0~15まで0が一番信頼度が高い,0は原子時計やGPS等の特定のものしか使用できないため実質１が最高
- 日本の代表的な公開NTPサーバー(このサーバーから時刻を受け取るように設定するといい？)
  - Stratum-1	clock.nc.fukuoka-u.ac.jp	133.100.9.2
  - Stratum-1	clock.tl.fukuoka-u.ac.jp	133.100.11.8
  - Stratum-2	ntp1.jst.mfeed.ad.jp	210.173.160.27
  - Stratum-2	ntp2.jst.mfeed.ad.jp	210.173.160.57
  - Stratum-2	ntp3.jst.mfeed.ad.jp	210.173.160.87

## mysqlのタイムゾーン
- 確認方法
  - 変数にがGLOBAL変数とSESSION変数がある
    - GLOBALはデータベースそのものの設定
      - オンライン(稼働中)に変更できるものと出来ないものがあるので注意
    - SESSIONはアプリケーションやwebサーバー等のクライアントと関連付けされた設定
```
mysql> SELECT @@GLOBAL.time_zone, @@SESSION.time_zone;
+--------------------+---------------------+
| @@GLOBAL.time_zone | @@SESSION.time_zone |
+--------------------+---------------------+
| SYSTEM             | SYSTEM              |
+--------------------+---------------------+
1 row in set (0.00 sec)

mysql> show variables like '%time_zone%';
+------------------+--------+
| Variable_name    | Value  |
+------------------+--------+
| system_time_zone | UTC    |
| time_zone        | SYSTEM |
+------------------+--------+
2 rows in set (0.00 sec)

```
- SYSTEMはsystem_time_zoneの値を参照することを意味します
- system_time_zoneはmysql起動時のサーバーのタイムゾーンを示す
- 変更
```
SET GLOBAL time_zone = 'SYSTEM';

#system_time_zoneは設定ファイルを変更する
#/etc/my.cnf
[mysqld]
default-time-zone = 'Asia/Tokyo'
```

## linux time_zone
- /usr/share/zoneinfo/以下のフォルダを/etc/localtime下にコピーすることで設定出来る
- 下記のようにシンボリックリンクでもOK
```
ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

[suzuki@suzuki-t ~]$ date
2021年 11月 17日 水曜日 16:20:32 JST
```
↓
- CentS7
  - timedatectlコマンドで変更する
    - status	現在の時刻と設定を表示する（デフォルト）
    - set-time 時刻	システムの時刻とRTCを設定する
    - set-timezone タイムゾーン名	タイムゾーンを設定する
    - list-timezones	使用できるタイムゾーンを一覧表示する
    - set-local-rtc 設定	RTCを使用するかどうかを1または0で指定する（yes／no、true／falseも使用可能）
    - set-ntp 設定	NTPを使用するかどうかを1または0で指定する（yes／no、true／falseも使用可能、※4）
```
timedatectl set-timezone Asia/Tokyo

#確認
[suzuki@suzuki-t ~]$ timedatectl status
      Local time: 水 2021-11-17 16:31:29 JST
  Universal time: 水 2021-11-17 07:31:29 UTC
        RTC time: 水 2021-11-17 07:31:27
       Time zone: Asia/Tokyo (JST, +0900)
     NTP enabled: yes
NTP synchronized: yes
 RTC in local TZ: no
      DST active: n/a

```

## apache time_zone
- php.iniファイル内のdate.timezoneに設定する
```
[suzuki@suzuki-t ~]$ php --ini
Configuration File (php.ini) Path: /usr/local/lib
Loaded Configuration File:         /usr/local/lib/php.ini
Scan for additional .ini files in: (none)
Additional .ini files parsed:      (none)

sudo vi /usr/local/lib/php.ini
; Defines the default timezone used by the date functions
; http://php.net/date.timezone
;date.timezone =

phpinfo()かphp -iで確認する(date部分)
```
