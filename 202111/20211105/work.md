```
sudo /usr/local/siege/bin/siege --file=/home/suzuki/url_list.txt --reps=10000 --concurrent=100

#100クライアントで10000回アクセス
#varnish導入前
Lifting the server siege...
Transactions:                 457643 hits
Availability:                  99.79 %
Elapsed time:                5138.55 secs
Data transferred:           14560.67 MB
Response time:                  1.02 secs
Transaction rate:              89.06 trans/sec
Throughput:                     2.83 MB/sec
Concurrency:                   91.03
Successful transactions:      457470
Failed transactions:             980
Longest transaction:          111.55
Shortest transaction:           0.00
#導入後
Lifting the server siege...
Transactions:                 597756 hits
Availability:                 100.00 %
Elapsed time:                7127.83 secs
Data transferred:           19016.28 MB
Response time:                  1.19 secs
Transaction rate:              83.86 trans/sec
Throughput:                     2.67 MB/sec
Concurrency:                   99.93
Successful transactions:      597537
Failed transactions:               0
Longest transaction:           12.65
Shortest transaction:           0.06

Transactions    有効リクエスト数
Availability    Successful transactions / (Successful transactions + Failed transactions)
Elapsed time    全てのリクエスト送信までに経過した秒数
Data transferred        データ転送量
Response time   1リクエスト辺りの平均レスポンスタイム
Transaction rate        秒間リクエスト数
Throughput      秒間処理データ量
Concurrency     平均同時接続数
Successful transactions 成功リクエスト数
Failed transactions     失敗リクエスト数
Longest transaction     1リクエスト辺りにかかった最大秒数
Shortest transaction    1リクエスト辺りにかかった最小秒数
```

git checkout main
git pull origin main
git tag v1.0.0
git push --tags

少し待つとreleasesに表示されるので編集画面にいってpublishに変更する(最新だとlatestになる)


sudo sed -i -e 's%http%https%g' /home/suzuki/url_list.txt
sudo sed -i -e 's%https%http%g' /home/suzuki/url_list.txt

↓
varnishのテストは同じページへの複数回アクセスをしないと意味がないよ！！！！


### tabindex:数字
- タブを入力した時の参照順番

### rails merge
- ハッシュを結合するメソッド
```
h1 = { "a" => 100, "b" => 200 }
h2 = { "b" => 246, "c" => 300 }
h3 = { "b" => 357, "d" => 400 }
h1.merge          #=> {"a"=>100, "b"=>200}
h1.merge(h2)      #=> {"a"=>100, "b"=>246, "c"=>300}
h1.merge(h2, h3)  #=> {"a"=>100, "b"=>357, "c"=>300, "d"=>400}
h1.merge(h2) {|key, oldval, newval| newval - oldval}
                  #=> {"a"=>100, "b"=>46,  "c"=>300}
h1.merge(h2, h3) {|key, oldval, newval| newval - oldval}
                  #=> {"a"=>100, "b"=>311, "c"=>300, "d"=>400}
h1                #=> {"a"=>100, "b"=>200}
```

### sanitize_sql_like
- LIKE句のサニタイズを行いメソッド

### サニタイズ
- 特別な意味を持つ文字の特別さを無効化して、意図していたのと違う動きをしないようにする処理のこと
- エスケープ文字等をそのままの文字列として扱うことが出来る
- sqlのインジェクション対策になる

add email search to user search
