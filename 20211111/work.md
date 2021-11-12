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

### git blame
- git blame ファイル名で使う
- 「最終コミットのハッシュ値」「コミットした人」「コミット日時」「行番号」「行の内容」
```
969c1f0e07 (name          2020-05-15 16:16:14 +0900  1) # frozen_string_literal: true
969c1f0e07 (name          2020-05-15 16:16:14 +0900  2) module nameController
969c1f0e07 (name          2020-05-15 16:16:14 +0900  3)   module Pages
969c1f0e07 (name          2020-05-15 16:16:14 +0900  4)     module aaaaa
969c1f0e07 (name          2020-05-15 16:16:14 +0900  5)       #
969c1f0e07 (name          2020-05-15 16:16:14 +0900  6)       class Pages
969c1f0e07 (name          2020-05-15 16:16:14 +0900  7)         include ::nameController
969c1f0e07 (name          2020-05-15 16:16:14 +0900  8)         include ::nameController
```
- ハッシュ値をgithubの検索バーに入れるとcommitやissueを検索できる
