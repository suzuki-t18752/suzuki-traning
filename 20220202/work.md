### ActiveRecord::ConnectionNotEstablished MySQL client is not connected
高負荷だっただけかな？

- エラーの出元
.rbenv/versions/2.7.5/lib/ruby/gems/2.7.0/gems/mysql2-0.5.3/ext/mysql2/client.c

- よくわからない

- ::ActiveRecord::Base.transaction { new_records.each { |r| r.save!(validate: false) } }
  - 大量の更新が走る処理だからやっぱり重たかったかな？？？

- 考えられるものとしてパケットサイズが大きすぎたもしくはタイムアウトしたかな？？

- 対処するなら
  - タイムアウト
    - mysqlならinnodb_lock_wait_timeoutという設定がありタイムアウト時間を制御してる
    - 設定 SET GLOBAL innodb_lock_wait_timeout = 数値
    - 確認 SHOW VARIABLES LIKE 'innodb_lock_wait_timeout';
  - パケットサイズ
    - mysqlならmax_allowed_packetという設定があり、パケットサイズの制限を制御できる
    - 設定 SET GLOBAL max_allowed_packet = 数値;
    - 確認 SHOW VARIABLES LIKE 'max_allowed_packet';
