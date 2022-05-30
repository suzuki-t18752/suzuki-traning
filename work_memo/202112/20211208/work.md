# sideloq
- sidekiqを動かす前に必ずjobが溜まっていないか確認する
  - 溜まっていると起動した時に大量のjobが流れてしまう
```
bundle exec sidekiq -C config/設定ファイル名
```

# sidekiq

## 設定
```
suzuki@DESKTOP-G7N3ULO:~/suzuki$ cat config/redis.yml
default: &default
  host: <%= ENV.fetch('suzuki_REDIS_HOST', '127.0.0.1') %>
  port: <%= ENV.fetch('suzuki_REDIS_PORT', 6379) %>
  dbs:
    sessions: 0
    sidekiq: 1
    app: 2
```

## コマンドライン
```
#コマンドライン起動
suzuki@DESKTOP-G7N3ULO:~/suzuki$ redis-cli
#設定確認
127.0.0.1:6379> info

127.0.0.1:6379> select 0
OK
127.0.0.1:6379> select 1
OK
127.0.0.1:6379[1]> select 1
OK
127.0.0.1:6379[1]> keys *
1) "queues"
2) "queue:default"

# type確認
#setは重複のないlist
#list、配列
127.0.0.1:6379[1]> type queues
set
127.0.0.1:6379[1]> type queue:default
list

#コマンドラインを開かずに直接
#
~/suzuki$ redis-cli -n 1 lrange queue:default 0 -1
(empty list or set)

~/suzuki$ redis-cli -n 1 smembers queues
(empty list or set)
#job削除
~/suzuki$ redis-cli -n 1 flushdb
OK
#job全削除
~/suzuki$ redis-cli flushall
OK
```

- KEYS *	redis に登録されているキーの一覧を取得
- TYPE <key>	VALUE の種類
- GET <key>	TYPE が string だった場合の値をみる
- LRANGE <key> 0 -1	TYPE が list だった場合の値をみる
- SMEMBERS <key>	TYPE が set だった場合の値をみる
- ZRANGE <key> 0 -1	TYPE が zsetだった場合の値をみる
- HGETALL <key>	TYPE が hash だった場合の値をみる
- HKEYS <key>	TYPE が hash だった場合に field の一覧をみる
- HVALS <key>	TYPE が hash だった場合に value の一覧をみる
- MONITOR	redisサーバが受けとったコマンドを表示する
