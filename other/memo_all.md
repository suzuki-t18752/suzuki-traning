## VScode setting.json
```
{
    "security.workspace.trust.untrustedFiles": "open",
    "files.eol": "\n",
    "files.insertFinalNewline": true,
    "workbench.startupEditor": "none",
    "editor.tabSize": 2,
    "workbench.editor.wrapTabs": true,
    "workbench.colorCustomizations": {
        "tab.activeBackground": "#8b8b8b",
        "tab.activeForeground": "#1d1d20",
        "tab.inactiveForeground": "#848490",
    },
    "workbench.editorAssociations": {
        "*.log": "default",
        "*.pdf": "default"
    },
    "workbench.editor.untitled.hint": "hidden",
    "editor.accessibilitySupport": "off",
    "code-eol.crlfCharacter": ""
}
```

## VScode 2つのファイルを比較する
1. 比較元のファイルを選択しておく
2. 表示→コマンドパレットを選択
3. コマンドパレットが表示されたら「比較」と入力
4. 「アクティブファイルを比較しています」を選択
5. 比較先のファイルを選択すると2つのファイルが並んで表示される

## iptables
  - iptables ソースIPの制限
  - iptables デスティネーションIPの制限

-A チェイン -s どこから -d どこに(IP) -p どうやって --dport どこに(Port) -j どうする
iptabels -A INPUT(チェイン) -p http(プロトコル) -s 192.168.56.1(送信元のipアドレス) -d (送信先ipアドレス) -(s or d)port(ポートの指定) -j ACCEPT(ルール参照後の結果 ACCEPT,DROP,RETURN,REJECT)

例
-A INPUT -s 10.20.30.40/32 -d 192.168.100.200/32 -m tcp -p tcp --dport 12345 -j ACCEPT

-I チェーン内のユーザー定義の数値で指定された位置に規則を挿入します。数値が指定されていない場合、iptables はそのコマンドをチェーンの最上部に置きます。

sudo iptables -nL --line-numbersにてルールの番号を確認する

コマンドにて設定を変更した場合即時反映される為、プロセスを再起動する必要はない(※注意して設定する)



## tar.gz とは
  - tarの意味
  「tar」コマンドでまとめたアーカイブファイル
  ファイルの圧縮はされずに1つのファイルをまとめて管理することが目的

  - gzの意味
  「gzip」コマンドで圧縮した圧縮ファイル

### アーカイブファイル
複数のファイルをまとめて一つのファイルへ変換したファイルの事

## ソケットファイル(.sock)
共有メモリの変わり、ファイルを共有することでデータを共有する

### 圧縮、解凍
圧縮とはデータの内容 (意味) を変えずに、そのサイズを小さくすることです。反対に圧縮ソフトなどでサイズの小さなファイルに変換されたデータを、元の状態に復元することを解凍もしくは展開と言う


## LFSの理解

https://ja.wikipedia.org/wiki/Filesystem_Hierarchy_Standard


## makeコマンドは何をしているのか？
  - コンパイルとは？

    プログラミング言語で記述されたソフトウェアの設計図（ソースコード）を、コンピュータが実行可能な形式（オブジェクトコード）に変換する作業

    ソースコードは人間に読み書きしやすい形式の言語によって記述されたもので、コンピュータ内部のマイクロプロセッサ（MPU/CPU）にそのまま与えてもプログラムとして実行することはできず、コンピュータの理解できる機械語のプログラムへ変換しなければならない

  - オブジェクトファイルとは？

  　ソースコードをコンパイラが翻訳した結果生成される機械語のデータ


  - リンカとは?

  　リンカとは、機械語のプログラムの断片を適切に結合し、実行可能なプログラムとして生成するためのプログラム

  　高水準言語によって書かれた複数のソースコードを、それぞれ機械語に翻訳(コンパイル)した時、それらはまだ実行できるプログラムではありません。これらを適切に配置するのがリンカであり、　このようにプログラムの断片を適切に構成する作業をリンク


  - それぞれ具体的にどのようなことが起きるのか？
    - make

    Makefileを元にソースコードをコンパイルする

    makeは、複数のファイルが依存して構成されているものをコンパイルする作業の負担を軽減する目的

    - make install

    makeで生成されたバイナリファイルなどを規定のディレクトリにコピー（インストール）を行う


  - インストール先のディレクトリの意味
    - bin/
    バイナリファイルが入る
    - include/
      - headerファイルとは
      プログラムのソースコードの一部であり、そのプログラムにおいて使用される変数や定数、関数、その他あらかじめ宣言する必要があるデータ・命令の宣言を記述した文書ファイル
      ソースファイルの冒頭部分で読み込まれ、ソースコード本体の処理が開始される前に、事前にソースコードに登場する全てのデータや命令を宣言するために存在します。ソースコードでは事前に宣言していない変数や関数は使用できませんので、このようにヘッダーファイルを利用して、一括で必要な宣言を行います
    - lib/
      - soとは？
      共有(プログラムの部品)ライブラリにつく拡張子

- ext(extension)
拡張ファイルの置き場


## パーミッションとは？ drwx 777
ファイルシステム上でファイルやディレクトリなどに設定されるユーザーやユーザーグループごとのアクセス権限のこと

- 755などの数字
左の数字がOwner権限、中央の数字がGroup権限、右の数字がOther権限を意味し、
それぞれの桁について、

4：読み込み許可、
2：書き込み許可、
1：実行・ディレクトリ一覧許可、

という数字を足し合わせた値で具体的な権限の内容を指定する。

「7」は 4+2+1 ですべての権限を許可された状態、
「0」は何の権限もない状態

- drwx(-rw-r--r--)
2～4桁目はOwner権限、左から5～7桁目はGroup権限、右3桁はOther権
無い場合は「-」
「rwx」は全権限あり、「---」は全権限なし

 - ディレクトリの実行権限

## 集計等を行えるコマンド
awk '{printf $3"\n"}' ans.txt | sort | uniq -c

sort test.csv| uniq -c | sort -nr -k 1 | less

## sortコマンド
- 順序を並びかえるコマンド
```
sort -nr -k 1
```
- -n 数値比較
- -r 降順
- -k 比較場所の指定(上の場合は1文字目)

## uniqコマンド
- 同じ文字列を1つにまとめるコマンド
- -c 同じものの数を数える

## sudoとrootでは環境変数が違う

## 環境変数
- プロセス間で引き継ぐ
## シェル変数
- プロセス間で引き継がない

## manコマンド
コマンドの説明が見れる

/検索したい文字
で検索もできる
Nで次の検索結果

## tailコマンド
末尾10行を表示する
- -n
出力する行数を指定する

- -f
リアルタイムでログ等が見れる
ファイルの追記を監視する

## headコマンド
先頭の10行を表示する

### headとtail
他のコマンドと組み合わせて| headで使用出来る

## diffコマンド
ファイルの差異を比べることが出来る

-i で差分を出す
-y　でファイルを２つ並べて見れる

## patchコマンド
diffコマンドにて発見んした差異をファイルに反映することが出来る

## grep コマンド
ファイル中の文字列を検索するコマンド

grep 検索文字列 ファイル名

## find コマンド
ファイルやディレクトリを検索するコマンド

find ファイル名

find ディレクトリ名 -name “*ファイル名*”

## psコマンド
linux上で動作しているプロセスを確認する

ps auxww | grep mysqld

## topコマンド
「top」は現在実行中のプロセスをCPU利用率が高い順に表示

## sedコマンド
ファイル内の置換を行えるコマンド

sudo sed -i -e 's%socket=/var/lib/mysql/mysql.sock%socket=/tmp/mysql.sock%g' /etc/my.cnf

sed -e '数字i 文字列' ファイル名

sudo sed -ie '2i skip-grant-tables' /etc/my.cnf

## umakeコマンド
パーミッションの初期設定を行える

## odコマンド
ファイルをバイナリとして表示する

## stringsコマンド
バイナリファイルやデータファイルから“文字列”として読める箇所を表示するコマンド

## fileコマンド
拡張子に関係なくファイルの中身からファイルの形式を判断、表示してくれる

## dfコマンド
ディスクの空き領域（freeスペース）のサイズを集計して表示する
空き領域は、マウントしているファイルシステムごと、つまり、パーティションごとに表示される

- -h
  - サイズに応じて読みやすい単位で表示する
```
[test ~]$ df -h
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        3.9G     0  3.9G   0% /dev
tmpfs           3.9G     0  3.9G   0% /dev/shm
tmpfs           3.9G   97M  3.8G   3% /run
tmpfs           3.9G     0  3.9G   0% /sys/fs/cgroup
/dev/nvme0n1p1   20G   20G  904M  96% /
tmpfs           790M     0  790M   0% /run/user/1001
```

## duコマンド
ディスクの使用量をディレクトリごとに集計して表示する

## ctrl + a u e r c z q s
- a 行の先頭に移動

- u カーソルの位置から行頭まで削除

- e 行末へカーソルを移動

- r コマンド履歴の検索

- c 処理をキャンセルする

- z 処理を一時中断する(再開する場合はfgと入力する)

- q sでロックした画面の解除をする

- s コマンド入力ができないように画面をロックする

## exit codeとその意味
コンピュータプログラミングにおけるプロセスの終了ステータス

bashの場合
終了ステータスの範囲は 0 から 255 で、0 は正常終了、それ以外は異常終了
$?でコードを取得できる

## echo cat HEREDOC

- '>>','>'　リダイレクト、リダイレクション
- '|' パイプ

echo '文字列' > ファイル名 でファイルに書き込みが出来る。ファイルがなければ新規作成される。既存ファイルなら上書きされるので注意。
echo '文字列' >> ファイル名 最終行へ追加する

複数行まとめて
cat << EOS
hoge
fuga
piyo
EOS

- shコマンドを使ってリダイレクションする理由
sudo sh -c "echo '<?php echo phpinfo(); ?>' >> /var/www/html/index.php"
sudoコマンドでechoの処理はroot権限で行われるがリダイレクションに関しては一般ユーザーで行われる為

## awkコマンド
区切られた列の値を出力する
print $1で1列目

awk -F'[フィールド区切り文字(複数可能)]' -v '変数=xx' '{awkコマンド}' file


## mysql
### mysql < sqlファイル
/usr/local/mysql/bin/mysql -t < employees.sql -u root -p
ファイル内のsqlコマンドを実行する

### mysql -t
表形式を結果を出力する

### mysql -vv
実行したクエリと実行されたレコード数を表示する

```sql
$ mysql -unn -pnn -h 999.99.99 -P nn  -e 'SELECT * FROM a limit 3;'
mysql: [Warning] Using a password on the command line interface can be insecure.
--------------
SELECT * FROM a limit 3
--------------

+----+---+---+-----+----------------------------+----------------------------+
| id | a | b | c   | created_at                 | updated_at                 |
+----+---+---+-----+----------------------------+----------------------------+
|  1 | 8 | 1 | A01 | 2023-08-22 18:49:45.797440 | 2023-08-22 18:49:45.797440 |
|  2 | 8 | 1 | A02 | 2023-08-22 18:49:45.889981 | 2023-08-22 18:49:45.889981 |
|  3 | 8 | 1 | A03 | 2023-08-22 18:49:45.968224 | 2023-08-22 18:49:45.968224 |
+----+---+---+-----+----------------------------+----------------------------+
3 rows in set (0.00 sec)

Bye
```

### mysql -e
直接クエリを実行する

```sql
$ mysql -unn -pnn -h 999.99.99 -P nn  -e 'SELECT * FROM a limit 10;'
```

### DBの一覧を表示
```
show databases;
```

### 使用するDBの指定
```sql
use a_table;
```


### 権限を追加する
- https://qiita.com/shuntaro_tamura/items/2fb114b8c5d1384648aa (追加方法について)
```sql
GRANT (権限、UPDATEやSELECT等) ON (テーブルやDB) TO ユーザー
GRANT SELECT ON a_table.users TO 'application'@'%';
```


# 権限を確認する
```sql
show grants for 'application'@'%';
```

### 時間の差を確認する
- TIMEDIFF(a, b)
  - a - b = TIMEDIFF(a, b)
```
mysql> SELECT updated_at, created_at, TIMEDIFF(updated_at, created_at) FROM aaaaa;
+---------------------+---------------------+----------------------------------+
| updated_at          | created_at          | TIMEDIFF(updated_at, created_at) |
+---------------------+---------------------+----------------------------------+
| 2024-03-28 12:18:14 | 2024-03-28 12:15:50 | 00:02:24                         |
| 2024-03-28 12:16:11 | 2024-03-28 12:16:11 | 00:00:00                         |
| 2024-03-28 12:16:11 | 2024-03-28 12:16:11 | 00:00:00                         |
| 2024-03-28 12:16:11 | 2024-03-28 12:16:11 | 00:00:00                         |
| 2024-03-28 12:16:13 | 2024-03-28 12:16:13 | 00:00:00                         |
+---------------------+---------------------+----------------------------------+
```


### キャッシュ等のメモリのリロード
INSERT、UPDATE、DELETE (非推奨)で権限を追加、ユーザーの追加等をした際は下記を実行する必要がある
実行しないと反映されない
```sql
FLUSH PRIVILEGES;
```


### [mysql EXPLAIN(INDEXの確認)](https://dev.mysql.com/doc/refman/8.0/ja/explain.html)
- https://qiita.com/tsurumiii/items/0b70f1a1ee0499be2002
- 例
```
EXPLAIN SELECT * FROM users WHERE id = 1
```
```
結果
+----+-------------+-------+------------+-------+---------------+---------+---------+-------+------+----------+-------+
| id | select_type | table | partitions | type  | possible_keys | key     | key_len | ref   | rows | filtered | Extra |
+----+-------------+-------+------------+-------+---------------+---------+---------+-------+------+----------+-------+
|  1 | SIMPLE      | users | NULL       | const | PRIMARY       | PRIMARY | 4       | const |    1 |   100.00 | NULL  |
+----+-------------+-------+------------+-------+---------------+---------+---------+-------+------+----------+-------+
```

- id 実行順序
- select_type
  - SIMPLE: 単純な SELECT (UNION やサブクエリーを使用しません)
  - PRIMARY: もっとも外側の SELECT
  - UNION: UNION 内の 2 つめ以降の SELECT ステートメント
  - DEPENDENT: UNION 内の 2 つめ以降の SELECT ステートメントで、外側のクエリーに依存します
  - UNION RESULT: UNION の結果。
  - SUBQUERY: サブクエリー内の最初の SELECT
  - DEPENDENT SUBQUERY: サブクエリー内の最初の SELECT で、外側のクエリーに依存します
  - DERIVED: 派生テーブル SELECT (FROM 句内のサブクエリー)
  - MATERIALIZED: 実体化されたサブクエリー
  - UNCACHEABLE SUBQUERY: 結果をキャッシュできず、外側のクエリーの行ごとに再評価される必要があるサブクエリー
  - UNCACHEABLE UNION: キャッシュ不可能なサブクエリーに属する UNION 内の 2 つめ以降の SELECT
- table	対象テーブル
- partitions	テーブルパーティション
- type
  - system: テーブルに1行しかない
  - const: プライマリキー、ユニークキーのルックアップによるアクセス
  - eq_ref: joinにおいてのconstと同義
  - ref: constでないインデックスを使って等価検索
  - range: indexを用いた範囲検索
  - index: フルインデックススキャン
  - ALL: フルテーブルスキャン
  - fulltext: FULLTEXTインデックスによる検索
  - ref_or_null: refに追加でNULL値でも検索する
  - index_merge: インデックスマージ最適化を使用
  - unique_subquery: 効率化のため、サブクエリーを完全に置き換える単なるインデックスルックアップ関数
  - index_subquery: 働きは、unique_subqueryと同様。サブクエリー内の一意でないインデックスに対して機能する
- possible_keys	optimizerがテーブルのアクセスに利用可能だと判断したインデックス
- key	実際にoptimizerによって使用されたキー
- key_len	選択されたキーの長さ
- ref
  - 定数の場合: const
  - JOINを使用している場合: 結合する相手側のテーブルで検索条件として利用されているカラムが表示される
- rows	対象テーブルから取得される行の見積もり
- filtered	テーブル条件によってフィルタ処理される行の推定の割合
- Extra	optimizerがどのような戦略を立てたかを知ることが出来る

## timeコマンド
実行時間の表示

## screenコマンド
外部のサーバーに接続した際、ネットワークが切れると実行した処理が停止してしまう
このコマンドを使うと独立したセッションを作成して、ネットワークが切れても処理が停止せず、続けることが出来る
サーバーに接続して処理時間の長いものを実行する場合は必ずこのコマンドを使うようにする！！！！

## scpコマンド
異なるサーバー間でsshを利用しファイルのコピーを行える

```
scp ユーザ名@サーバのホスト名(or IPアドレス):コピーしたいファイル 保存先のパス

サーバーからローカルへ
scp suzuki@suzuki-web:/opt/suzuki.jp/public/suzuki.html ./

ローカルからサーバーへ
scp  ./suzuki.html　suzuki@suzuki-web:/opt/suzuki.jp/public/
```

## xargsコマンド
標準入力からコマンドラインを作成して実行する
[参考](https://techblog.kyamanak.com/entry/2018/02/12/202256)

```
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
```

## crontabコマンド
- cronへの指示を行うコマンド
- -e
  - cronの設定を編集するコマンド、1番最初は作成が行われる
  - viエディターと同じ操作
- -l ログインユーザーが登録したcronの設定を確認する
  - rootユーザーの場合だけ -l ユーザー名 で他のユーザーの設定を確認出来る

```
[- ~]$ crontab -l
@monthly date >> test.log
[- ~]$ crontab -e
crontab: installing new crontab
[- ~]$ crontab -l
@weekly date >> test.log
```


## 認証認可の意味違い
認証とは、相手の身元を確認すること
認可とは、権限を与えること

## 秘密鍵のフォーマット
puttyとubuntuで違うので注意

## プロキシの種類
- フォワードプロキシ
一般的にWEBプロキシサーバと言われているのは「フォワードプロキシ」です。クライアントとサーバの間に設置し「社内ネットワークー公開ネットワーク間」の通信の代理や中継を行います

- リバースプロキシ
「逆プロキシ」とも。リバースプロキシは、フォワードプロキシがクライアントの代理接続のために設置されるのに対し、WEBサイトへのリクエストを代理受付するためにWEBサーバの前に設置します
外部ネットワークの通信をフロントで受け付けることで、直接WEBサーバへのアクセスができなくなるため不正アクセスを防止できます。また、キャッシュを保持することでWEBサーバへの負荷を軽減できる上、設定をすれば、特定のIPアドレスのみアクセス許可することができ、不正なアクセスを遮断する役割も果たします

## gitの使い方、githubの使い方
基本的にmainにはpushしない
作業用のブランチをcheckout -bコマンドにて作成し作業ブランチに移動して作業を行い、リモートの作業ブランチにプッシュする
その後プルリクエストを画面にて行い、mainへマージをかけて更新する。
複数人にて作業を行う場合はマージの際に他の作業者の差分をフェッチやプル等で取り込んでくる必要がある(コンフリクト)

### 分岐元ブランチを確認
```
git show-branch | grep '*' | grep -v "$(git rev-parse --abbrev-ref HEAD)" | head -1 | awk -F'[]~^[]' '{print $2}'
```

###  リモートを含め全てのブランチを確認する
```
git branch -a
```

### リモートのブランチをローカルに取り込む
```
1. git fetchでリモートの情報を取得
2. git checkout リモートのブランチ名 でブランチを切り替える

取り込み後に"detached HEAD ~~~~~~"の表示がある場合下記コマンドでブランチ名を指定する必要がある
git branch 任意のブランチ名
```

###  git merge
  - 指定したブランチの変更を取り込む
    - 取り込み元のブランチは消えない
    ```
    git merge 取り込みたいブランチ名

    $ git merge test_20220511
    Merge made by the 'recursive' strategy.
    app/views/s.html.erb    | 15 +++++++++++++++
    config/c.rb             | 10 ++++++++--
    ```
### 直前のコミット取り消し
  - git reset --soft HEAD^

### commit メッセージ変更
  - git commit --amend -m ''

### 変更を一時保存
  - git stash
  - 一時保存のリスト
    - git stash list
  -  最新のスタッシュを適用し、削除
    - git stash pop
  - N番目のスタッシュを適用し、削除
    - git stash pop stash@{N}
  - 最新のスタッシュを適用し、残す
    - git stash apply
  - N番目のスタッシュを適用し、残す
    - git stash apply stash@{N}
  - 最新のスタッシュを削除
    - git stash drop
  - N番目のスタッシュを削除
    - git stash drop stash@{N}
  - スタッシュを全削除
    - git stash clear

### タグの作成と反映
```
git checkout main
git pull
git tag v36.46.7
git push --tags
```

- タグの削除
  - git tag -d v36.46.7
- タグの削除をリモートへ反映する場合
  - git push -d origin v36.46.7
  - 反映後にgithubのreleasesも削除する
- タグの確認
  - git tag

- 切り戻しをする際
  - 先に低いバージョンのbranchへチェックアウトする必要がある
  - git checkout v36.46.6
  - その後古いバージョンをデプロイする

### commitを1つまとめる
- まとめる
  1. git logでまとめたコミットを確認する
    ```
    suzuki@DESKTOP-G7N3ULO:~/suzuki$ git log
    commit ff3835fb570ca503aa228d616d3e3e7b1cff1111 (HEAD -> test, origin/test)
    Author: suzuki <test@example.com>
    Date:   Wed Apr 10 16:02:41 2024 +0900

        test

    commit 194b9bcacdf24ca3f8c04e9b3633dd5182af1234
    Author: suzuki <test@example.com>
    Date:   Wed Apr 10 16:01:11 2024 +0900

        test2
    ```
  2. git rebaseでコミットをまとめる
    ```
    git rebase -i HEAD~~~~
    ~はまとめたいコミット数分付ける、今回は上記ログでみたコミット2つなので2個付けている

    コマンドを実行すると下記のようにvimエディターが開く
    pick 8145f1c test
    pick d90db4a test2

    # Rebase ed7420a..71a6940 onto ed7420a
    #
    # Commands:
    ```
  3. pick → squashに書き換える
    - 残したい方はpickのまま、削除したい方をsquashにする
    - pickを上に配置してそのpickにまとめたいものを下に配置する
      ```
      pick 8145f1c test
      squash d90db4a test2
      ```
    - 複数残したい場合
      - 下記の場合はtestとtest3が残る
      - testにtest2が入り、test3にtest4が入る
      ```
      pick 8145f1c test
      squash d90db4a test2
      pick 8145f1c test3
      squash d90db4a test24
      ```
    - 最後にvimエディターなので:wqで編集完了をすると下記のようなコメント編集画面が開く
      ```
      # This is a combination of 2 commits.
      # The first commit's message is:

      test

      # This is the 2nd commit message:

      test2
      ```
  4. コメントを編集する
    - `first commit's`の部分が1行目、`2nd commit`の部分が2行目として残る
      ```
      # This is a combination of 2 commits.
      # The first commit's message is:

      test

      # This is the 2nd commit message:

      test2
      ```
    - 1行にしたい場合(削除するだけで良い)
      ```
      # This is a combination of 2 commits.
      # The first commit's message is:

      test test2

      # This is the 2nd commit message:

      ```
    - 最後にvimエディターなので:wqで編集完了をする
  5. 完了すると下記のような表示になる
    ```
    suzuki@DESKTOP-G7N3ULO:~/suzuki$ git rebase -i HEAD~~~~
    [detached HEAD 2c86bca64c] test
    Date: Wed Apr 10 15:29:53 2024 +0900
    1 files changed, 61 insertions(+), 30 deletions(-)
    create mode 100644 test.rb
    Successfully rebased and updated refs/heads/test
    ```
  6. git logでcommitがまとまっていることを確認する
    ```
    suzuki@DESKTOP-G7N3ULO:~/resraku$ git log
    commit 2c86bca64c0cecbb7f63308b52b9845bf6d32345 (HEAD -> test)
    Author: suzuki <test@example.com>
    Date:   Wed Apr 10 15:29:53 2024 +0900

        test test2
    ```
  7. pushする
   - force pushする必要がある
    ```
    git push -f origin test
    ```
- エラーが出た際
  - 下記で変更用のファイルを消す
  ```
  rm -fr ".git/rebase-merge"
  ```


## yum groupinstall "Development Tools"

[Development Tools](https://qiita.com/old_/items/6f9da09b9af795c11b71)

## sudo yum install cmake ncurses-devel zlib-devel libaio-devel
```
(1/5): libaio-devel-0.3.109-13.el7.x86_64.rpm                                                                                                                                               |  13 kB  00:00:00
(2/5): libarchive-3.1.2-14.el7_7.x86_64.rpm                                                                                                                                                 | 319 kB  00:00:00
(3/5): zlib-devel-1.2.7-19.el7_9.x86_64.rpm                                                                                                                                                 |  50 kB  00:00:00
(4/5): ncurses-devel-5.9-14.20130511.el7_4.x86_64.rpm                                                                                                                                       | 712 kB  00:00:00
(5/5): cmake-2.8.12.2-2.el7.x86_64.rpm
```

## yumのパッケージの中には何が入っているかを調べる cmake
  - rpm(アーカイブファイル)

- develパッケージ(development)
通常のパッケージと一緒に開発に必要なヘッダーファイルが含まれている



## bison(パッケージ)
Bison（バイソン）とは構文解析器を生成するパーサジェネレータの一種であり、CコンパイラとしてのGCCのサポートのために開発されたフリーソフトウェア

- 構文解析器 構文解析をおこなうプログラム。パーサ (parser)ともいう

- パーサジェネレータ 構文解析器(解釈)を作成するプログラム

## bios
PCを立ち上げた時に最初に動くハードウェアを制御するプログラム
OSが動く前のことをやってくれる

## virtualbox
仮想環境をPC内に構築して他のOSを使用出来るようにする為のソフト

## linux
OS(ソフトウェアとハードウェアを繋ぎ基本的な機能を使用する為のソフト)の種類の1つ

## centOS7
linuxを使用する為の機能、プログラムが集められたもの

## ホストOS
VirtualBoxを起動しているOS

## ゲストOS
VirtualBoxで起動しているOS

## NAT
ゲストOSから外部のネットワークに対してはアクセスすることが出来るが、ホストOSを含めた外部からはアクセスすることが出来ない設定

## ホストオンリーアダプター
ゲストOSに対して、ホストOSのみがアクセス出来、ゲストOSは他へアクセスすることの出来ない設定

## ファイアウォール
ネットワークの境界に設置され、外部から内部への通信をさせるかどうかを判断し許可するまたは拒否する仕組み

## iptables
Linuxに実装されたパケットフィルタリング型のファイアウォール機能

## パケットフィルタリング
外部から受信したデータ(パケット)を管理者などが設定した一定の基準に従って通したり破棄したりする。
プロトコル (TCPやUDP、ICMP等、送信元・送信先IPアドレス、送信元・送信先のポート番号を使って条件を設定し、パケットのフィルタリングをする。

## firewalldとiptabels違い
firewalldはcentOS7にデフォルトで設定されているファイアウォール
iptablesでは3つの情報を指定して条件を作りフィルタリングする。
firewalldはiptablesよりも簡易的に設定ができるように「ゾーン」という設定のテンプレートが用意してある。
簡単な設定で十分な場合はfirewalldを選択、より細かく設定したい場合はiptablesを選択。

## apache
webサーバーソフトウェアの１つ

## APR
OSとソフトウェアの間でOSなどの環境の違いを吸収するAPI。他のOSに一般的にある機能が存在しないOSでは、APRが代替を提供する

## バーチャルホスト
バーチャルホストという用語は、1 台のマシン上で (www.company1.com and www.company2.com のような) 二つ以上のウェブサイトを扱う運用方法のこと

## ベーシック認証
Webサイトの閲覧に使うプロトコル「HTTP」が備える、最も基本的なユーザ認証方式。 アクセスの制限されたWebページにアクセスしようとすると、Webブラウザでユーザ名とパスワードの入力を求め、サーバでアクセスを許可しているユーザに一致すると、ページを閲覧することができる

## ダイジェスト認証
WebサーバとWebブラウザなどの間で利用者の認証を行う方式の一つで、認証情報をハッシュ化して送受信する方式。

### mysql_ssl_rsa_setup
SSLを使用した安全な接続と、暗号化されていない接続を介したRSAを使用した安全なパスワード交換をサポートするために必要なSSL証明書とキーファイル、およびRSAキーペアファイルを作成する

### Require all granted [参考](https://www.javadrive.jp/apache/allow/index1.html)
ディレクトリのアクセス制限を設定していてこの場合は全て許可する設定

## ハッシュ化
ある特定の文字列や数字の羅列を一定のルール（ハッシュ関数）に基づいた計算手順によって別の値（ハッシュ値）に置換させることをさします

## データディレクトリ
mysqlサーバーによって管理される情報を格納するディレクトリ

## ホスト名を変更する
sudo hostnamectl set-hostname ホスト名

### apxs
apxsとは「APache eXtenSion tool」
Apacheの拡張モジュールをビルドしてインストールするためのツールです。
後から拡張モジュールを組み込んだり、モジュールだけ再コンパイルして入れ直したりすることができます。
DSOサポートが有効になっている必要があります。

- 有効かの確認方法　httpd -l
Compiled in modules:
  core.c
  prefork.c
  http_core.c
  mod_so.c
→core.c、mod_so.cがあればOK

## DDL　SQL群のファイル
DDL(Data Definition Language)とは、データ定義言語と呼ばれ、データベース内の表、ビューやインデックスなどの各種オブジェクトの作成や変更をするためのSQL文

## linuxのファイルシステムについて


## リポジトリとは
倉庫とか格納庫

## phpとapacheの関係
[参考](http://memories.zal.jp/WP/wordpress/archives/42)
Webサーバに置かれるソフトウエアの Apacheモジュールとして動作するスクリプト言語を実行する環境

## シバン
UNIXのスクリプトの #! から始まる1行目

パスを指定している
https://ja.wikipedia.org/wiki/%E3%82%B7%E3%83%90%E3%83%B3_(Unix)#:~:text=%E3%82%B7%E3%83%90%E3%83%B3%E3%81%BE%E3%81%9F%E3%81%AF%E3%82%B7%E3%82%A7%E3%83%90%E3%83%B3%20(%E8%8B%B1%3A%20shebang,%E7%9A%84%E3%81%8B%E3%81%A4%E7%B0%A1%E7%B4%A0%E3%81%A7%E3%81%82%E3%82%8B%E3%80%82


## 2>&1
コマンドの出力には標準出力と標準エラー出力があり、番号が振られています。

1: 標準出力
2: 標準エラー出力

これを同時に入力した場合に使える

## シグナル(割り込みシグナル等)
プロセスとプロセスの間で通信を行う際に使用されるもの

### パスを通す(全ユーザー)
/etc/profile　の最終行にexport PATH=$PATH:を追記する
[suzuki@suzuki-t siege-4.1.1]$ sudo cp /etc/profile /etc/profile_bak

## マジックナンバー
- マジックナンバーとは、コンピュータプログラムのソースコードなどに直に記述された数値で、その意味や意図が記述した本人以外には自明ではないもの。そのような値などをコード中に直に書いてしまうことを「ハードコード」という。
- コード中に「10」といった数値リテラルだけが書いてあり、それが何を意味するのか、何に由来するのか知る手掛かりが残されていないようなものを指す。後で他の人が見ても（ひどい場合には本人が見ても）それが何を表すのかが分からなかったり、修正が難しくなったりすることが多い

## コネクションプール
- データベースへ接続するときに接続状態を保持しておきそのコネクションを再利用することでデータベースへの接続を短縮する機能のこと
- コネクションプールの設定はRDBにしかない
- コネクションは不足するとDBへの接続リクエストは待ち状態になり、待ち状態のまま一定時間が経過するとActiveRecord::ConnectionTimeoutErrorが発生する

## カバレッジ
- 網羅率、影響範囲、適応範囲のこと
- テストカバレッジという言葉もあり、そのテストがどの程度確認が出来るのか分かる

## コンテキスト context
- 文脈、前後関係、事情、背景、状況など
- ITの分野では、利用者の意図や状況、環境などの総体を表したり、同じ処理や記述でも状況に応じて動作などが異なる場合に、その選択基準となる判断材料や条件などを指す


## curlでpostを行う
```
curl -X POST -H "Content-Type: application/json" -d '{"rsv_id":"1"}' http://localhost:3000/api/v1/
```

## 正規表現
- https://help.alteryx.com/2019.1/ja/boost/character_class_names.html
- 数列のみ
  - ^[0-9]+$

- ruby 正規表現
  - ^	Start of line
  - $	End of line
    - 改行ok
  - \A	Start of string
  - \z	End of string
    - 改行ng
- 改行が入った場合に有効か無効か変わる為基本的に\Aと\zを使うべき


## ピア
- https://e-words.jp/w/%E3%83%94%E3%82%A2.html#:~:text=%E3%83%94%E3%82%A2%E3%81%A8%E3%81%AF%E3%80%81%E5%90%8C%E5%83%9A%E3%80%81%E5%90%8C%E8%BC%A9,%E3%81%AE%E3%81%93%E3%81%A8%E3%82%92%E3%83%94%E3%82%A2%E3%81%A8%E3%81%84%E3%81%86%E3%80%82
- https://wa3.i-3-i.info/word1306.html
- サーバーとクライアントのような役割分担や上下関係のない、対等な機器同士が相互に通信する接続形態


## トラフィック
- https://wa3.i-3-i.info/word1972.html
- ネットワークに流れる情報もしくは情報量のこと

## ハードコーディング
- 本来いくつかの処理に分けるべき処理をまとめてしまうこと

## インメモリ
- ソフトウェアを実行する際、使用するプログラムやデータのすべてをメインメモリ(RAM)上に読み込み、ストレージ(外部記憶装置)を使わないこと

## インメモリデータベース
- メモリ上でデータを管理する
- Redis

## Redis
- メモリ上で動作するデータベース
  - Webアプリケーションのセッションやキャッシュの一時的な保存先に指定することで、アクセス速度が飛躍的に向上
- メモリ上でデータを扱うが、データをストレージに保存することが出来る
 - しかし揮発性が無くなるわけではないので数秒分等のデータが消える場合がある
- マスター・スレーブ型レプリケーションの仕組みを持っている
  - 1つのマスターに対し複数のスレーブを作成し、スレーブはマスターとデータの同期を行いながら読み込みに応答する仕組みです。これにより負荷が分散します
- 一般的なキーバリューストアにはデータ型がないがRedisにはある
- 主な使用目的としてキャッシュやセッションの管理、リアルタイムのデータ更新等に使う
  - 商品・ユーザー・コンテンツなどのデータをリスト化した状態で保持し、変化があれば更新やソートを行います
  - ユーザーのアクションをWebサイトの他のデータと連携・反映するような仕組みを作る利用シーン

## マスター/スレーブ方式
- 複数の機器や装置などが連携して動作する際に、一つが管理・制御する側、残りが制御される側、という役割分担を行う方式
## レプリケーション
- 複製すること
## KVS 【Key-Value Store】 Key-Valueストア / キーバリューストア
- データ管理システムの種類の一つで、保存したいデータ（value：値）に対し、対応する一意の標識（key：キー）を設定し、これらをペアで格納する方式

## sidekiq
- Rubyで記述されたオープンソースのジョブスケジューラ
- デフォルトではスケジューリングを行わず、ジョブを実行するだけ

## ジョブスケジューラ
- 「ジョブをいつ行うか」、ということを前もってセットして自動でジョブを実行できる、ジョブ管理システムの機能
## レイテンシ
- データ転送における指標のひとつで、転送要求を出してから実際にデータが送られてくるまでに生じる、通信の遅延時間のこと

## DHCP(Dynamic Host Configuration Protocol)
- IPv4ネットワークにおいて通信用の基本的な設定を自動的に行うためのプロトコル
- IPv4での通信を行う際には、個々のホストに最低でも自身のIPv4アドレス、 サブネットマスク、デフォルトゲートウェイ、DNSサーバのアドレスを設定する必要があり、このような設定をすべて手動で行おうとすると、 ホストの台数が増えるに従って手間が増えたり間違いも起こりやすくなる、それに対応出来る

## Plig and Play
- 周辺機器をコンピューターに接続(plug)した時にコンピューターの基本ソフトが自動的に設定を行い、すぐに使える(play)ようにしてくれる機能またはその規格

## カプセル化
  - https://webpia.jp/encapsulation/
  - 外部から中身が見えない
  - 中身を意識しなくても使える
  - 情報を直接操作することをできなくして情報が壊れてしまうことを防止する
  - オブジェクト自身に適切な情報操作を委ねる
## ポリモーフィズム(多様性)
  - https://webpia.jp/polymorphism/
  - 中に入るものによって同じ関数でも違う処理を行える
  - 例
    - 設定
      - 動物のクラスがあり、それぞれ鳴き声を持っている
      - 犬 → ワン
      - 猫 → にゃー
    - ポリモーフィズムを利用しない場合
      - それぞれのクラスを直接呼び出し、鳴き声を取得することになる
        - 犬.鳴き声
        - 猫.鳴き声
    - ポリモーフィズムを利用すると
      - 動物の鳴き声を返すメソッドを作る
        - どの動物?かの部分だけ設定してあげればこの鳴き声が返ってくるよねという実装がされている
      - 鳴き声(犬) → ワン
      - 鳴き声(猫) → にゃー

## デベロッパーツールのパフォーマンスタブで処理時間の計測を行う
1. パフォーマンスタブを開く
2. 左上の黒丸(レコーディングボタン)を押下する
3. 処理を画面を操作して行う
4. 処理が終了したらstopボタンを押下する
5. 確認したい処理の範囲を選択する(画面の遷移状態が表示されているので目的の画面状態を範囲選択する)
  - さらにnetwork欄を開くことでAPIの処理時間を分かる


## unicorn
- ruby on railsを動かす為のwebサーバー

- 再起動
  - プロセスをフォークして行う
    - 自分のコピーを作成して古いものは新しいものに処理引継ぎ後削除している
  - 基本的にはリロードで問題ないが、rubyのバージョンアップ等環境変数が変わるような処理をした際はstopとstartで再起動をする必要がある
    - 環境変数を新しいものに変える為

## certbot
- 自動でSSL証明書を発行できるツール、更新も出来る
- デフォルトは期限が30日未満の証明書を更新する

## 引数の呼び方
- 値渡し
  - 引数に渡した変数の中身を共有する
  - メソッド内で何が起きても呼び出し元の変数は変化しない
  - 例
    ```
    a = 1
    method(a) # 左記メソッドは引数に3を入れる処理
    a = 1
    ```
- 参照渡し
  - 引数として渡した変数を共有する
  - メソッド内で渡した引数に変更が加えられると呼び出し元の変数も変化する
  - 例
    ```
    a = 1
    method(a) # 左記メソッドは引数に3を入れる処理
    a = 3
    ```
