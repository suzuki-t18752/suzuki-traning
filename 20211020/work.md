# マイグレーション

## URLをDBに保存する場合の型について
- 許容文字数はどれぐらい？

- URLの長さについてはクライアント側に左右される
- IEは2083文字、他ブラウザは制限なし

[URLの長さについて](https://www.tyto-style.com/blog/archives/2725)
https://codenote.net/webservice/5313.html
https://www.softel.co.jp/blogs/tech/archives/441

- URLの長さは2000文字以下が理想らしい

```
SHOW VARIABLES LIKE 'character_set_server'; -- utf8mb4
SHOW VARIABLES LIKE 'character_set_client'; -- utf8mb4

SELECT LENGTH('a'); -- 1
SELECT LENGTH('あ'); -- 3
SELECT LENGTH('😀'); -- 4
```

phpのpost上限はデフォルトで2Mだいたい2Mかな？
```
$ grep -r "size" config/ansible/
config/ansible/roles/nginx/files/production/~~~~~.com.conf:        client_max_body_size 11m;
config/ansible/roles/nginx/files/staging/~~~~~.com.conf:        client_max_body_size 11m;
```

- スプレッドシートのURLの最大長はわからなかった
- スプレッドシートの1セルの最大文字数は5万文字
- utf8mb4の1文字あたりの最大バイト数が4バイトなので5万文字×4バイトで20万バイトが上限？
- そもそもスプレッドシートのURLが半角英数なので5万バイトが上限
- でもそこまでの容量はいらない
https://docs.google.com/spreadsheets/d/1t23Q93IhrR9WGEStayE2H_UGZ6ZHsKG1ufsJzLwnvyc/edit#gid=0  
1t23Q93IhrR9WGEStayE2H_UGZ6ZHsKG1ufsJzLwnvycの部分が恐らく固有の値が入っているので5万文字もいらない
- 300文字もあれば十分

- VARCHAR カラム内の値は可変長の文字列、長さは 0 から 65,535 までの値で指定(65,535バイトがmysqlの上限)
- CHAR 固定長の文字列で0文字の入力でも255の設定をしていたら255バイトのデータがはいっていることになってしまう


## カラム追加用ファイルを作成する
[参考](https://railsguides.jp/active_record_migrations.html)
```
# migrateファイルの作成
rails generate migration AddConfigSheetUrlToProducts config_sheet_url:string

#中身
#stringがvarchar
#limitでサイズを変更(varchar(300)と同じ扱い)
#defaultにてnilを入れるとnullと同じ扱い、別にnullでも良い、nullを許容していない場合空白文字、許容していればnullが入る

class AddConfigSheetUrlTo~~~~~~ < ActiveRecord::Migration[6.0]
  def change
    add_column :~~~~~~, :config_sheet_url, :string, limit: 300, null: true, default: nil, comment: '~~~~~~', after ~~~~
  end
end


#マイグレーションの実行
$ rails db:migrate

#1つ前に戻す
#$ rails db:rollback
#マイグレーション済みか確認する
#$rails db:migrate:status
```

## config_sheet_urlのカラムを追加したのに画面の更新処理にて更新されない
コントローラー内でパラメータをメソッドで管理していた為
メソッド内にconfig_sheet_urlを追記


## バリデーションについて
- railsのバリデーションは下記の実行時に行われる
  - create
  - create!
  - save
  - save!
  - update
  - update!

- valid?とinvalid?で任意のタイミングでバリデーションをかけることが出来る

- format
  - 正規表現と値が一致するの確認する

- :allow_nil
  - 値がnilの場合にバリデーションをスキップする

- :allow_blank
  - blankの場合(nil, false, "", " "(半角スペースのみ), [](空の配列), {}(空のハッシュ))の時バリデーションをスキップする


- 正規表現
```
validates :config_sheet_url, format: /\A#{URI.regexp(%w(http https))}\z/, length: { maximum: 300 }, allow_blank: true

rubocop app/models/~~~~~.rb
Inspecting 1 file
C

Offenses:

app/models/~~~~~rb:93:56: C: Style/PercentLiteralDelimiters: %w-literals should be delimited by [ and ].
  validates :config_sheet_url, format: /\A#{URI.regexp(%w@http https@)}\z/, length: { maximum: 300 }, allow_blank: true
↓
#かっこを変更
validates :config_sheet_url, format: /\A#{URI.regexp(%w[http https])}\z/, length: { maximum: 300 }, allow_blank: true
```

