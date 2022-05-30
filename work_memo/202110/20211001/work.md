# teeコマンド
標準入力から受け取った内容を、標準出力とファイルに書き出すコマンド

ファイルに追記する時
-a オプションを付ける

-i, --ignore-interrupts
割り込みシグナルを無視する

割り込みシグナルとは？
ソフトウェアの割り込みを行う際に使うシグナルのこと
cntl + c もそのうちの１つ

シグナル　
プロセスとプロセスの間で通信を行う際に使用される合図だったり信号
プロセス間通信の一種で、 ある事象が起きたことを他のプロセスに知らせること

yum update | tee -i a.txt
yum update | tee b.txt
diff a.txt b.txt
読み込んだプラグイン:fastestmirror                              読み込んだプラグイン:fastestmirror
Loading mirror speeds from cached hostfile                      Loading mirror speeds from cached hostfile


[root@suzuki-t ~]# diff -y a.txt b.txt
PING 192.168.56.2 (192.168.56.2) 56(84) bytes of data.          PING 192.168.56.2 (192.168.56.2) 56(84) bytes of data.
64 bytes from 192.168.56.2: icmp_seq=1 ttl=64 time=0.020 ms   | 64 bytes from 192.168.56.2: icmp_seq=1 ttl=64 time=0.047 ms
64 bytes from 192.168.56.2: icmp_seq=2 ttl=64 time=0.029 ms   | 64 bytes from 192.168.56.2: icmp_seq=2 ttl=64 time=0.032 ms
64 bytes from 192.168.56.2: icmp_seq=3 ttl=64 time=0.030 ms     64 bytes from 192.168.56.2: icmp_seq=3 ttl=64 time=0.030 ms
64 bytes from 192.168.56.2: icmp_seq=4 ttl=64 time=0.030 ms   | 64 bytes from 192.168.56.2: icmp_seq=4 ttl=64 time=0.026 ms
64 bytes from 192.168.56.2: icmp_seq=5 ttl=64 time=0.030 ms   |
                                                              > --- 192.168.56.2 ping statistics ---
                                                              > 4 packets transmitted, 4 received, 0% packet loss, time 3157m
                                                              > rtt min/avg/max/mdev = 0.026/0.033/0.047/0.010 ms

cntl + cを使って検証し-iを付けることで最後まで実行結果を記録することが出来た。


## 2>&1
コマンドの出力には標準出力と標準エラー出力があり、番号が振られてる
1: 標準出力
2: 標準エラー出力


例
/usr/local/httpd/httpd-2.4.48/bin/apachectl start 2>&1 | tee -a /root/work_sh.log 






###
/usr/local/mysql5.6/support-files/mysql.server start 2>&1 | tee a.txt
にすると進まなくなってしまう
なぜ？

[suzuki@suzuki-t ~]$ sudo /usr/local/mysql5.7/support-files/mysql.server restart 2>%1 | tee a.txt
Shutting down MySQL.. SUCCESS!
Starting MySQL.. SUCCESS!
[suzuki@suzuki-t ~]$ sudo /usr/local/mysql5.7/support-files/mysql.server restart | tee a.txt
Shutting down MySQL.. SUCCESS!
Starting MySQL. SUCCESS!
[suzuki@suzuki-t ~]$ cat a.txt
Shutting down MySQL.. SUCCESS!
Starting MySQL. SUCCESS!
[suzuki@suzuki-t ~]$ sudo /usr/local/mysql5.7/support-files/mysql.server restart 2>&1 | tee a.txt
Shutting down MySQL.. SUCCESS!
Starting MySQL. SUCCESS!
^C
[suzuki@suzuki-t ~]$ cat a.txt
Shutting down MySQL.. SUCCESS!
Starting MySQL. SUCCESS!
[suzuki@suzuki-t ~]$ sudo /usr/local/mysql5.7/support-files/mysql.server restart 2>&1 | tee b.txt
Shutting down MySQL.. SUCCESS!
Starting MySQL. SUCCESS!
^C
[suzuki@suzuki-t ~]$ cat b.txt
Shutting down MySQL.. SUCCESS!
Starting MySQL. SUCCESS!
[suzuki@suzuki-t ~]$

2>&1を付けなければ正常に進む

systemctl経由で実行すれば発生しなくなるので、support-filesを直に実行するのを止めればいいとのことなので修正


# work.sh修正

## remiリポジトリは個人が管理しているのあまり使わないほうが良い

## mysqlログ用のディレクトリの所有者を変更する追記
ディレクトリ自体のオーナーをmysql:mysql にするべき

#ログ用のディレクトリとファイルを作成し、mysqlユーザーに権限を与える
mkdir /var/log/mariadb
touch /var/log/mariadb/mariadb.log
chown mysql:mysql /var/log/mariadb/mariadb.log

↓
#ログ用のディレクトリとファイルを作成し、mysqlユーザーに権限を与える
mkdir /var/log/mariadb
touch /var/log/mariadb/mariadb.log
chown -R mysql:mysql /var/log/mariadb


## phpエラーログ用ファイルを作成する行程がいらない
touch /usr/local/php/log/php_errors.log削除



##　回答
- yumをまとめていない

取り合えずgitに上げるのを優先してました。

- iptablesのルール設定の順番について

今回追加するルールについて下記設定の直前に設定出来ていれば良いと考えたので4つのルールの順番は考える必要がないと思ったのでに全部5番にした。
REJECT     all  --  0.0.0.0/0            0.0.0.0/0            reject-with icmp-host-prohibited

## ここで何をやっているのか
/usr/local/mysql5.7/bin/mysql -u root --socket=/usr/local/mysql5.7/data/mysql.sock -e"update mysql.user set authentication_string=PASSWORD('$root') where User='root';"
/usr/local/mysql5.7/bin/mysql -u root -p"$root" --socket=/usr/local/mysql5.7/data/mysql.sock -e"ALTER USER 'root'@'localhost' IDENTIFIED BY '$root';" --connect-expired-password 

ALTER USERでrootのパスワードを設定する必要があるのですがパスワード入力をスキップした状態でサーバーを起動しているとALTER USERが行えないので最初にrootに初期パスワードを設定してから改めてALTER USERでパスワードの再設定を行っています。



## データディレクトリを作成してから移動するのではなく初期化時に設定する
/usr/local/mysql5.7/bin/mysqld --initialize --user=mysql
↓
/usr/local/mysql5.7/bin/mysqld --initialize --user=mysql --datadir=/usr/local/mysql5.7/data



## my.cnfに文字コードと照合順序を設定すべき
### 設定可能な文字コードの確認
show character set;

下記をmy.cnfに追記
#文字コード
character-set-server=utf8
#照合順序
collation-server=utf8_general_ci





## php.iniの以下の設定について調べて適切に設定しておく
error_reporting = E_ALL | E_STRICT
display_errors on


error_reporting　表示するエラーのレベル[レベルのリスト](https://www.php.net/manual/ja/errorfunc.constants.php)

display_errors　画面にエラーの内容を表示するかの設定

## mysql起動方法を変更する
#mysqlを起動
/usr/local/mysql5.6/support-files/mysql.server start
↓
systemctl start mysqld57.service
systemctl start mysqld56.service

## 各パスワードの設定ファイル作成とコードの修正
- ベーシック認証
- digest認証
- mysql5.6 root
- mysql5.6 wordpress
- mysql5.7 root
- mysql5.7 wordpress
- wordpress1 user
- wordpress2 user
