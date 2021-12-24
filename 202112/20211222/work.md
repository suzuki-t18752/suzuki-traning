## constantize
- 文字列からクラスを検索してくれる

## ruby each map
```
[1] pry(main)> test = [1, 2, 3]
=> [1, 2, 3]
[2] pry(main)> test.each {|t| t*2}
=> [1, 2, 3]
[3] pry(main)> test.map {|t| t*2}
=> [2, 4, 6]
```
- map
  - 処理した結果を配列で返す
- each
  - 処理を行って元の配列をそのまま返す
