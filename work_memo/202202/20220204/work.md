# 通知系の処理を追加する場合の注意
- 通知頻度の確認を
  - 条件的にあまりにも頻度が高くなりそうな場合は

# MIME(マイム)タイプ（英：media type）とは
- メールやホームページのファイルにくっつけて送られる「このファイルは、こんな種類のファイルですよ」な情報

## ruby Hashのデフォルト値
- Hash.new()で予め値を入れておくと値を設定していないkeyの値がHash.newで設定した値になる
- keyのデフォルト値を設定出来る
```
[1] pry(main)> a = Hash.new('test')
=> {}
[2] pry(main)> a[:test]
=> "test"
[3] pry(main)> a[:wq]
=> "test"
```
