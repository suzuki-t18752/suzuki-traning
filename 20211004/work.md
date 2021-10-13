## php.iniの以下の設定について調べて適切に設定しておく
error_reporting = E_ALL | E_STRICT
display_errors on


error_reporting　表示するエラーのレベル[レベルのリスト](https://www.php.net/manual/ja/errorfunc.constants.php)

display_errors　画面にエラーの内容を表示するかの設定 本番ではOFF

例　
https://maku77.github.io/php/settings/error-level.html
; 本番環境（E_NOTICE, E_DEPRECATED, E_STRICT 以外を表示）
error_reporting = E_ALL ^ E_NOTICE ^ E_DEPRECATED
正常に動作しなくなるほどの問題ではないものは表示しない

https://www.gesource.jp/weblog/?p=4541
error_reporting = E_ALL ^ E_NOTICE ^ E_DEPRECATED

https://qiita.com/fallout/items/31f793708b243033fab1
E_ALL

#初期値
error_reporting = E_ALL
display_errors = On

#下記に変更
sed -i -e 's%display_errors = On%display_errors = Off%g' /usr/local/lib/php.ini
sed -i -e 's%error_reporting = E_ALL%error_reporting = E_ALL ^ E_NOTICE ^ E_DEPRECATED%g' /usr/local/lib/php.ini

## mysql起動方法を変更する
#mysqlを起動
/usr/local/mysql5.6/support-files/mysql.server start
↓

#systemctlで実行できるようプロセス起動用ファイルをinit.dへコピー
cp /usr/local/mysql5.7/support-files/mysql.server /etc/init.d/mysql57
cp /usr/local/mysql5.6/support-files/mysql.server /etc/init.d/mysql56

#ststemctlへの反映
systemctl daemon-reload

#mysql起動
systemctl start mysql57
systemctl start mysql56


## データディレクトリ初期化後のパスワード取得
DB_PASSWORD=$(grep "A temporary password is generated" /var/log/mariadb/mariadb.log | sed -s 's/.*root@localhost: //')

#初期化の履歴をログへ残すようにする
/usr/local/mysql5.7/bin/mysqld --initialize --user=mysql --datadir=/usr/local/mysql5.7/data 2>&1 | tee -a /var/log/mariadb/mariadb.log

## 各パスワードの設定ファイル作成とコードの修正
- ベーシック認証
- digest認証
- mysql5.6 root
- mysql5.6 wordpress
- mysql5.7 root
- mysql5.7 wordpress
- wordpress1 user
- wordpress2 user


mysql57_root resuraku0901
mysql56_root resuraku0901
mysql57_wp resuraku0901
mysql56_wp resuraku0901
basic xgKrcUG9iefRQ
digest 9dd2a825562f7e0b1af6f1ec1ff97c3c
wp_user_com resuraku0901
wp_user_net resuraku0901

mysql57_root_pass=$(cat /root/root.txt | grep mysql57_root | awk '{print $2}')
mysql56_root_pass=$(cat /root/root.txt | grep mysql56_root | awk '{print $2}')
mysql57_wp_pass=$(cat /root/root.txt | grep mysql57_wp | awk '{print $2}')
mysql56_wp_pass=$(cat /root/root.txt | grep mysql56_wp | awk '{print $2}')
basic_pass=$(cat /root/root.txt | grep basic | awk '{print $2}')
digest_pass=$(cat /root/root.txt | grep digest | awk '{print $2}')
wp_user_com_pass=$(cat /root/root.txt | grep wp_user_com | awk '{print $2}')
wp_user_net_pass=$(cat /root/root.txt | grep wp_user_net | awk '{print $2}')

↓

#変数名も一緒に指定して反映させるのが良い
例
MINIENTREGA_FECHALIMITE="2011-03-31"
MINIENTREGA_FICHEROS="informe.txt programa.c"
MINIENTREGA_DESTINO="./destino/entrega-prac1"

#反映
export $(cat env | xargs)

MYSQL57_ROOT_PASS=resuraku0901
MYSQL56_ROOT_PASS=resuraku0901
MYSQL57_WP_PASS=resuraku0901
MYSQL56_WP_PASS=resuraku0901
BASIC_PASS=xgKrcUG9iefRQ
DIGEST_PASS=9dd2a825562f7e0b1af6f1ec1ff97c3c
WP_USER_COM_PASS=resuraku0901
WP_USER_NET_PASS=resuraku0901

パスワード用のファイルを作成
MYSQL57_ROOT_PASS=~~~~~
MYSQL56_ROOT_PASS=~~~~~
MYSQL57_WP_PASS=~~~~~
MYSQL56_WP_PASS=~~~~~
BASIC_PASS=~~~~~
DIGEST_PASS=~~~~~
WP_USER_COM_PASS=~~~~~
WP_USER_NET_PASS=~~~~~

反映
export $(cat /root/.pass)



## xargsコマンド
標準入力からコマンドラインを作成して実行する
[参考](https://techblog.kyamanak.com/entry/2018/02/12/202256)

例
ファイル内のコマンドを実行出来る
-0で改行出来る？
-tで実行前のコマンドを表示する
cat a.txt | xargs -0t sh -c

-iで引数の位置を指定出来る
例
検索したファイルを/root下にコピーしてくる
[root@suzuki-t ~]# find / -name "*php.ini*" | xargs -ti cp {} /root/.
find: ‘/proc/29995’: そのようなファイルやディレクトリはありません
cp /usr/local/lib/php.ini /root/.
cp /usr/local/src/php-7.4.23/php.ini-production /root/.
cp /usr/local/src/php-7.4.23/php.ini-development /root/.
[root@suzuki-t ~]# ls -l
合計 276
-rw-r--r--. 1 root root    22 10月  4 15:41 a.txt
-rw-------. 1 root root  1530  9月 29 15:26 anaconda-ks.cfg
-rw-r--r--. 1 root root 27033  9月 22 15:27 centOSstart.png
-rw-r--r--. 1 root root 72601 10月  4 16:02 php.ini
-rw-r--r--. 1 root root 72554 10月  4 16:02 php.ini-development
-rw-r--r--. 1 root root 72584 10月  4 16:02 php.ini-production
-rw-r--r--. 1 root root 19086 10月  4 15:29 work.sh
-rw-r--r--. 1 root root  1383 10月  4 15:39 work_sh.log
[root@suzuki-t ~]# find /root -name "*php.ini*"
/root/php.ini
/root/php.ini-production
/root/php.ini-development

例
検索したファイルを一括削除
[root@suzuki-t ~]# find /root -name "*php.ini*" | xargs -t rm
rm /root/php.ini /root/php.ini-production /root/php.ini-development
[root@suzuki-t ~]# ls -l
合計 60
-rw-r--r--. 1 root root    22 10月  4 15:41 a.txt
-rw-------. 1 root root  1530  9月 29 15:26 anaconda-ks.cfg
-rw-r--r--. 1 root root 27033  9月 22 15:27 centOSstart.png
-rw-r--r--. 1 root root 19086 10月  4 15:29 work.sh
-rw-r--r--. 1 root root  1383 10月  4 15:39 work_sh.log




例
grep
-r 指定したディレクトリ以下を検索する
-l 出力をファイル名のみにする
[root@suzuki-t ~]# sudo grep -rl '<VirtualHost 192.168.56.3:80>' /usr/local/httpd/httpd-2.4.48/
/usr/local/httpd/httpd-2.4.48/conf/extra/httpd-vhosts.conf

指定したディレクトリ以下のファイル内<VirtualHost 192.168.56.3:80>を検索し、<VirtualHost 192.168.56.2:80>に書き換える
grep -rl '<VirtualHost 192.168.56.3:80>' /usr/local/httpd/httpd-2.4.48/ | xargs sed -i -e "s%<VirtualHost 192.168.56.3:80>%<VirtualHost 192.168.56.2:80>%g"

## sqlコマンドの実行結果を確認する

#wordpressユーザーの確認
/usr/local/mysql5.6/bin/mysql -t -u root --socket=/usr/local/mysql5.6/data/mysql.sock -e"select user, HOST from mysql.user where user='wordpress';" | tee -a /root/work_sh.log

#wordpress用DBの確認
/usr/local/mysql5.6/bin/mysql -u root --socket=/usr/local/mysql5.6/data/mysql.sock -e"show databases;" | tee -a /root/work_sh.log

#wordpress用データベースの権限がwordpressユーザーに付与されているか確認
/usr/local/mysql5.6/bin/mysql -u root --socket=/usr/local/mysql5.6/data/mysql.sock -e"show grants for 'wordpress'@'localhost'" | tee -a /root/work_sh.log