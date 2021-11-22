### 本番反映時の反映順序と反映後不具合があった場合の対処方法まで考える
[ロールバック](https://dev.mysql.com/doc/refman/5.6/ja/commit.html)
- 一時的にならロールバックできるが反映後にファイルを変更してデータも戻したいとなった場合にどうするか？

- 一般クエリログ
  - 全ての実行されたコマンドを記録する
  - general_log
    - 一般クエリログを採取するか否か示します。1:ロギングする、0:ロギングしない
  - general_log_file
    - 一般クエリログのファイル名を設定します。指定しない場合は、ホスト名.log のファイル名で保存されます。
  - log_output
    - 一般クエリログとスロークエリログの出力先ディレクトリを設定します。
    - TABLE:テーブルへのログ、FILE:ファイルへのログ、NONE:テーブルまたはファイルにログしない のいずれか。

```
general_log=1
general_log_file="/var/log/mysql/sql.log"
log_output=FILE
```


- バイナリログ
  - データの更新が行われる処理を記録する
  - log_bin
    - バイナリ ログ を採取するか否か示します。ここにログファイル名を指定することで、有効にします。
  - expire_logs_days
    - バイナリログの保存期間を日数で指定します。この日数を超えたものは削除されます。デフォルト 0 は、削除しません。

```
log_bin="/var/log/mysql/bin.log"
log_bin_index="/var/log/mysql/bin.list"
max_binlog_size=1M
expire_logs_days=1
```
↓
これだと再起動時にエラー発生
↓
server-id=1の指定も必須
```
[mysqld]
datadir=/usr/local/mysql5.7/data
socket=/usr/local/mysql5.7/data/mysql.sock
port=3306

character-set-server=utf8
collation-server=utf8_general_ci

symbolic-links=0


log_bin=/var/log/mariadb/
expire_logs_days=7
server-id=1

general_log=1
general_log_file=/var/log/mariadb/sql57.log
log_output=FILE


[mysqld_safe]
log-error=/var/log/mariadb/mariadb.log
pid-file=/var/run/mariadb/mariadb.pid


#
# include all files from the config directory
#
!includedir /etc/my.cnf.d

```


/usr/local/mysql5.7/bin/mysql -u root -presuraku0901 --socket=/usr/local/mysql5.7/data/mysql.sock -t -e"select * from hoge4"


### 複数行まとめてファイルに入れる
```
cat << "EOF" > testfile.txt
```
### diffにコマンドの出力結果を使う、出力結果のcatを行う
diff <(find /etc -name "my.cnf.bak*" | xargs cat) /etc/my.cnf_bak
