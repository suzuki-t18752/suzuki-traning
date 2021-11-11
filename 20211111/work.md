### ruby plukメソッド
- 指定したcolumnのレコードをは配列で受け取る
```
Person.pluck(:id)
# SELECT people.id FROM people
# [1, 2, 3]
```
### ruby fetchメソッド
- keyに紐づく値を取得する
```
h = {one: nil}
p h[:one],h[:two]                        #=> nil,nil これではキーが存在するのか判別できない。
p h.fetch(:one)                          #=> nil
p h.fetch(:two)                          # エラー key not found (KeyError)
```
